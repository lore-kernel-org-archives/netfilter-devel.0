From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [nft PATCH 1/4] include: cache a copy of kernel ebtables.h
Date: Wed, 8 Apr 2015 17:22:49 -0700
Message-ID: <20150408172249.49bbc646@urahara>
References: <20150408174818.28553.96128.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36079 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbbDIAWo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Apr 2015 20:22:44 -0400
Received: by pabsx10 with SMTP id sx10so130924824pab.3
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Apr 2015 17:22:44 -0700 (PDT)
In-Reply-To: <20150408174818.28553.96128.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 08 Apr 2015 19:48:18 +0200
Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:

> From: Arturo Borrero Gonzalez <aborrero@nfdev2.cica.es>
> 
> Required for next patches.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

If you are going to import a kernel header, it should be the exact version
produced by doing: 
  $ make headers_install
in the kernel source directory
the result of that make is files in usr/include/linux

And your version differs:


$ diff -up usr/include/linux/netfilter_bridge/ebtables.h /tmp/ebtables.h 
--- usr/include/linux/netfilter_bridge/ebtables.h	2015-02-05 10:17:17.865621216 -0800
+++ /tmp/ebtables.h	2015-04-08 17:20:40.265458995 -0700
@@ -12,9 +12,7 @@
 
 #ifndef __LINUX_BRIDGE_EFF_H
 #define __LINUX_BRIDGE_EFF_H
-#include <linux/if.h>
 #include <linux/netfilter_bridge.h>
-#include <linux/if_ether.h>
 
 #define EBT_TABLE_MAXNAMELEN 32
 #define EBT_CHAIN_MAXNAMELEN EBT_TABLE_MAXNAMELEN
