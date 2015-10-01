From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libmnl: Failed to build with clang, incompatible
 EXPORT_SYMBOL(x) macro
Date: Thu, 1 Oct 2015 12:15:15 +0200
Message-ID: <20151001101515.GA2313@salvia>
References: <20150925040745.GA433@oxygen>
 <20150930221241.GA14943@salvia>
 <alpine.LSU.2.20.1510011119340.22579@nerf40.vanv.qr>
 <CAMQP0s=TACNduhH+_w0yWLtHnS5rUaQXXvKOfoVR7Mqz2ZYDhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
To: Neutron Soutmun <neo.neutron@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50652 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbbJAKI0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Oct 2015 06:08:26 -0400
Content-Disposition: inline
In-Reply-To: <CAMQP0s=TACNduhH+_w0yWLtHnS5rUaQXXvKOfoVR7Mqz2ZYDhA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 01, 2015 at 04:30:23PM +0700, Neutron Soutmun wrote:
> On Thu, Oct 1, 2015 at 4:20 PM, Jan Engelhardt <jengelh@inai.de> wrote:
> >
> > On Thursday 2015-10-01 00:12, Pablo Neira Ayuso wrote:
> >>On Fri, Sep 25, 2015 at 11:07:45AM +0700, Neutron Soutmun wrote:
> >>> The EXPORT_SYMBOL(x) macro causes clang compile error and warning
> >>> messges:
> >>>   error,   "note: previous definition is here"
> >>>   warning, "warning: attribute declaration must precede definition
> >>>             [-Wignored-attributes]"
> >>>   See: [1]
> >>>
> >>> This proposed patch has been prepared to fix this error which make the
> >>> EXPORT_SYMBOL macro define a precede definition of an attribute
> >>> declaration. This approach is both compatible with gcc and clang.
> >>
> >>We have more libraries using this approach, which resembles kernel
> >>coding. So we would need to update them all, which is a bit annoying.
> >
> > If you use an export map (-Wl,--version-script=), you don't strictly
> > need to have any of the EXPORT_SYMBOL tags in the C source.
> 
> +1

That sounds as a smaller patch, please send it to me for the existing
libraries that we have. Thanks.
