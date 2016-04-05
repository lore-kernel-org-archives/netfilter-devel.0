From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH xtables-addons v2] build: fix configure compatiblity with
 POSIX shells
Date: Tue, 5 Apr 2016 12:25:37 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1604051225320.13423@nerf40.vanv.qr>
References: <f07a0a5cb8b3c5e1aee8b30c7fa21ccfbf24a95a.1459684812.git.mschiffer@universe-factory.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Matthias Schiffer <mschiffer@universe-factory.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:54854 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbcDEKZk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Apr 2016 06:25:40 -0400
In-Reply-To: <f07a0a5cb8b3c5e1aee8b30c7fa21ccfbf24a95a.1459684812.git.mschiffer@universe-factory.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2016-04-03 14:01, Matthias Schiffer wrote:

>The kernel version detection code uses some bashisms, which makes the build
>fail on Debian systems where /bin/sh links to dash. Replace with POSIX-
>conforming commands at the cost of requiring awk.
>---
>v2: reset IFS as early as possible 

applied
