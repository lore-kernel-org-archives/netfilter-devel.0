Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795689991;
	b=rUQ229sSTXmnP3SLcdfLNOlStBBk9iHTmRJubLprsXoa4Kd6nzRz+85MaplGKae+kz/o
	 i+/HbjIV0F6qMuwuTMNifYrP9akdHzBWGjS+FRHkNLwNXOGINsA4jmTY8qyCHNVcdmNiw
	 6ITkKbgC2XlBKGuCXyX8tGkjdyH2cmnrrr/n6LDWaEcrejNEIIUczL0poTkvJPfJcK0Rr
	 gNipoOrTKgG76+x/ftxDKpsciEqwm8vzPZlCgP6EltZmI0fr+zqosVqidqkeOajDEWjc1
	 zLl7tCuVzS3yoglB0sM2A9f4fTKyGI0hXF8L2GDGim58ezQgSgzNeTWgkhdr1WAP0lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795689991;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=UURkDlwS2bfQuYIHyesKLKLIpma4grDXpqZF4b4GbTg=;
	b=KDQfwc/0MT5C/PV3MPFAT+WxOzq3WDEq8mBpQ3tKG2SRT2HqLmkcKk5o0BdS8T1D+QgS
	 ZotSjuKD2bNA4gdvnp0fHaXp12l4V4Gpc3OA94ZEs/SEHdJzs9aaOWEs7xbnacQ1TaZYd
	 jPaklmOPHPa+0JFmIN+jEhwE/0fRTIfL17/UKsR3gSbbaHrwzJTSO3Ww/3/dUTehSKhMH
	 jdYRwxAg4h5u+FYWTsMh8WDyzoLfeDedOjkAkq11Z/VFPck/l+n8okUMJFywuwtOGI97B
	 5LiEu3/MKeiUzuYKd5MqFu9XNslIxs2xpuXIwW9ROUQsgaZwm69epFJ9BfznlKsYQ/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=WRv2nsuW;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 417EB606A31C;
	Thu, 26 Nov 2026 10:46:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 417EB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=WRv2nsuW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795689987;
	bh=UURkDlwS2bfQuYIHyesKLKLIpma4grDXpqZF4b4GbTg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WRv2nsuWE9Bgiku6uiFWt0vx/97fqLy2Ymeg7jPs/IkgKV/AwJatibPBAZ4XyPoFi
	 5A2m44yC3GDHcMbaKuEZkMFCenYQHMtMLq1L0+ziFUaNq2sfcIK3NwFe0stIELMGA3
	 DZ8dezqeWsi5lEkaCgYm2TrQquB0MqZLDUZhNQbavSqUFEi997wsQChU/13lgFqJJx
	 W5YnbiPnw/7Wv6a4lIS/tm6jSi38OoyFO0HW9KFU1NTi32RJ0XY9wvFxB15IPGmnFL
	 EtN44PWG+j5TWT5Jc1XdqpOndoNL7GVhH+qmtb8Gdo3bJawM3pfAKDSiIA9HJJtPtr
	 nyCDOEMbz1LiA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 852EB6007A;
	Thu, 26 Nov 2026 11:46:27 +0100 (CET)
Date: Thu, 26 Nov 2026 11:46:24 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@kernel.org,
	horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next,v2 00/15] Netfilter updates for net-next
Message-ID: <awgOALX8V2RXY-uH@chamomile>
References: <20261123135726.3940688-1-pablo@netfilter.org>
 <8e69f35e-73fb-4558-910b-45f5e723c64a@redhat.com>
 <awWSHujeBmMMOonS@chamomile>
 <f0a3c071-0142-4c62-b74b-ffff8121c8d9@redhat.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f0a3c071-0142-4c62-b74b-ffff8121c8d9@redhat.com>

Hi Paolo,

On Tue, Nov 24, 2026 at 02:43:53PM +0100, Paolo Abeni wrote:
> On 11/24/26 14:33, Pablo Neira Ayuso wrote:
> > Hi Paolo,
> > 
> > On Tue, Nov 24, 2026 at 01:27:35PM +0100, Paolo Abeni wrote:
> > > On 11/23/26 14:57, Pablo Neira Ayuso wrote:
> > > > v2: address cover letter errata.
> > > > 
> > > > -o-
> > > > 
> > > > Hi,
> > > > 
> > > > The following batch contains Netfilter updates for net-next. This is
> > > > composed of four groups:
> > > > 
> > > > 1) Patch 1 addresses a race in the nf_conntrack_buckets sysctl handler,
> > > >      that has been reported by LLM. From Fernando F. Mancera.
> > > > 
> > > > 2) Patches from 2 to 7: This is a conntrack hardening series to address
> > > >      LLM reports of the issues related to skbuff mangling while a ct is
> > > >      already present, leading to mismatch protocol numbers, ie. ct becomes
> > > >      stale since it does not represent this skbuff. This is unlikely to
> > > >      happen in a real world. From Florian Westphal.
> > > > 
> > > > 3) Patch 8 updates nft_synproxy to address SYN and ACK packets only, just
> > > >      like ip{6}t_SYNPROXY does. From Fernando F. Mancera.
> > > > 
> > > > 4) Patch 9 validate hook priority so nft_ct template is narrowed down
> > > >      to be used where it makes sense. From Florian Westphal.
> > > > 
> > > > 5) The ipset hash types conversion to rhashtable, including a new
> > > >      rhashtable helper function to flush and destroy the hashtable.
> > > >      This is a rework that aims at fixing the existing resize races in
> > > >      the ipset hash type, which has triggered a myriad of LLM patches
> > > >      addressing the symptoms but not the core issue. This large so
> > > >      we prefer net-next for these series. Series from Florian Westphal,
> > > >      plus one patch for rhashtable to add a flush and destroy helper
> > > >      function by Herbert Xu.
> > > > 
> > > > Please, pull these changes from:
> > > > 
> > > >     git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-11-23
> > > > 
> > > Unfortunately a couple of in-flight nf patches prevent the CI from
> > > picking this series:
> > > 
> > > https://lore.kernel.org/all/20261120111910.67379-1-juny24602@gmail.com/
> > > https://lore.kernel.org/all/20261121212037.149722-1-omermetekaya0@gmail.com/
> > > 
> > > Could you please re-post it? thanks!
> > 
> > Just a verbatim repost?
> 
> Yes.

I am preparing a v3.

I will make a few changes to address some of the comments that
clashiko.

My plan is to keep the ipset rhashtable in place, I think some of the
relevant comments in the reports can be addressed by follow up
patches.

Let me know if that approach works for you.

Thanks.
