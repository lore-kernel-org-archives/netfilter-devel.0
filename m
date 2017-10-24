From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2 0/4] libnftables preparations
Date: Tue, 24 Oct 2017 17:20:33 +0200
Message-ID: <20171024152033.GA31888@salvia>
References: <20171023153319.13415-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="C7zPtVaVf+AK4Oqc"
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37976 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751550AbdJXPUj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2017 11:20:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AB2A2E8E8C
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 17:20:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 99B3DDA86B
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 17:20:37 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171023153319.13415-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 23, 2017 at 05:33:15PM +0200, Phil Sutter wrote:
> The following series prepares libnftables libarary split-off by moving
> API functions into src/libnftables.c, introducing
> include/nftables/nftables.h and enhancing the code by a number of
> getters and setters for applications to change configurable parts of
> struct nft_ctx without knowledge of that struct's internals.
> 
> The 'nft' binary will become the first "demo" user of libnftables and
> acts as a reference for library design and usability.

Series applied.

I have to merged this patch below to 1/4.

--C7zPtVaVf+AK4Oqc
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/configure.ac b/configure.ac
index b01c5bdef0eb..099a4a5e81ec 100644
--- a/configure.ac
+++ b/configure.ac
@@ -140,6 +140,7 @@ AC_CONFIG_FILES([					\
 		Makefile				\
 		src/Makefile				\
 		include/Makefile			\
+		include/nftables/Makefile		\
 		include/linux/Makefile			\
 		include/linux/netfilter/Makefile	\
 		include/linux/netfilter_arp/Makefile	\

--C7zPtVaVf+AK4Oqc--
