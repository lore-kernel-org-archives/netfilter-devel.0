From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/6] netfilter: get rid of the grossness in netfilter.h
Date: Thu, 11 Feb 2010 10:02:18 +0100
Message-ID: <4B73C79A.2000706@trash.net>
References: <1265823547-10358-1-git-send-email-jengelh@medozas.de> <1265823547-10358-4-git-send-email-jengelh@medozas.de> <4B72F060.4050606@trash.net> <alpine.LSU.2.01.1002102205480.29603@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37126 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab0BKJCc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 04:02:32 -0500
In-Reply-To: <alpine.LSU.2.01.1002102205480.29603@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2010-02-10 18:44, Patrick McHardy wrote:
> 
>> Jan Engelhardt wrote:
>>> GCC is now smart enough to follow the inline trail correctly.
>>> vmlinux size remain the same.
>> Which one? The kernel currently supports 3.2+.
> 
> -rw-r--r-- 1 jengelh users 12659677 Feb 10 21:58 linux-gcc33/vmlinux.o.before
> -rw-r--r-- 1 jengelh users 12659557 Feb 10 22:00 linux-gcc33/vmlinux.o
> -rw-r--r-- 1 jengelh users 12874092 Feb 10 21:58 linux-gcc41/vmlinux.o.before
> -rw-r--r-- 1 jengelh users 12874005 Feb 10 22:01 linux-gcc41/vmlinux.o
> -rw-r--r-- 1 jengelh users 12986285 Feb 10 21:58 linux-gcc43/vmlinux.o.before
> -rw-r--r-- 1 jengelh users 12986236 Feb 10 22:02 linux-gcc43/vmlinux.o
> -rw-r--r-- 1 jengelh users 12915901 Feb 10 21:58 linux-gcc44/vmlinux.o.before
> -rw-r--r-- 1 jengelh users 12915884 Feb 10 22:03 linux-gcc44/vmlinux.o
> -rw-r--r-- 1 jengelh users 12946544 Feb 10 21:58 linux-gcc45/vmlinux.o.before
> -rw-r--r-- 1 jengelh users 12946520 Feb 10 22:04 linux-gcc45/vmlinux.o
> 

Thanks, this looks fine.
