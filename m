From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [nft PATCH] Make libnftables a local static library
Date: Thu, 30 Nov 2017 18:36:04 +0100 (CET)
Message-ID: <nycvar.YFH.7.76.1711301835250.31793@n3.vanv.qr>
References: <20171124140246.GA6881@salvia> <20171130171124.24408-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:58956 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750898AbdK3RgF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Nov 2017 12:36:05 -0500
In-Reply-To: <20171130171124.24408-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2017-11-30 18:11, Phil Sutter wrote:

>This changes Makefiles so that libnftables is built into a static
>library which is not installed. This allows for incompatible changes
>while still providing a library to link to for testing purposes.
>
>diff --git a/src/Makefile.am b/src/Makefile.am
>index 9f7a4bfbb90a4..07ddfd590dd8f 100644
>--- a/src/Makefile.am
>+++ b/src/Makefile.am
>@@ -27,9 +27,9 @@ parser_bison.o scanner.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-decl
> 
> BUILT_SOURCES = parser_bison.h
> 
>-lib_LTLIBRARIES = libnftables.la
>+noinst_LIBRARIES = libnftables.a

Making it a noinst_LTLIBRARIES would have the benefit that its dependencies are
at least recorded.
