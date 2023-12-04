Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="QkBetJ69"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C78EDF
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2023 05:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jqWltK7NU8fnc+6ECi1L7xz4xSJ4cEEikHQ2QVH5eBw=; b=QkBetJ69dEmEkSelByYSDh/w7G
	OCVWCUfxm64puaaqCDshxBfx6Bq1S4I2KPeSh94PfDqt7k9xlbMBM4w7CnYtC2nFSmLX2yQqepS9+
	cDKdDYLPeDDPxqREqEiEIvyc/+ykY1S8CwhtMtRHA8Rhu9uUHv+lXB8P8PL5Ka68mkvSHasw7tO3M
	NbmubtdEJq9xfIOUh0ajOji3JWG0ua3H/+n/x8Q0b9cFTYSWKgBX/KHfVsxKkfK7chsOG3K+w40OH
	vIzj0lptzZ5LYrJxAy+vryzXdbJNn50JsHNreHINL4M5mutosyHgzpcEC0gR8VaA+Oos2k7RVcqpg
	gi47QpYQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rA9Rz-0004Wf-Tl; Mon, 04 Dec 2023 14:57:32 +0100
Date: Mon, 4 Dec 2023 14:57:31 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix 'exist' matching on
 bigendian arches
Message-ID: <ZW3ay5ezNLz4Xs3e@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
References: <20231204112958.10706-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231204112958.10706-1-fw@strlen.de>

On Mon, Dec 04, 2023 at 12:29:54PM +0100, Florian Westphal wrote:
> Maze reports "tcp option fastopen exists" fails to match on
> OpenWrt 22.03.5, r20134-5f15225c1e (5.10.176) router.
> 
> "tcp option fastopen exists" translates to:
> inet
>   [ exthdr load tcpopt 1b @ 34 + 0 present => reg 1 ]
>   [ cmp eq reg 1 0x00000001 ]
> 
> .. but existing nft userspace generates a 1-byte compare.
> 
> On LSB (x86), "*reg32 = 1" is identical to nft_reg_store8(reg32, 1), but
> not on MSB, which will place the 1 last. IOW, on bigendian aches the cmp8
> is awalys false.
> 
> Make sure we store this in a consistent fashion, so existing userspace
> will also work on MSB (bigendian).
> 
> Regardless of this patch we can also change nft userspace to generate
> 'reg32 == 0' and 'reg32 != 0' instead of u8 == 0 // u8 == 1 when
> adding 'option x missing/exists' expressions as well.
> 
> Fixes: 3c1fece8819e ("netfilter: nft_exthdr: Allow checking TCP option presence, too")
> Fixes: b9f9a485fb0e ("netfilter: nft_exthdr: add boolean DCCP option matching")
> Fixes: 055c4b34b94f ("netfilter: nft_fib: Support existence check")
> Reported-by: Maciej Żenczykowski <zenczykowski@gmail.com>
> Closes: https://lore.kernel.org/netfilter-devel/CAHo-OozyEqHUjL2-ntATzeZOiuftLWZ_HU6TOM_js4qLfDEAJg@mail.gmail.com/
> Signed-off-by: Florian Westphal <fw@strlen.de>

I reckon we want this irrespective of any user space changes as it fixes
for existing/old user space on Big Endian. Therefore:

Acked-by: Phil Sutter <phil@nwl.cc>

Thanks, Phil
