Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795527205;
	b=YiDEafNVGQQ8PiZzdT7L8jH35qnPs0Uu7bfl4b008QAvZZg94/ev/XDa33iFB69Yvhxf
	 Rcatz1jrcP05xKfZPeCJ4OJy7MM3r+sPF/hchaRWLA4TUAHq7TSFJqpFbcqyapt0gqVlE
	 x6ic4GjUFKf02+HpfqfrViWgWIBKmhE9zopbbqIjIB8BRVaNt1L2i1q1HGSHjN5oh8R9W
	 bnooW90O16MK0upfDDI9Bhkkkhs605vp1eV+aZU/dOxQ2n+5nIG8xq8MPl5cu4HO8s7jo
	 H/xNoKxVK/coMXefu6r8LnQ6xc9+O52rK+GJ575dWFFFEaioipCLsPCqy8w+lXyBswg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795527205;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=rg/HyRYdpVDhfRvUrLQnnNwbOFrftaSmDyOUI5bdo48=;
	b=eh5FFjNytFC0Kj5Xaw+t1GCQq6J22Dx/hJdyV208IuhiIoO/dKBdCNGxDgCcN8aGIr0y
	 9JdzVfndnlBx2XrtIkFexzfzsuyYdSGMH4BnEjTUW/MK4prC0hVdHeZsjU9lVVUcz44SE
	 bnyYyyqlyh4UiSfDB8eSy6brupeooJNGOKuE8Qq6px0EZkdaom7I4ajwA1u9pqYxo9DaO
	 T7bjLwsVIxqyPWYkmX+lCltiwfcbjP73R0S9K1slwSyFU3J9Tc3/vDx5X10P4jgPCY3me
	 6unARthNRQTs20GHtqoFty6b/ZgHtf7QXAFv1doTPT2Qe6p+j5boV7Ki3Br+8P26AuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=SF9JRUZg;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 540DE606A69F;
	Tue, 24 Nov 2026 13:33:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 540DE606A69F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=SF9JRUZg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795527200;
	bh=rg/HyRYdpVDhfRvUrLQnnNwbOFrftaSmDyOUI5bdo48=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SF9JRUZgdwjlfv01fFiQiBdcjOzgYZWmCBGMyDg64PNAUTmM8a4AlTm6hyJosNPwA
	 uo46LlqPjivmGoBIw9cEgB4/AYXxse8e585BMTAET1wfZEHHBRfAekjryJvOZoMv7z
	 wATBpVSaCc61Pd3WFnHhenDTO6s483OrKb7xkdMAR23piWAy8DvPEv1EpRVO6RadYb
	 PFJ1oLvMQGqcSc7qJOs3a7K1HD2lDxtlYDhNoTBfX0UseZBPXIxKODYwVSqrUSIvgk
	 nwFME1fzrO4WAXHNUv2gHn6BXOWy/+DQZaUxk+MOAo4jtD2d81UtNaehar+XLPvxri
	 ghbyUtbIGP+Zg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 9059960057;
	Tue, 24 Nov 2026 14:33:20 +0100 (CET)
Date: Tue, 24 Nov 2026 14:33:18 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@kernel.org,
	horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next,v2 00/15] Netfilter updates for net-next
Message-ID: <awWSHujeBmMMOonS@chamomile>
References: <20261123135726.3940688-1-pablo@netfilter.org>
 <8e69f35e-73fb-4558-910b-45f5e723c64a@redhat.com>
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
In-Reply-To: <8e69f35e-73fb-4558-910b-45f5e723c64a@redhat.com>

Hi Paolo,

On Tue, Nov 24, 2026 at 01:27:35PM +0100, Paolo Abeni wrote:
> On 11/23/26 14:57, Pablo Neira Ayuso wrote:
> > v2: address cover letter errata.
> > 
> > -o-
> > 
> > Hi,
> > 
> > The following batch contains Netfilter updates for net-next. This is
> > composed of four groups:
> > 
> > 1) Patch 1 addresses a race in the nf_conntrack_buckets sysctl handler,
> >     that has been reported by LLM. From Fernando F. Mancera.
> > 
> > 2) Patches from 2 to 7: This is a conntrack hardening series to address
> >     LLM reports of the issues related to skbuff mangling while a ct is
> >     already present, leading to mismatch protocol numbers, ie. ct becomes
> >     stale since it does not represent this skbuff. This is unlikely to
> >     happen in a real world. From Florian Westphal.
> > 
> > 3) Patch 8 updates nft_synproxy to address SYN and ACK packets only, just
> >     like ip{6}t_SYNPROXY does. From Fernando F. Mancera.
> > 
> > 4) Patch 9 validate hook priority so nft_ct template is narrowed down
> >     to be used where it makes sense. From Florian Westphal.
> > 
> > 5) The ipset hash types conversion to rhashtable, including a new
> >     rhashtable helper function to flush and destroy the hashtable.
> >     This is a rework that aims at fixing the existing resize races in
> >     the ipset hash type, which has triggered a myriad of LLM patches
> >     addressing the symptoms but not the core issue. This large so
> >     we prefer net-next for these series. Series from Florian Westphal,
> >     plus one patch for rhashtable to add a flush and destroy helper
> >     function by Herbert Xu.
> > 
> > Please, pull these changes from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-11-23
> > 
> Unfortunately a couple of in-flight nf patches prevent the CI from
> picking this series:
> 
> https://lore.kernel.org/all/20261120111910.67379-1-juny24602@gmail.com/
> https://lore.kernel.org/all/20261121212037.149722-1-omermetekaya0@gmail.com/
> 
> Could you please re-post it? thanks!

Just a verbatim repost?

> (Do I recall correctly that guidance for nf patches is to not CC netdev?)

So CI is picking in-flight patches that were Cc'ed to netdev@?

I just want to understand if I did anything wrong.
