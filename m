From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [conntrack-tools PATCH] nfct: don't link against
 libnetfilter_conntrack
Date: Thu, 20 Aug 2015 20:30:55 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1508202029210.27052@nerf40.vanv.qr>
References: <20150820113841.3543.68437.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:55726 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbbHTSa5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2015 14:30:57 -0400
In-Reply-To: <20150820113841.3543.68437.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2015-08-20 13:38, Arturo Borrero Gonzalez wrote:

>The nfct program uses none of the symbols of libnetfilter_conntrack.
>
>Linking against it means that distributors have to maintain an useless
>depedency.

Not to say the patch is bad, but:
Distributions do not really have to maintain a dependency anyway, 
as it can be autodiscovered from the DT_NEEDED entries. In addition,
conntrackd still uses the library, so a dependency in the package
will stay around.
