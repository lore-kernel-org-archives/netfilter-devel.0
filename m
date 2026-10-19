Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792437499;
	b=BSeFFyTrji+nOYgrLjxIEffWNdREmnyGdt+jQScayA8W46MQUkPzr3iTP1xVTv5tGiut
	 pwgwe68NbB/2PGdlv6H4tXkrIq5+UxPucqPIeDufsN3p5vSeOLHw6GO6mHkvPtCGOvfHM
	 tEZA5hVXB0C7n5WJtqx2tfbUv8TsXQdpg5oBO9hnJpvbeRDXfG/YM9xxVsOvloGPE4UfI
	 n0LXpCbDZCCwifeb8qimB1hBZjYgs/KZ7ejufST1nFXsW7xdUQ/nT21xZyzuo8x+yHQUc
	 S+EIuu+SJ2+t6T2FpkZw9HEhY4kYqr9hd5VNgm/KvEtPwD9PJmZ+eWa+MW1nLCTQS7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792437499;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Content-Language:From:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=BUTIn5r4eoMH2MaHTZixGcFVAOua3PtHQ2DlH/jQniI=;
	b=HDoKZN0y5cfCZcsQHgPhil/5Tf1FnJATt4YGF9Nv/x6jVM7bcD5OVMrxWsMYItHbB2Z8
	 n2ZC0mgTBDIkoxva+dOhaGyIWCAePLhdSYQ8ecMPn6GZje0+jyxR6Ikcx+W/3MxLZxBPH
	 XrFO1G6JouFku5KvUU132Zi3CKArlu5KQfBLPzvmQxZHyYaDdJmtpXb8rbPf+CKcV/2uF
	 zDds90ain3Hdhupaf/r28BuotyV2IsIAwt74wHDtO8TlbEr078KWwSu1wB/6MnxIWoU6e
	 cKhhiO1Ha+ldMYdXrOoeChA7n5I5mo1UeAuBzyUOjenu3y05VVKJiyTLH8tItGZDQhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=krause.markus@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=QkLLiFGg;
	arc=none smtp.remote-ip=212.227.17.22
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F64A606A31E;
	Mon, 19 Oct 2026 19:18:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F64A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=krause.markus@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=QkLLiFGg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1792437491; x=1793042291; i=krause.markus@gmx.com;
	bh=BUTIn5r4eoMH2MaHTZixGcFVAOua3PtHQ2DlH/jQniI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:From:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=QkLLiFGgYQkEFA+Dprv7fwymTwAsTnUPmxQQbIYPw91J5wuNIoBtrpWACP8P/NJT
	 alngMnmwOfRiCYDQH77K22DaKnysxZ+q//yi51REE3XU7BtqDPF8TDxxalRN2FiP7
	 KMNYeFexApDragkI4Ids9WNUXT9xhy83mSQQwaeI0oAnPdNRPvGjaZ3QLZE4Cez9v
	 bGklZyUfWpSPXMGxVqHgYWXJtrtPasqd+6f1YjezuQN2V731bG3lUV/d8zF8r5ilM
	 FDBsKbEPoffxSVYKsJIQb3K67jxOwBESSaNbaR8Iil0v2EL/x5YUCYe2su2ESyfDR
	 mlV4ZhGoiclO+7ydSQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MBUqF-1xSSqa2eAp-004nzs; Mon, 19
 Oct 2026 21:18:11 +0200
Message-ID: <eec6c986-3d59-4471-a867-9cf77db1fc27@gmx.com>
Date: Mon, 19 Oct 2026 21:18:09 +0200
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Markus Krause <krause.markus@gmx.com>
Subject: [RFC] staging: octeon: upstream suitability of CN50xx forwarding
 acceleration
