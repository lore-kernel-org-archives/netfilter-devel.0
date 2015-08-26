From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH] nfct: don't link against
 libnetfilter_conntrack
Date: Wed, 26 Aug 2015 20:46:50 +0200
Message-ID: <20150826184650.GA15075@salvia>
References: <20150820113841.3543.68437.stgit@nfdev2.cica.es>
 <alpine.LSU.2.20.1508202029210.27052@nerf40.vanv.qr>
 <CAOkSjBjWKU_T6+nmXRnOS9EqQmpu49wtxrXFQFYgV4LUG4XbxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@inai.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49729 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbbHZSk3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Aug 2015 14:40:29 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBjWKU_T6+nmXRnOS9EqQmpu49wtxrXFQFYgV4LUG4XbxQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 21, 2015 at 08:54:00AM +0200, Arturo Borrero Gonzalez wrote:
> On 20 August 2015 at 20:30, Jan Engelhardt <jengelh@inai.de> wrote:
> > On Thursday 2015-08-20 13:38, Arturo Borrero Gonzalez wrote:
> >
> >>The nfct program uses none of the symbols of libnetfilter_conntrack.
> >>
> >>Linking against it means that distributors have to maintain an useless
> >>depedency.
> >
> > Not to say the patch is bad, but:
> > Distributions do not really have to maintain a dependency anyway,
> > as it can be autodiscovered from the DT_NEEDED entries. In addition,
> > conntrackd still uses the library, so a dependency in the package
> > will stay around.
> 
> In case of debian, there are 3 different binary packages for
> conntrack, conntrackd and nfct. Each package may have different
> dependencies.

Also applied, thanks Arturo.
