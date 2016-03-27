From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [iptables PATCH] configure: exit if libnftnl is not found
Date: Sun, 27 Mar 2016 14:51:34 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1603271451020.23293@nerf40.vanv.qr>
References: <1459073146-11576-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:50950 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbcC0Mvh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Mar 2016 08:51:37 -0400
In-Reply-To: <1459073146-11576-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2016-03-27 12:05, Giuseppe Longo wrote:
>+++ b/configure.ac
>@@ -128,6 +128,13 @@ if test "x$enable_nftables" = "xyes"; then
> 
> 	PKG_CHECK_MODULES([libnftnl], [libnftnl >= 1.0.5], [nftables=1], [nftables=0])
> 
>+	if test "$nftables" = 0;
>+	then
>+		echo "*** Error: No suitable libnftnl found. ***"
>+		echo "    Please install the 'libnftnl' package."
>+		exit 1
>+	fi
>+

This is totally unnecessary. Just remove the 3rd and 4th argument from the
PKG_CHECK_MODULES call immediately preceding it if libnftnl has become
a hard requirement.
