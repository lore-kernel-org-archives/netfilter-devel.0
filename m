From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH iptables 1/3] android: libiptc: Fix socklen_t type mismatch
 on Android
Date: Mon, 28 Oct 2013 13:31:55 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1310281330550.5620@nerf07.vanv.qr>
References: <1382813433-20890-1-git-send-email-cernekee@gmail.com> <1382813433-20890-2-git-send-email-cernekee@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Kevin Cernekee <cernekee@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:34086 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756025Ab3J1Mb4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:31:56 -0400
In-Reply-To: <1382813433-20890-2-git-send-email-cernekee@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2013-10-26 20:50, Kevin Cernekee wrote:
> 
>-#if !defined(__GLIBC__) || (__GLIBC__ < 2)
>+#if !defined(__ANDROID__) && (!defined(__GLIBC__) || (__GLIBC__ < 2))
> typedef unsigned int socklen_t;
> #endif

Do we still need this group of 3 lines anyway? Are we willingly
targeting any libc which does not have socklen_t defined --
or glibc 1.x for that matter?