To: linux-staging@lists.linux.dev, netdev@vger.kernel.org
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
 andrew+netdev@lunn.ch, gregkh@linuxfoundation.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:8NS51a3XuiDrZr3MC/dLvFD1A0qghRSSRzKDM74H5fUglKjo2aS
 eShw4vOSQt1EOmW8d/wNau2wbCN+4nGLZeFq6NnD1pwfb5jLgZXpA192IAOOVVC81xLLoxB
 AAfeWNnrSQBekAWW3tV2gWLmf0EGzqE2TbUfBIVaE83rY0i7ohg7Bj/nxsHPXfNPzGiQmGd
 eB7KEbKmJuPOqO4TNLMxA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:XwvMDXifAJQ=;z/AVZaJdmmyP5tTlOXkj5GGHIlf
 CpmGlPCFc9MYSD3d0WRypnPri494QHJqzpzp+lnwK0OcTOpGR41a3t0ldc1m9fMjjaNb8G6O4
 2Rg36WA8tLnpQ0I12mqVv30ThlfP3Jf6imq8vdOhu0Kq93qr9MmHhq9GjC8uDapvP/lrCiMl/
 OvLE8Et7UipwU93O8OC7Fdfz/1srksCbWuxDZRVH7aExgt4Y8/kDnb7Qa1UA81Ez0R0zlgnQA
 M6MfX+x+FBRda0nS3kTU6uwApSiJfY/pYoJD0YGOtRl0sDDP5aZ33vBD5NQctL3pIBmmLHuKU
 i88RKVlQgraSBmlANYrzOklIM8H0XgbZibccvEi4DiUGrP6FhfZHoPnTf9+Ncz+OZdBx9iGSY
 nUp5nxgqNPsvcR6eC583nb8e/6j2goEjciwW48PlGgNnJORgrSQJqnx7HnvkfNuHYULYjPBLG
 oQ1ZNmLe7hg+kLLyqL7MzPZ/KyMA9OqF0NQalwUJIJgVX9MM9FdWZz41+v+8BmmW89YEUvmA0
 j0ZLrxg9FyrY4S+rF3sCTtDbv35lKuj6PIuMaF0OOnSByO/aMsfgo5pp4ZflNEvP4RSiWaBf8
 KEwb6BkNv5o5h6QR+bh5E9SbP2rPvt9s25KtyYiG/B5XZ+evXcfbNnWC++AvT8xA7WOo968Nm
 LWVkB/4rqpgBYd9mL/VDANx88Paw13NuU0reNrWKyGZTnayAuSeFMT1LsiBpZANS6+RTGmHFN
 cNDF8lmbDu4yiXi5CEjw1JKtKDqOVqmdTw2IhJw7AAv7K5o2LZiRRY+lVQxQQqJWEEi3Dni++
 MmB8/2NI82aQLpuJoYfZ3ZpMCZLgWNw+GHdQZGwZg4lh+NDdDUObbSkjCDDsjZWB+pSEWvxLc
 KhJhbcJd+OfByyGJ5f+lUU53BGNmUsQ3KEooj7ZBgp/WLusjQK3ud1mIcLzwnBsEzQTjOh3Gw
 xKz8VZXbpls2bq9X+0TIm2qqwwjMS37QYOtVPWaWXYVKcqBpBf8IeIvTAT+iZATxGBxA5fRCQ
 CwEYs0Z2jlndNBsk8lWp03RLar1daBlBesavhMOiZUap7jBPhJs2NBrkHs05uZVqIz9guVCjf
 Q6Vw7qXgHUHCBQFBSFw9KRBivGfnwS0ZRjZ41sqmwZb12BhlF3aOpE8FjKzns6ASC9b8nN9Ra
 P7oZnapkk9dp4V9Yfm7MdsoN1zs6hc0QyODKd7hLxQfxjz9/+EXD7yHxrM45v1ul56lmpLxhJ
 GlJ4yk+S3fYlxb97UO4U7gt61WXZGAZk4HIIHHrBP0o1/p6q6jQZ7MnHYXLABq9sRfA3WcO6x
 fe/MZfeXRDG+w8pubBFFyqxSZVeKqsyGuWC4D0Ykbr5HSF4QcyiUnuR5OGCXbOCRi9jWlUNVE
 4Yl+uWaqGvW80CDtqhlEtK6Kb2HRQ8+ph+Re5NE4VS385SMZ+/fiI2yoEZPBhXxxjNmWaly4f
 Traiz23SP6nJ7dUVhdTnIYcitpC0ZpIKvAiH1hNcHCypseFkppC32EHGBZ6q3RWz7tQO5QAy/
 oJme+DSelcCJctK3D7ri0YrYiXZbDIF7EZKVeaQ7P2qAozbowyqilX81Mqa5HBjuELt+05sCY
 VOvI5lMqp0B+94qQqiH8zLUGKLmDHEjdMMIthcQ729Hv5emewwl0DCmKqnH2zv74rkJtXB0JM
 7t6PtTBzwwBReV61Plz0HImXHPrs0YaRoS0ZiB76X3kmJDO1ye554jVc1+b6qg5hJr/AgsAWG
 NdT8K5JgZ9jhahdlCyV63b4VdgKahDqTW0Ab9Joer0B+81/FWRNaPLuKBChVkXm7HBsPupDjl
 lHCPDUdnlwHE647BSLVPz35+O6KejSdjlBG9h88k+VrUdipOmLRyzGj4NYcd8ocMY2aL6sm7l
 2G2CC8nlmwoWDXi76QD019UEUxTVL8KoAPkKGrVmBz2Vlhzk+ReljkyL0i2s3EfcpqpY0O5gb
 Ga6um+QlhtuAkdYwzLnrx2cpyxNiyZeiX9kcbY6PmZjqVJwi4w/+n0YvrowOPS/upLZJ3ShdA
 SOej2r5qAMV70D3aZL0wt7XerE9qmwgadpuy9VfjOUgZI7X9b4bfHIP6XJ4P+m+8HPUz100wr
 ynCupQyuqVH+/Xvp4BMVDxvr7bpyVK1jMTixLNav+qLw6xZHeu5hVG3ZIS42m4G6D/0y5EiRw
 k4IqSZjg3A2QWzOcA04FnK+KLjpi0rd9Bm8XMmnn21+a5EybuN2/GvGyvx+OCeusi9ZMGJu5E
 jcGjJ/9wiW9fysbE9Xkv5GoCPMEWcwRNggiy6l2Nj4t+aoCigid//k24HJIpAMPKn0r276/Ga
 /I3sJnyPjBMOBRMjp3WS3Btao+pTzK2nAJPzML2eGS8SqloD8ubPTh/9i1ONKqNcOot3hA6Hp
 CZSS/P2IAwFBDDTH0+k7iZ11690ygCxgHGZHattO4HokHiJwVoLJ/WhPqrBcrVRdthEi7SnlU
 2BRAyyPZ+v9ndFh+cFxAQYbemh4mRmcBx+geEh+2+TjDrr7i1ghUnQHeQyWkI6bY6Sp/HQkcL
 ny7l9B52Lp9qVGFTmje8SFIPmiA9FXzNuyKuHoKoN63IxJRCMdw1KFfcvbQyjCgF9eVB4ioIi
 HM0TKSpwDXP6gczz6/UsmxtxLlpZa8GvJXg8DVFke6K0cxt2GOq2X1dHtum1irA8khKt/fxGC
 G0HQnkscwwM1D27YLTxtF1h3iaL4WxAsbT6TbA7hISEWthxqcSEphPdivP4jZvBfz7V/j6Q93
 QHQ2gLZTU/ur8sAy2WlPHqSoRKbUNKMgVW7wuPGX7YnKUxkJ7cW0q80W3X/V80AZK9ln6WfHN
 hhqn500HTDPXTFsCMwAnTqbLSyhrOAOfHEpPoMvCr2mxocVHNMf672nMAr/XMCGbRKKfj+l8A
 /m6Tz317LR3ukoZm63ewxYNgpAXh/XSRD/o1O+ylf93TIymtk9Hx7rdaAqGkgDke/HpT+oNYB
 ES4LQxdVMwEBOqqcP0jOC0roxaZH+uKOzKTTDpw/QcN2eH72FKcBiF/UqEfr0tZcMN+3Z0hwB
 wHfvpFQ7iwFJh3WRCAHckFaLA2s5Xe/24pUvkfBEw4URodDIGw2fnkV0b9r4yfriqUIG2aF4S
 PqA5/vIcTT73UdNNZqTeVIB6N+j0FN0SaE/ztYUNw1jjtrX9ihQD9qfQdE+sK0kvqTHqiw5tV
 rV4d3f/e1bQqTM26wlJAVLJkn8DUkVgP60tOnSpJiGTv95JYzoYO7XEP6FZFKo1/VaXyrw4u0
 gnrTu6mU8aKAmZn/0ZuW5jUod/SFNPgwww9chKqJttKPM/2IZHteREqA1TpXkznpSoHDBVD/S
 cJHJALrsSukLbO6Wl05Q4/1M+yN9eQxawXtdMVcTns4NqLrzy74QMLsyS2AicHZlLVLHFrJG6
 D1Bi6VpCxgpp+2fU81ptiVDXK7pBUL5qmE+LorYxOBXt4I5nyOyKqCutwGUybm+Le5MlBfsu9
 KsDIyrLdU7p3hD03B4jkEx4JyC+Db3L0Bydin4rk2OxdDkcKRN5YhAo6p2PrnSKmRsfVWTzmZ
 T+MAES/lWdl/geeXqVTk32tdSL65lsEReFjK9YUo7T0GVGtqZxqcb/by6Dmv3u0YItXHsn33D
 ySFal3dug4JF2KfcZ01JNhnCVh/VmrxQQsP2VIG5lurxWrLjt7/vw0tVyMa+Tuxd4XGTg24Pz
 xMvzaoSB+V1PPdd1IfZk4mdt4C5jGW1t7ch2zlFcrjUVYXoT3XWAwRKztFRO8BTlC2/C/Bp2+
 pR3nNk5kvEcnERxllwGrjnV0LG7k7ef8Ig9fO6LX28hYcO4tlPjTE0FQBF6ytbyIzXti5/Pl/
 dUZSKokOvQU0RdrBKasCU3cbVxsLwsAfrkdzFl58TUZQDcYgUaLqH76OxsQHzH77EgRrEZAkF
 G2VdFeN64MpABbcY6xnl6ATyT74d7Kj5O1odGu3cXqMnNoDoT5pagAAMuAga8EgVhRwr4w65n
 /l7XH3yXjmA196rPYg4Td4NWl32+yJ3BF5GWCHLYUnxxVVG0fo1xNrjvbUYlq9AG+mpGf6FF9
 YBgzy4yt6cEJ36PAG7WxfFf7jI3o3vOTe0ISbzaqKv2sbEESSMo/9xtu9pfb+tejnO3talp31
 oCFGuYRvCq5Hk9KhfwHSKyj1rF6V1dJlL1qKYHUomcBpES6gxM+KX9nOcq0HWB8RQMxsN0Q4H
 7/XrruhC7jf239qY3a2xRO/NluoGaviziKMZnWantMNdkXAkKlC/WW4rk0LYJc8ub2oTz0G+U
 5rC4ddChPpE+T0gAweCimP66eKhrDhzWmb8gY0utnm4nZAEf4Hbrme4gsSik86kdLStXCHoAz
 cWDLRDVQpQ0sCLuihFk6J8JKIyFbR+fZJscF5DLwrGjhCyoi8O+8zEe7ycR6x47knskK1Wama
 jm6Ua5WODRWYfDAhEth7ouXj4CeQANSkkdVjLxucIGRa4OVkjJ28uz+3LvpuvhuBlw0wAqgOV
 jVPjd86+nC/sXQA0z1VhJnrK055F+3qzpHj7vn+cUHUrnZDnFz7fIxJR5ccCZJ88CqelG1KQR
 NVxjJP7WgRX+mgJlUVo3EinHElm7QTZ/GJbRzdqEL+dAUAW4s7hqT0+uklbzC3YUgkD00n2Or
 xOX9KCG3m3lsEIhggejuLu4TQkMh6VDxKRAaqtYV6zPd+z1BWpqvH7wXUQC9a8WD126EYnJBl
 A9kO/6V4uqRjjIatxOOgCWCNCVQJ7yCsn0MwNUNIVKZHih8ZxDP6HBmk05H7ZxoezrgWCkGV3
 YnHYvknyZJ5sVWxQNKyYYncYDZ6OQeqaFDkdRxEBvtIREchpyJeYSOW5bDDm45+eYB4AFXwJa
 xzHlFl0aMGv33RObfsDjnfDy4xqmgMKUSFk7/9PeW5piVJZ6H4KSUBhQhyAUE+MmxGOEHb+hj
 YZZepRMHHF16LUy6jvl6qybU1+tTW/H2puHv3vnMB/cglueSgMklp0Vn8JCsPugwX/c8wm8Ex
 anuMUnGdvMHcFdEj/6vYcZwNFg++d1B0Pa6QY9Rtn3Sw1BmkkgYxgDpb1UeMG72f0K/n0KGV/
 rnxunN1Ql5kVk+2cqQfnLKjVdC1kAjo9w+034GK4CK0M3pIJ/tbm/ZQZZ6GRmQtnXoiXpuOpB
 6mujiud2EkNIjMNziOocG+1U/yzJFdegH0gDVoGyS1PLOdJCf1kyB5QPgtmJ/pVuB2KCZeeju
 yIYxjEYRqjKRoMto2VwMFp1GId3rqpopzNEjiQLecNixH/tnO2Ud2rGkLBR44IEgcJkd1nmGr
 BYsVb1dKkozWcUZ6OJV6xKh8HWoUqnoX/NTSyU/XnuZsrr/7WdKc1u0csB8090HjUgq7BnwCr
 4uwpgNFcwDKv79DVxz8KxOZo8Vp+w9DLdNGb6cQBxylnhN32ZOglW1kfnPmPGSPJsVSDkrVTz
 Qhs3KQugR1ncH25gAhMDPReehEoEUHh3QFSsryMYGk+d6I+WgHRRW6YG/a1BKK/7QVZm91RmQ
 2qV7RxWiSPTlYMOqeBxo2u92aMJgb9nmXyz0wB0hZYQqbARghfZIEU1/ZKcCz16fqZ7ynoBIX
 9GXSdxXMCSJ6ljTkobz+E1EK/VpFArcXngHf6WlIbmJkEbzxBaEh8zWCEJHZP29c2UhdHyPsw
 0VRaRPHArQub5m+sedmIC1i12+waYFhfYZLZuYoaor4Y3uJcItpKrPCWglsaEvu6zwOGIcSe2
 UAyamMKDEnrlzEzS3jTqSR/E3QNrIpYxcNqrA172183hs7JCPFdTZXEfpvofeswd3H6CaJTGm
 fnntGEHwgralCXIZdnZLJdh3+4XFbZ3KYctj8uGeQGd4rovzhxw5YO1ulwqNhDt0RjprEXtQE
 v9EDITZ43Mlj5rX0ZH+yXV+qdyQQnbO8tM8DVhSV4eipd92Izu0ABndBu/Ejz2lJfu6GFPO5m
 U2J6UxRDYwGwzVsqjmmLKcWuLkZpNegGWJqqkv62wTq0jGIrvmMOXcYK9rC3QSYjAkhO5FB1P
 shY/vRRXAdI49aOy/JzTuFpAXMkMFGFPlvUuZM1je1V4fBtYNDMxW6S44MCyRfrXKsp8Qcvsi
 nQb645eR7ubBoTpPf4cDCgeOoTVyrPaB4ezN+wbGrpg4XUC1lbxaJxepyREK1q39hm22mGtJ6
 ian+2rpp5iDe9Xul3aJHZVteCvi+1fTXyqw8Dhi5f5j6VWVE8L1QWQ42MJEm4HxpFJLD3SCYk
 zV1g+oTQLj4XFzE1MZ+BCBPqNhvCrqHW12/fI37/SWzoRM8XbC+P+HeDViGeUTHDVu2N6E6ky
 4Uijde+Du076bSUZe7DZS+YXfCVN5BJoDbNFYn3z/bWcQMyBsKUpoIWmdJVSVrMQDMlEXlszL
 s6OU5gsg36HNFjc8Qq8pX3EImnh8Vx2xv+rH3tbeo4sLcBDKtWMRXrBYFj/kRknX9D5U5tV61
 6JpbBj8y9BUbq1f1mB971e/DWbc7apEdi2A6EcWq/NYTCx19psw0FZeeAlN2kylyc9YHZWpJ6
 q3mI/OXKyRQADhfOR7Mfml6M+rZzg0920zRo8H/4VjgRKBMN7OL6W9OQpy4fCMGlhM/fHWhlV
 GI4j88HQ==

