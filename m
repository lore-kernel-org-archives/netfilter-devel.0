From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] add missing ipset_parse_tcp_udp_port to libipset.map
Date: Fri, 24 Oct 2014 22:08:24 +0200 (CEST)
Message-ID: <alpine.LSU.2.11.1410242206380.16647@nerf08.vanv.qr>
References: <544AA6FF.1000803@mageia.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu
To: Thomas Backlund <tmb@mageia.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:33215 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825AbaJXUI0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2014 16:08:26 -0400
In-Reply-To: <544AA6FF.1000803@mageia.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2014-10-24 21:23, Thomas Backlund wrote:

> Found this issue when we switched from 6.19 static build to 6.21 dynamic build,
> and is still there in 6.23

What has been released is immutable; after a release, only add 
symbols to new sections.
