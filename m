Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D596FF
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2023 06:06:36 -0800 (PST)
Received: from [78.30.43.141] (port=55698 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rA9ai-00EPOI-AZ; Mon, 04 Dec 2023 15:06:34 +0100
Date: Mon, 4 Dec 2023 15:06:31 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix 'exist' matching on
 bigendian arches
Message-ID: <ZW3c5+YQnwPdAeZo@calendula>
References: <20231204112958.10706-1-fw@strlen.de>
 <ZW3ay5ezNLz4Xs3e@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZW3ay5ezNLz4Xs3e@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Mon, Dec 04, 2023 at 02:57:31PM +0100, Phil Sutter wrote:
> On Mon, Dec 04, 2023 at 12:29:54PM +0100, Florian Westphal wrote:
> > Maze reports "tcp option fastopen exists" fails to match on
> > OpenWrt 22.03.5, r20134-5f15225c1e (5.10.176) router.
> > 
> > "tcp option fastopen exists" translates to:
> > inet
> >   [ exthdr load tcpopt 1b @ 34 + 0 present => reg 1 ]
> >   [ cmp eq reg 1 0x00000001 ]
> > 
> > .. but existing nft userspace generates a 1-byte compare.
> > 
> > On LSB (x86), "*reg32 = 1" is identical to nft_reg_store8(reg32, 1), but
> > not on MSB, which will place the 1 last. IOW, on bigendian aches the cmp8
> > is awalys false.
> > 
> > Make sure we store this in a consistent fashion, so existing userspace
> > will also work on MSB (bigendian).
> > 
> > Regardless of this patch we can also change nft userspace to generate
> > 'reg32 == 0' and 'reg32 != 0' instead of u8 == 0 // u8 == 1 when
> > adding 'option x missing/exists' expressions as well.
> > 
> > Fixes: 3c1fece8819e ("netfilter: nft_exthdr: Allow checking TCP option presence, too")
> > Fixes: b9f9a485fb0e ("netfilter: nft_exthdr: add boolean DCCP option matching")
> > Fixes: 055c4b34b94f ("netfilter: nft_fib: Support existence check")
> > Reported-by: Maciej Żenczykowski <zenczykowski@gmail.com>
> > Closes: https://lore.kernel.org/netfilter-devel/CAHo-OozyEqHUjL2-ntATzeZOiuftLWZ_HU6TOM_js4qLfDEAJg@mail.gmail.com/
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> I reckon we want this irrespective of any user space changes as it fixes
> for existing/old user space on Big Endian. Therefore:
> 
> Acked-by: Phil Sutter <phil@nwl.cc>

Agreed.