Hello all,

I have worked on and privately tested packet forwarding acceleration for=
=20
the Cavium Octeon CN5020 SoC
used in the Ubiquiti UniFi USG-3P and EdgeRouter Lite. The changes
are currently submitted for OpenWRT review, where I was asked to probe=20
the prospects
of this being upstreamed into the Kernel.
I was sceptical as this is essentially a discontinued SoC - but there=20
are many devices
with it out there and I felt this work might be useful to the community=20
considering
Unifi is dropping their controller support for them and otherwise they=20
become e-waste.

Main motivation is that without this hw offloading, achieving actual=20
Gigabit line rate is impossible on these devices.

Before preparing an upstream patch series, I would appreciate
guidance on whether the approach is suitable for the Linux Kernel and whic=
h
tree and review process should be used. (I have - ZERO - Kernel contributi=
on
experience and hence I am a bit intimidated by this^^)

The routed path integrates with Netfilter hardware flowtable
callbacks. It caches established TCP/UDP flows and performs the
required header rewrites in the Octeon driver's receive path,
reusing the receive buffer and existing hardware PKO transmit path.

The CN5020 has no autonomous NAT engine: lookup and rewriting still
run on the CPU. The implementation supports IPv4/IPv6, NAT, PPPoE
and a single VLAN tag, with unsupported packets falling back to
the normal stack. This should cover the most critical use-cases,
especially also PPPoE with encapsulated VLAN which is something used
by many ISPs (e.g. famously Telekom with VLAN7 for DSL).

