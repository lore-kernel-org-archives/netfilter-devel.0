From: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH] ipvs: explicitly forbid ipv6 service/dest creation if
 ipv6 mod is disabled
Date: Mon, 24 Apr 2017 11:54:44 +0200
Message-ID: <20170424095444.GF2047@verge.net.au>
References: <2a5c88ca5670baade900e2b1f05a0dcc9927a29d.1492681122.git.pabeni@redhat.com>
 <alpine.LFD.2.20.1704221355290.1974@ja.home.ssi.bg>
 <1493016651.5744.1.camel@redhat.com>
 <alpine.LFD.2.20.1704241017030.2492@ja.home.ssi.bg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Paolo Abeni <pabeni@redhat.com>, netfilter-devel@vger.kernel.org,
        lvs-devel@vger.kernel.org, Wensong Zhang <wensong@linux-vs.org>,
        netdev@vger.kernel.org
To: Julian Anastasov <ja@ssi.bg>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:40557 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1168204AbdDXJyv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Apr 2017 05:54:51 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.20.1704241017030.2492@ja.home.ssi.bg>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 24, 2017 at 10:21:30AM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Mon, 24 Apr 2017, Paolo Abeni wrote:
> 
> > Hi,
> > 
> > The problem with the patched code is that it tries to resolve ipv6
> > addresses that are not created/validated by the kernel.
> 
> 	OK. Simon, please apply to ipvs tree.
> 
> Acked-by: Julian Anastasov <ja@ssi.bg>

Thanks, done.
