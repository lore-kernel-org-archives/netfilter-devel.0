Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 387461E885
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2024 11:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712661110; cv=none; b=NtKFWw/QwJ6plqv5UVIq4tp4M2vHGY6ZLlq7bDLCS7+CP3iBoISjHTXadXrRYf4zJNoyu+FdT8Tg2V9zsjJ3eSL3Td8zM9YwrkpOGZM/aFJTXCZT9vswd4W5Zw6JPnidc+mgJ36WNux5urkOmAmsVR80DFAxtoA7ZUaq4gS1Hik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712661110; c=relaxed/simple;
	bh=HyApfXsKdgzR9JD09t2OqwfpoCCTnnwisp7iT4zyJ4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J47Er4+gUd3Q6mDxdotPrFzFonyEcpaMdknv1OxbfYiH9XGa4Lf5zEzDc12MMKfBbip1+ZzKA9e5xjLIiTLZ3Kns39dhh6ZptTqrlDEzDz6HseHVwN0lTQVUMNK5vdYH459hrIkylAgMKCB9CFB/Ew+ANQmnbI5Pys3H37j+XVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Tue, 9 Apr 2024 13:11:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sven Auhagen <sven.auhagen@voleatech.de>
Cc: netfilter-devel@vger.kernel.org, cratiu@nvidia.com, ozsh@nvidia.com,
	vladbu@nvidia.com, gal@nvidia.com, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: flowtable: infer TCP state and timeout
 before flow teardown
Message-ID: <ZhUibxdb005sYZNq@calendula>
References: <ZfqnTJKyW1VSIOgY@calendula>
 <lderg42fd4jbcwsztkidn3lhnjhufj5yv3zsdu4dpsenzikkta@cya5vq3prnzf>
 <ZfqsAoSNA4DRsVga@calendula>
 <nvslglowbvxntlpftefkumbwn2gz72evwnfvv4q2qencte7wyn@3jejk23urzeg>
 <Zfqxq3HK_nsGRLhx@calendula>
 <xvnywodpmc3eui6k5kt6fnooq35533jsavkeha7af6c2fntxwm@u3bzj57ntong>
 <Zfq-1gES4VJg2zHe@calendula>
 <o7kxkadlzt2ux5bbdcsgxlfxnfedzxv4jlfd3xnhri6qpr5w3n@2vmkj5o3yrek>
 <ZfrYpvJFrrajPbHM@calendula>
 <x3qvcfxgdmurfnydhrs7ao6fmxxubmhxs2mjk24yn5zjfbo3h5@esbr3eff7bir>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <x3qvcfxgdmurfnydhrs7ao6fmxxubmhxs2mjk24yn5zjfbo3h5@esbr3eff7bir>

Hi Sven,

On Mon, Apr 08, 2024 at 07:24:43AM +0200, Sven Auhagen wrote:
> Hi Pablo,
> 
> after some testing the problem only happens very rarely now.
> I suspect it happens only on connections that are at some point
> one way only or in some other way not in a correct state anymore.
> Never the less your latest patches are very good and reduce the problem
> to an absolute minimum that FIN WAIT is offlodaded and the timeout
> is correct now.

Thanks for testing, I am going to submit this patch.

If you have a bit more cycles, I still would like to know what corner
case scenario is still triggering this so...

> Here is one example if a flow that still is in FIN WAIT:
> 
> [NEW] tcp      6 120 SYN_SENT src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 [UNREPLIED] src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 mark=16777216
> [UPDATE] tcp      6 60 SYN_RECV src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 mark=16777216
> [UPDATE] tcp      6 86400 ESTABLISHED src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 [OFFLOAD] mark=16777216
> [UPDATE] tcp      6 120 FIN_WAIT src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 [OFFLOAD] mark=16777216
> [UPDATE] tcp      6 30 LAST_ACK src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 [ASSURED] mark=16777216
>  [UPDATE] tcp      6 120 TIME_WAIT src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 [ASSURED] mark=16777216
>  [DESTROY] tcp      6 TIME_WAIT src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 packets=15 bytes=1750 src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 packets=13 bytes=6905 [ASSURED] mark=16777216 delta-time=120

... could you run conntrack -E -o timestamp? I'd like to know if this is
a flow that is handed over back to classic path after 30 seconds, then
being placed in the flowtable again.
