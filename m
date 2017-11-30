From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH] Make libnftables a local static library
Date: Thu, 30 Nov 2017 19:30:08 +0100
Message-ID: <20171130183008.GP32305@orbyte.nwl.cc>
References: <20171124140246.GA6881@salvia>
 <20171130171124.24408-1-phil@nwl.cc>
 <nycvar.YFH.7.76.1711301835250.31793@n3.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:52310 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750877AbdK3SaM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Nov 2017 13:30:12 -0500
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1711301835250.31793@n3.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 30, 2017 at 06:36:04PM +0100, Jan Engelhardt wrote:
> 
> On Thursday 2017-11-30 18:11, Phil Sutter wrote:
> 
> >This changes Makefiles so that libnftables is built into a static
> >library which is not installed. This allows for incompatible changes
> >while still providing a library to link to for testing purposes.
> >
> >diff --git a/src/Makefile.am b/src/Makefile.am
> >index 9f7a4bfbb90a4..07ddfd590dd8f 100644
> >--- a/src/Makefile.am
> >+++ b/src/Makefile.am
> >@@ -27,9 +27,9 @@ parser_bison.o scanner.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-decl
> > 
> > BUILT_SOURCES = parser_bison.h
> > 
> >-lib_LTLIBRARIES = libnftables.la
> >+noinst_LIBRARIES = libnftables.a
> 
> Making it a noinst_LTLIBRARIES would have the benefit that its dependencies are
> at least recorded.

Oh, thanks for the hint! I wasn't aware this is supported at all. In
fact, doing so shrinks my patch to a one-liner. :)

Thanks, Phil
