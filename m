Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D23349B1D
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Feb 2026 17:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770225803; cv=none; b=RU42FfHRbQrXCpR2302Xilll+RgU2Xuvm78PoKhoSAn/BtrOPvwCjVePWRl/a2F+2+gEC/3GnyPb9ySlgIJZmE0jOt5LnQYKthJKVcM3MFX6t3nP1FB2FuPziztP7zWiAtr7nHQwIivkk3zxS8F2+1hfGB9i4DobBJv/7QiqQkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770225803; c=relaxed/simple;
	bh=5lu48anCEWIHDeXshNxtpGysVPaM+u929jzbNByXL/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mIYTQeX8882vlHhquyHTkaDTRzbkm4wtGELhp8xuMno01u9nWINHREbOs0F9jbh+kbhUnI6XzMbQdxPtr8ILAUcvOiBucTCUPvKWr8RFlQYzCJjuOsIudv8uYb9BsGw/KjOCo7fmmC3Ob+DIsWRdU1SG+NabZhzNN+X//kwHFYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=HILJUJqe; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="HILJUJqe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wLyLnX5LinBar8Em+ZOpjqSnxXPA+nN/zMHJCQ8cBr0=; b=HILJUJqeLw7//IV351pQx5OsXn
	JaqS4jRszpSO/5QsO65VXKEijEHnU+Z7UqTcMFsuN4zkodIWIDWOAZp1BAwqGuUYd3TDyZ2PSnec9
	rmkJQRQcvs1BigqArn7cThaIfMg0RTBMoGxAAlPwrnRiodBFI758ZlF/4qyJx0WQBbbLioADXiiJe
	hCEB+Jxsp2C0GUpaRdKwm+BiVP77LP1wqEC6u/6A70g+bmgOOKy1nrg/ZdxJvrMuIItHpI50x70rI
	pvAwvW2HaprAAsQoqyR16YmJMSp0ko52jthZeaQ5nD5iqxv/KK5/sKSTRBK3G4Z2qAfNaOQyO5RbH
	C1+aVltA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vngaw-000000006xN-2a0N;
	Wed, 04 Feb 2026 18:23:14 +0100
Date: Wed, 4 Feb 2026 18:23:14 +0100
From: Phil Sutter <phil@nwl.cc>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de,
	pablo@netfilter.org
Subject: Re: [PATCH nf-next v3] netfilter: nf_tables: add math expression
 support
Message-ID: <aYOAgsSVPdisk19Y@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	fw@strlen.de, pablo@netfilter.org
References: <20260204152358.11396-1-fmancera@suse.de>
 <aYNurHgLqfnX07NB@orbyte.nwl.cc>
 <22a1eed1-0e9b-42ed-b5bb-2947d90c0ada@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22a1eed1-0e9b-42ed-b5bb-2947d90c0ada@suse.de>

On Wed, Feb 04, 2026 at 05:44:14PM +0100, Fernando Fernandez Mancera wrote:
> On 2/4/26 5:07 PM, Phil Sutter wrote:
> > Hi Fernando,
> > 
> > On Wed, Feb 04, 2026 at 04:23:58PM +0100, Fernando Fernandez Mancera wrote:
> >> Historically, users have requested support for increasing and decreasing
> >> TTL value in nftables in order to migrate from iptables.
> >>
> >> Following the nftables spirit of flexible and multipurpose expressions,
> >> this patch introduces "nft_math" expression. This expression allows to
> >> increase and decrease u32, u16 and u8 values stored in the nftables
> >> registers.
> >>
> >> The math expression intends to be flexible enough in case it needs to be
> >> extended in the future, e.g implement bitfields operations. For this
> >> reason, the length of the data is indicated in bits instead of bytes.
> >>
> >> When loading a u8 or u16 payload into a register we don't know if the
> >> value is stored at least significant byte or most significant byte. In
> >> order to handle such cases, introduce a bitmask indicating what is the
> >> target bit and also use it to handle limits to prevent overflow.
> > 
> > This part puzzles me. IMO byteorder conversion is needed for arithmetic
> > on multi-byte values in non-host byte order.
> > 
> > Since nftables only knows host byte order and network byte order, the
> > only case to consider is Little Endian host with NBO data. Registers are
> > filled "from left to right", so (u16)0x1337 and (u32)0xfeedbabe look
> > like this when stored in Network Byte Order in registers:
> > 
> > { 0x13, 0x37, 0x00, 0x00 }
> > { 0xfe, 0xed, 0xba, 0xbe }
> > 
> > Interpreting those buffers as u16/u32 on Little Endian results in values
> > 0x3713 and 0xbebaedfe. Any increment/decrement on those values leads to
> > wrong results.
> > 
> > Maybe there's a hidden secret in 'bit_unit', but even if you calculate
> > the right value to add/subtract from the right byte (0x100 and 0x1000000
> > in our examples), a possible carry-over bumps the wrong byte.
> > 
> 
> Hi!
> 
> This is correct. In the initial implementation [1] I included a 
> NFTA_MATH_BYTEORDER attribute but after discussing with Florian we 
> decided to drop it. Of course, in order to make this work correctly, nft 
> byteorder expression must be used to perform the conversion when needed.
> 
> I believe that nft command line tool can figure out when a byteorder 
> conversion is needed as I noticed this is already done for other 
> expressions.
> 
> My initial idea was to keep the bytecode as smaller as possible but it 
> is true that it makes sense to use the existing byteorder operations.
> 
> Does this make sense or am I missing something?

Ah, got it! So nft_math simply assumes sreg and dreg are in host byte
order and nftables is supposed to add nft_byteorder expressions as
needed. That should do and is indeed easier than dealing with data
byteorder within nft_math itself!

The only odd thing that remains is the combined use of mask and length.
Typically one would either use length and offset or mask alone because
the former two values may be extracted from the latter. Also, why does
nft_math_init() restrict masks to align at start or end of register?

Thanks, Phil
