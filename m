From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: ipset: use NFPROTO_ constants
Date: Tue, 30 Aug 2011 14:50:16 +0200
Message-ID: <4E5CDC88.4000506@trash.net>
References: <alpine.LNX.2.01.1108251046050.1457@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54752 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab1H3MuR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Aug 2011 08:50:17 -0400
In-Reply-To: <alpine.LNX.2.01.1108251046050.1457@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25.08.2011 10:46, Jan Engelhardt wrote:
> parent 51b33b93d4c2e6c63afb177158f660fd17daf47c (v3.1-rc2-3-g51b33b9)
> commit bf6e2b96ffe871285cd6e9d24c8d23fbf84386e0
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Thu Aug 25 10:18:44 2011 +0200
> 
> netfilter: ipset: use NFPROTO_ constants
> 
> ipset is actually using NFPROTO values rather than AF (xt_set
> passes that along).
> 
> Semantic patch for the change:
> // <smpl>
> @@
> @@
> -AF_UNSPEC
> +NFPROTO_UNSPEC
> @@
> @@
> -AF_INET
> +NFPROTO_IPV4
> @@
> @@
> -AF_INET6
> +NFPROTO_IPV6
> // </smpl>
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>

I'll wait for Jozsef to either Ack the patches or send them to me
before applying them.
