import { sdk } from '@farcaster/frame-sdk'
import { useEffect, useState } from 'react'
import { useAccount, useConnect, useReadContract, useWriteContract } from 'wagmi'
import { config } from './wagmi'
import { switchChain } from 'wagmi/actions'
import { parseEther } from 'viem'

function App() {
  const { address, isConnected } = useAccount()

  const { connect, connectors } = useConnect()

  useEffect(() => {
    if (isConnected) {
      switchChain(config, { chainId: config.chains[0].id })
      refetch()
    } else {
      connect({ connector: connectors[0] })
    }
  }, [isConnected])

  const { writeContract, data: txId } = useWriteContract()

  const {
    data: tokenId,
    isError,
    refetch,
  } = useReadContract({
    address: '0x201DbdC89D5C5CE42c4E77F0D327F3F4B6F6746A',
    abi: [
      {
        type: 'function',
        name: 'mintedBy',
        inputs: [{ name: 'minter', type: 'address', internalType: 'address' }],
        outputs: [{ name: '', type: 'uint256', internalType: 'uint256' }],
        stateMutability: 'view',
      },
    ],
    functionName: 'mintedBy',
    args: [address!],
    query: {
      enabled: !!address,
    },
  })

  const { data: totalSupply, refetch: refetchTotalSupply } = useReadContract({
    address: '0x201DbdC89D5C5CE42c4E77F0D327F3F4B6F6746A',
    abi: [
      {
        type: 'function',
        name: 'totalSupply',
        inputs: [],
        outputs: [{ name: '', type: 'uint256', internalType: 'uint256' }],
        stateMutability: 'view',
      },
    ],
    functionName: 'totalSupply',
    args: [],
  })

  useEffect(() => {
    if (totalSupply) return
    setInterval(() => {
      refetchTotalSupply()
    }, 7000)
  }, [totalSupply])

  useEffect(() => {
    console.log(3)
  }, [isError])

  useEffect(() => {
    if (!txId) return
    setTimeout(() => {
      refetch()
      refetchTotalSupply()
    }, 1000)

    setTimeout(() => {
      refetch()
    }, 2000)

    setTimeout(() => {
      refetch()
    }, 3000)

    setTimeout(() => {
      refetch()
    }, 5000)

    setTimeout(() => {
      refetch()
    }, 10000)

    setTimeout(() => {
      refetch()
    }, 20000)
  }, [txId])

  const [material, setMaterial] = useState<string>()
  const [image, setImage] = useState<any>()

  useEffect(() => {
    if (!tokenId) return
    setMaterial(getMaterial(tokenId))
    setImage(getImage(tokenId))
  }, [tokenId])

  useEffect(() => {
    sdk.actions.ready()
  }, [])

  useEffect(() => {
    let id: number
    if (isConnected) {
      clearInterval(id! && 0)
    } else if (window.self !== window.top) {
      id = setInterval(() => {
        connect({ connector: connectors[0] })
      }, 1500)
    }
  }, [isConnected])

  return (
    <>
      <main className='flex flex-col gap-6 w-full sm:max-w-xs flex-1'>
        <div className='flex-col flex gap-6 flex-1'>
          <div className='flex flex-col gap-1.5'>
            <h1 className='font-bold text-center text-5xl'>MoMoney</h1>
            <p className='font-bold text-center text-2xl'>more problems!</p>
          </div>

          <h3 className='font-bold text-xl text-center'>{totalSupply ? totalSupply.toString() : '?'} / 10000 </h3>
          {!!tokenId ? (
            <div className='flex flex-col gap-4'>
              {image}
              <h2 className='font-bold text-2xl text-center'>MoMoney #{tokenId.toString()}</h2>
              <h3 className='font-semibold text-lg text-center'>Material: {material}</h3>
            </div>
          ) : (
            <div className='rounded-3xl  bg-[#0b3800] text-[#51fd00] aspect-square flex flex-col items-center justify-center text-7xl'>
              <p className='animate-spin'>?</p>
            </div>
          )}
        </div>
        {isConnected ? (
          <button
            disabled={tokenId !== undefined || totalSupply === 10000n}
            className='bg-[#0b3800] text-[#51fd00] font-semibold text-xl h-13 px-6 rounded-full disabled:cursor-not-allowed cursor-pointer'
            onClick={async () => {
              await switchChain(config, { chainId: config.chains[0].id })
              writeContract({
                abi: [{ type: 'function', name: 'mint', inputs: [], outputs: [], stateMutability: 'payable' }],
                address: '0x201DbdC89D5C5CE42c4E77F0D327F3F4B6F6746A',
                functionName: 'mint',
                args: [],
                value: parseEther('1'),
              })
            }}
          >
            {tokenId ? 'You Minted' : totalSupply === 10000n ? 'All Minted' : 'Mint for 1 MON'}
          </button>
        ) : (
          <a
            href='https://warpcast.com/~/mini-apps/launch?domain=momoney.pages.dev'
            className='bg-[#0b3800] text-[#51fd00] flex justify-center items-center font-semibold text-xl h-13 px-6 rounded-full'
          >
            Open in Warpcast
          </a>
        )}
      </main>
      <footer className='flex flex-col gap-12 w-full items-center text-center'>
        <div className='flex items-center gap-6'>
          <a
            href='https://magiceden.io/collections/monad-testnet/0x201DbdC89D5C5CE42c4E77F0D327F3F4B6F6746A'
            target='_blank'
            className='w-11'
          >
            <svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 173.35 104.11'>
              <path
                fill='#0b3800'
                d='m122.81 26.5 10.15 11.93c1.17 1.34 2.19 2.44 2.62 3.07 3.04 3.02 4.74 7.09 4.74 11.34-.28 5.02-3.56 8.43-6.57 12.09l-7.1 8.34-3.71 4.32c-.13.15-.22.33-.25.53s0 .4.09.58c.08.18.22.33.4.44.18.11.38.15.58.14h37.04c5.65 0 12.78 4.76 12.37 11.97 0 3.27-1.34 6.42-3.69 8.74-2.36 2.32-5.55 3.63-8.87 3.64h-58c-3.82 0-14.08.41-16.95-8.34-.61-1.83-.69-3.79-.24-5.67.84-2.77 2.16-5.37 3.9-7.69 2.92-4.32 6.08-8.65 9.19-12.84 4.02-5.49 8.14-10.8 12.19-16.4.14-.18.22-.41.22-.64s-.08-.46-.22-.64L95.96 34.12c-.09-.13-.22-.22-.37-.29-.14-.07-.29-.11-.46-.11s-.32.04-.46.11-.27.18-.37.29c-3.95 5.25-21.23 28.51-24.91 33.22s-12.76 4.97-17.79 0L28.55 44.53c-.14-.14-.33-.25-.54-.28-.2-.04-.41-.02-.61.06-.19.08-.35.21-.47.39s-.18.38-.18.58v43.84c.06 3.11-.88 6.16-2.67 8.73-1.79 2.56-4.36 4.51-7.33 5.56-1.9.65-3.92.85-5.91.57-1.99-.28-3.89-1.02-5.52-2.17-1.64-1.14-2.98-2.66-3.9-4.42C.5 95.63.01 93.68.01 91.7V12.87c.13-2.84 1.17-5.57 2.97-7.8C4.76 2.84 7.22 1.23 10 .47c2.38-.62 4.89-.62 7.27.02s4.55 1.88 6.28 3.62l35.43 34.96c.11.11.24.19.38.24s.29.07.45.06c.15-.01.29-.06.42-.13s.25-.18.33-.29L85.73 4.59c1.17-1.39 2.63-2.52 4.28-3.3C91.66.51 93.46.1 95.3.08h65.48c1.79 0 3.56.39 5.19 1.12 1.63.73 3.09 1.8 4.26 3.13 1.18 1.33 2.06 2.9 2.58 4.58.52 1.7.66 3.47.42 5.22-.46 3.04-2.03 5.81-4.41 7.79-2.38 1.99-5.4 3.06-8.52 3.02h-36.67c-.19 0-.37.06-.52.15-.15.09-.28.24-.37.39-.08.16-.13.34-.12.52 0 .18.07.35.18.51h-.01Z'
              />
            </svg>
          </a>

          <a href='https://x.com/berzanorg' target='_blank' className='w-10'>
            <svg xmlns='http://www.w3.org/2000/svg' width='32' height='32' viewBox='0 0 512 512'>
              <path
                fill='#0b3800'
                d='M389.2 48h70.6L305.6 224.2L487 464H345L233.7 318.6L106.5 464H35.8l164.9-188.5L26.8 48h145.6l100.5 132.9zm-24.8 373.8h39.1L151.1 88h-42z'
              />
            </svg>
          </a>

          <a href='https://github.com/berzanorg/momoney' target='_blank' className='w-10'>
            <svg xmlns='http://www.w3.org/2000/svg' width='31' height='32' viewBox='0 0 496 512'>
              <path
                fill='#0b3800'
                d='M165.9 397.4c0 2-2.3 3.6-5.2 3.6c-3.3.3-5.6-1.3-5.6-3.6c0-2 2.3-3.6 5.2-3.6c3-.3 5.6 1.3 5.6 3.6m-31.1-4.5c-.7 2 1.3 4.3 4.3 4.9c2.6 1 5.6 0 6.2-2s-1.3-4.3-4.3-5.2c-2.6-.7-5.5.3-6.2 2.3m44.2-1.7c-2.9.7-4.9 2.6-4.6 4.9c.3 2 2.9 3.3 5.9 2.6c2.9-.7 4.9-2.6 4.6-4.6c-.3-1.9-3-3.2-5.9-2.9M244.8 8C106.1 8 0 113.3 0 252c0 110.9 69.8 205.8 169.5 239.2c12.8 2.3 17.3-5.6 17.3-12.1c0-6.2-.3-40.4-.3-61.4c0 0-70 15-84.7-29.8c0 0-11.4-29.1-27.8-36.6c0 0-22.9-15.7 1.6-15.4c0 0 24.9 2 38.6 25.8c21.9 38.6 58.6 27.5 72.9 20.9c2.3-16 8.8-27.1 16-33.7c-55.9-6.2-112.3-14.3-112.3-110.5c0-27.5 7.6-41.3 23.6-58.9c-2.6-6.5-11.1-33.3 2.6-67.9c20.9-6.5 69 27 69 27c20-5.6 41.5-8.5 62.8-8.5s42.8 2.9 62.8 8.5c0 0 48.1-33.6 69-27c13.7 34.7 5.2 61.4 2.6 67.9c16 17.7 25.8 31.5 25.8 58.9c0 96.5-58.9 104.2-114.8 110.5c9.2 7.9 17 22.9 17 46.4c0 33.7-.3 75.4-.3 83.6c0 6.5 4.6 14.4 17.3 12.1C428.2 457.8 496 362.9 496 252C496 113.3 383.5 8 244.8 8M97.2 352.9c-1.3 1-1 3.3.7 5.2c1.6 1.6 3.9 2.3 5.2 1c1.3-1 1-3.3-.7-5.2c-1.6-1.6-3.9-2.3-5.2-1m-10.8-8.1c-.7 1.3.3 2.9 2.3 3.9c1.6 1 3.6.7 4.3-.7c.7-1.3-.3-2.9-2.3-3.9c-2-.6-3.6-.3-4.3.7m32.4 35.6c-1.6 1.3-1 4.3 1.3 6.2c2.3 2.3 5.2 2.6 6.5 1c1.3-1.3.7-4.3-1.3-6.2c-2.2-2.3-5.2-2.6-6.5-1m-11.4-14.7c-1.6 1-1.6 3.6 0 5.9s4.3 3.3 5.6 2.3c1.6-1.3 1.6-3.9 0-6.2c-1.4-2.3-4-3.3-5.6-2'
              />
            </svg>
          </a>
        </div>
        <p className='font-medium'>
          The first pure on-chain experimental NFT on Monad Testnet by{' '}
          <a href='https://x.com/berzanorg' target='_blank' className='underline'>
            Berzan
          </a>
          .
        </p>
      </footer>
    </>
  )
}

export default App

function getMaterial(tokenId: bigint) {
  return tokenId < 10 ? 'Diamond' : tokenId < 100 ? 'Gold' : tokenId < 1000 ? 'Silver' : 'Cash'
}

function getImage(tokenId: bigint) {
  const bg = tokenId < 10 ? '#00f0fe' : tokenId < 100 ? '#ffd404' : tokenId < 1000 ? '#d4d4d4' : '#51fd00'
  const fg = tokenId < 10 ? '#00314e' : tokenId < 100 ? '#393100' : tokenId < 1000 ? '#2d2d2d' : '#0b3800'

  return (
    <svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 2048 2048' className='rounded-3xl'>
      <path fill={bg} d='M0 0h2048v2048H0V0Z' transform-origin='1024px 1024px' />
      <text
        fill={fg}
        stroke-width='0'
        font-family='system-ui'
        font-size='512'
        font-weight='700'
        style={{ whiteSpace: 'pre' }}
        text-anchor='middle'
      >
        <tspan x='1024.06' y='1218.06' text-decoration='overline solid color(srgb 1 1 1/.8)'>
          #{tokenId.toString()}
        </tspan>
      </text>
    </svg>
  )
}
