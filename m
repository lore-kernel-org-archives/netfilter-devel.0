From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 3/6] netfilter: get rid of the grossness in netfilter.h
Date: Wed, 10 Feb 2010 22:07:47 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002102205480.29603@obet.zrqbmnf.qr>
References: <1265823547-10358-1-git-send-email-jengelh@medozas.de> <1265823547-10358-4-git-send-email-jengelh@medozas.de> <4B72F060.4050606@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49060 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756206Ab0BJVHt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 16:07:49 -0500
In-Reply-To: <4B72F060.4050606@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-02-10 18:44, Patrick McHardy wrote:

>Jan Engelhardt wrote:
>> GCC is now smart enough to follow the inline trail correctly.
>> vmlinux size remain the same.
>
>Which one? The kernel currently supports 3.2+.

-rw-r--r-- 1 jengelh users 12659677 Feb 10 21:58 linux-gcc33/vmlinux.o.before
-rw-r--r-- 1 jengelh users 12659557 Feb 10 22:00 linux-gcc33/vmlinux.o
-rw-r--r-- 1 jengelh users 12874092 Feb 10 21:58 linux-gcc41/vmlinux.o.before
-rw-r--r-- 1 jengelh users 12874005 Feb 10 22:01 linux-gcc41/vmlinux.o
-rw-r--r-- 1 jengelh users 12986285 Feb 10 21:58 linux-gcc43/vmlinux.o.before
-rw-r--r-- 1 jengelh users 12986236 Feb 10 22:02 linux-gcc43/vmlinux.o
-rw-r--r-- 1 jengelh users 12915901 Feb 10 21:58 linux-gcc44/vmlinux.o.before
-rw-r--r-- 1 jengelh users 12915884 Feb 10 22:03 linux-gcc44/vmlinux.o
-rw-r--r-- 1 jengelh users 12946544 Feb 10 21:58 linux-gcc45/vmlinux.o.before
-rw-r--r-- 1 jengelh users 12946520 Feb 10 22:04 linux-gcc45/vmlinux.o
