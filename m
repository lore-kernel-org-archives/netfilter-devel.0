From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: ftp: Check data size before copy them
 into FTP buffer
Date: Mon, 5 Oct 2015 11:07:31 +0200
Message-ID: <20151005090731.GA1806@salvia>
References: <BAY403-EAS3244BB5B8769FABE83B01EF954E0@phx.gbl>
 <20151004201620.GA30723@salvia>
 <alpine.LSU.2.20.1510042338260.19792@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Feng Gao <gfree.wind@outlook.com>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54285 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbbJEJAe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Oct 2015 05:00:34 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1510042338260.19792@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 04, 2015 at 11:38:59PM +0200, Jan Engelhardt wrote:
> On Sunday 2015-10-04 22:16, Pablo Neira Ayuso wrote:
> 
> >On Tue, Sep 29, 2015 at 04:49:32PM +0800, Feng Gao wrote:
> >> When TCP endpoint supports the windows scale option, the data size could
> >> be more than 65536 easily. And there are some network interface features
> >> which could aggregate multiple packets. So we need to check the datalen
> >> before copy data into the FTP buffer.
> >
> >I don't think you can go over the maximum IPv4/IPv6 packet length with
> >aggregation.
> 
> But there are jumbo frames known to IPv6, at least in principle. Dunno
> if GRO/TSO/.. do that, though.

I didn't find any code to aggregate IPv6 jumbograms packets at quick
glance. Actually, this needs changes in the existing transport
protocols to work: https://tools.ietf.org/html/rfc2675
