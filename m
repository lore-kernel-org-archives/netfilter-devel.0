Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96B94E3250;
	Tue, 29 Sep 2026 09:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790672487; cv=none; b=B6Uxw3nvkLw7Io74SOKjKHPuq3rVCElkU61EbLOzQDsm//HkRGy6sY0gmqoMr2gODuHevqrxSt9leW9TVAHyw07qVvgfSTEyPZBYU5ExBk+VCnqaIginbsBCP3/OC1FPWd/rsWQniZCJ0xYJX0UmhpVBbDOPacob5mYwaB7xmdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790672487; c=relaxed/simple;
	bh=+cJ+oApCLWFX+2J/TYrhnMYyfOBv2bJE5opuDyb81Ec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qlqSvBLUE3D57DkpfHigM+heyV7LZ4zQZ/IVpsC5ioWAKQ12OL+grmfsRSYJOU7I15hZjI1x6HPDtL2KIwarJRaNrAyf0y/EnHNzQZIhdUcl4+O1QsJZmiF8HOd4IOXkjZhMFqko1V1PAoofh2ihyEGykaGzjomiqEJC6zxdq8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=iMK2lyNF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="iMK2lyNF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790672479;
	bh=Db5PjPl0J8Jar2v2P8e7jihhsNeO4rAjX3w6USPwtns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iMK2lyNFubrnV8n45wb1GL+vSy1ToOweiFuNYHnSaUpUBePmlD/y2PH252g8bCHnh
	 A+nB5wP+0vqt5YYQ/uX0yxyT6Eil+XCbGh3/rfkionJSx4mJHnllkv6GOBPsJLLLNn
	 zrMTIbjXXT3rdfisFM2xcgIkxI9UhCr0L4+ZJMrI2EDEv6PKQmeFsGitpN8muoyGUQ
	 sNhbdHMxxo7bTLUiRs9y7S4tyzr5Xw696ws7iv5HtKYTbmvUTWKdYP3nZRzxjraVdU
	 l2lVxXk80+OjC1kJMvNAuxifAVpQKBjAsdQOhGdJ7TuajM3pLCCjF6Qy7kvfWHXhAx
	 JVOynpVF7Tc8w==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id BFAA66005A;
	Tue, 29 Sep 2026 11:01:19 +0200 (CEST)
Date: Tue, 29 Sep 2026 11:01:17 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: =?utf-8?B?7ISx67OR7LCs?= <tjdqudcks0424@naver.com>
Cc: fw@strlen.de, phil@nwl.cc, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] netfilter: IPv6 conntrack fragment reassembly truncates
 header offset
Message-ID: <art-XRsR09GIvc4D@chamomile>
References: <31da96413a406da2116f44df2db84f@cweb009.nm>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <31da96413a406da2116f44df2db84f@cweb009.nm>

Hi,

We have a patch for this.

But I stumbled a few times over it because I did not have a
reproducer.

If you can share it with me, that would great. Thanks.

On Tue, Sep 29, 2026 at 02:07:58PM +0900, 성병찬 wrote:
> Hello,
> 
> I found a reproducible IPv6 conntrack fragment reassembly bug in:
> 
>   net/ipv6/netfilter/nf_conntrack_reasm.c
> 
> Tested kernel:
> 
>   Linux v7.2.8
>   commit: 9a66fdc0d7fd55f54235524a73435af99051e46f
>   architecture: x86_64
>   KASAN and KCOV enabled
> 
> The problem appears to be in find_prev_fhdr():
> 
>   u8 prev_nhoff = netoff + offsetof(struct ipv6hdr, nexthdr);
> 
> A valid IPv6 extension-header chain can place the previous Next Header
> field at offset 256. Since prev_nhoff is u8, the value is truncated from
> 256 to 0.
> 
> The truncated value is later stored as the fragment queue nhoffset.
> During reassembly, nf_ct_frag6_reasm() consequently modifies byte 0 of
> the IPv6 header instead of the Next Header field at offset 256.
> 
> Observed results with the unmodified kernel:
> 
>   - Control packet with predecessor offset 248: delivered
>   - Boundary packet with predecessor offset 256: not delivered
>   - Ip6InHdrErrors increased by 1
>   - The result was reproduced twice
> 
> I then changed the local variable from u8 to int:
> 
>   - u8 prev_nhoff;
>   + int prev_nhoff;
> 
> Observed results with the modified kernel:
> 
>   - Control packet: delivered
>   - Boundary packet: delivered
>   - Ip6InHdrErrors did not increase
>   - The result was reproduced twice
> 
> I also tested the boundary packet against an IPv6 INPUT firewall rule.
> The packet was counted by both ACCEPT and DROP rules, and no firewall
> bypass was observed.
> 
> No KASAN report, memory corruption, information disclosure, privilege
> escalation, or firewall bypass was observed. I am therefore reporting
> this as a packet corruption/drop correctness bug, not as a confirmed
> security vulnerability.
> 
> The same u8 declaration appears to remain in the current mainline
> source.
> 
> The code appears to have originated from commit:
> 
>   6b88dd966b42e374dc783c397efc15f5c1458265
>   ("[SK_BUFF] ipv6: Use skb_network_offset in some more places")
> 
> I have a minimal C reproducer, kernel configuration, serial logs, and
> before/after test results available. Please let me know if you would
> like me to send the reproducer or prepare a formal patch.
> 
> Regards,
> sungbyeongchan
