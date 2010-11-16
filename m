From: Jan Engelhardt <jengelh@medozas.de>
Subject: vfree during RCU
Date: Tue, 16 Nov 2010 13:10:14 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011161307080.3591@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42057 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934342Ab0KPMKP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Nov 2010 07:10:15 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


Given ruleset sizes, using kmalloc proves to be difficult currently, so 
vfree is generally used. I tried hooking that up with RCU, but quickly 
found that vfree in RCU is a bad idea. What comes to mind to solve this 
is to use an extra kthread which can tolerate sleeping. Do you know of 
ideas preferable to a cleaning-up kthread?

Jan
