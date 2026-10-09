Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99524DA541
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Oct 2026 11:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791547103; cv=none; b=RbfFqB2A7b3NezTqrmtb5sWClVYL/mDte20XbQ/P1XdwJ31i5BFxnAw9A+Dlzy5VhjAXL0wuBunqP8NNaIHyLevoNXuh3gD0I08j1fkthmGbSlmGjRDWnvCEP5dAa/lSX8PwxSjcXNrU87i3UNQpFnbkYaXhSoFw/MeiKSiFf74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791547103; c=relaxed/simple;
	bh=4Kt1TWc7AlXa3KKGPb2yi4cuQvUdlHSUvmoCuuL0Ot0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U7xv6Vc88p3ihyhJE3OeCh5cCeWivYDgVMOJbuO5ln4/DLLInSoVAjEIhX6kUYlsCbkg/GNTOY2JorPmOSTFjtQh2G7yCOJ+X7NYcaHp1R7GTb64c0t6WXjd6lX/w8oRvpzcUdaHBnOusvadv/dowemo9v9/U8rI2FRpS2X8/2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E5DEA60337; Fri, 09 Oct 2026 13:58:13 +0200 (CEST)
Date: Fri, 9 Oct 2026 13:58:08 +0200
From: Florian Westphal <fw@strlen.de>
To: =?utf-8?B?7ISx67OR7LCs?= <tjdqudcks0424@naver.com>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: xt_dccp: handle reserved options as
 single-byte
Message-ID: <asjW0HXAbyCOkcjw@strlen.de>
References: <20261008183814.10521-1-tjdqudcks0424@naver.com>
 <06fe96ca-ef3e-4a15-9d11-d188164291a4@suse.de>
 <af8485bf933f5620813e12cdfe68a080@cweb014.nm>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <af8485bf933f5620813e12cdfe68a080@cweb014.nm>

성병찬 <tjdqudcks0424@naver.com> wrote:
> 
> -----Original Message-----
> From: "Fernando Fernandez Mancera"<fmancera@suse.de>
> To: <tjdqudcks0424@naver.com>; "Pablo Neira Ayuso"<pablo@netfilter.org>; "Florian Westphal"<fw@strlen.de>;
> Cc: <netfilter-devel@vger.kernel.org>;
> Sent: 2026-10-09 (금) 17:34:55 (GMT+09:00)
> Subject: Re: [PATCH] netfilter: xt_dccp: handle reserved options as single-byte
> 
> On 10/8/26 8:38 PM, tjdqudcks0424@naver.com wrote:
> > From: Sung Byeongchan <tjdqudcks0424@naver.com>
> >
> > The DCCP UAPI defines option numbers 3 through 31 as reserved.  Like
> > Padding and Mandatory, these options occupy one byte.  dccp_find_option()
> > only treats values below 2 as single-byte and interprets the byte after a
> > reserved option as a TLV length.
> >
> > This can skip a later option and invert an XT_DCCP_OPTION rule result.  A
> > local production-hook fixture installed the same DROP rule for IPv4 and
> > IPv6.  In three fresh boots per kernel, a target-only packet was dropped
> > 20/20 times, while adding reserved option 3 before the same target let
> > 20/20 packets reach the protected receiver.  The fixed kernel dropped all
> > trigger packets in three fresh boots and preserved the normal controls.
> >
> > Treat every option up to DCCPO_MAX_RESERVED as single-byte, matching the
> > protocol definition.  Triggering requires
> > CONFIG_NETFILTER_XTABLES_LEGACY, CONFIG_NETFILTER_XT_MATCH_DCCP, an
> > option-based rule, and remote protocol-33 reachability.  The touched source
> > is unchanged at 0c2669a9f4a1d607e7591ae50ccf3c432a0aff08, where the patch
> > applies and builds cleanly.
> >
> > The demonstrated impact is a conditional remote filter-verdict bypass.
> > No memory-safety violation, information disclosure, RCE, or LPE was
> > demonstrated.  The source reproducer and complete logs are available on
> > request and are not included in this public report.
> >
> > OpenAI Codex assisted source inspection, test design, patch drafting, and
> > evidence organization.
> >
> > Fixes: 1d3de414eb20 ("[NETFILTER]: New iptables DCCP protocol header match")
> > Assisted-by: LLM
> > Signed-off-by: Sung Byeongchan <tjdqudcks0424@naver.com>
> 
> The commit message is a bit too verbose and I doubt this has been found
> in a real environment. This might be a bit too extreme from my side but
> can we ditch DCCP support?

See: 606bd17ef0de ("netfilter: add deprecation warning for dccp support")

> Pablo, Florian, what direction would you prefer?

Well, you already made a fix and it makes more sense from -stable PoV.
So I'd say: Fix and then zap this thing early in 2027.
