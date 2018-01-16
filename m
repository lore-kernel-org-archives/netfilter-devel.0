From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [ANNOUNCE] nftables 0.8.1 release
Date: Tue, 16 Jan 2018 15:48:24 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1801161547001.14457@n3.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:37610 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750790AbeAPOs0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 09:48:26 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>        nftables 0.8.1
>
>This release contains mostly incremental fixes and documentation 
>updates, such as fixing up ./configure --with-mini-gmp for embedded 
>setups that don't have libgmp.

Why is this now installing a libnftables.pc file when there is no 
library or headers to go with it? (Remember that libnftables.la is 
listed for "noinst_LTLIBRARIES".)
