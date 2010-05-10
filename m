From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] iptables: optionally disable largefile support.
Date: Mon, 10 May 2010 10:00:13 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1005100959270.23890@obet.zrqbmnf.qr>
References: <1273476638-31417-1-git-send-email-karl@hiramoto.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Karl Hiramoto <karl@hiramoto.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42250 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551Ab0EJIAO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 May 2010 04:00:14 -0400
In-Reply-To: <1273476638-31417-1-git-send-email-karl@hiramoto.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-05-10 09:30, Karl Hiramoto wrote:

>Many toolchains for embedded systems don't have largefile support.
>
>+AC_ARG_ENABLE([largefile],
>+	AS_HELP_STRING([--disable-largefile], [Do not build largefile support]),
>+	[enable_largefile="$enableval"],
>+	[enable_largefile="yes";
>+	largefile_cflags='-D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64'])

What is the actual problem you are experiencing? If the toolchain does 
not support largefiles, the -D macros should not do anything, so that 
conversely, their presence is not harmful.