On the USG, single-stream plain-NAT throughput improved from
approximately 560=E2=80=93600 Mbit/s with software flow offload to
930=E2=80=93940 Mbit/s. PPPoE over VLAN 7 also reaches approximately
930 Mbit/s. The implementation and benchmark details are here:

https://github.com/openwrt/openwrt/pull/25645

There is also a companion bridge forwarding shortcut using
switchdev FDB notifications, which could be discussed here or separately:

https://github.com/openwrt/openwrt/pull/25823

This essentially takes care of same-subnet switching, e.g. on the USG=20
that would
be the case if the third port is used as a second LAN port. It also=20
supports VLANs.
(basically everything that does not terminate on the USG like a VPN=20
connection and has
no fw table entry)

My main questions are:

- Is this driver-local forwarding approach acceptable in principle,
 =C2=A0 including its use of the hardware-flowtable interface?
- Would you require a different integration or work toward moving
 =C2=A0 the driver out of staging first?
- Which tree should an RFC implementation target, and who else
 =C2=A0 should be included in the review?

I can provide the code as an inline RFC patch series if requested.
Benchmarks are available at the linked Github PR.

The bottom line is that this is what allows devices to operate at=20
Gigabit line rate. Without
making use of the SoCs hardware-accelerated buffers and transmit-paths
it's essentially impossible to saturate the Link and maximum packet count =
is
also very limited.

Thank you,
Markus Krause

