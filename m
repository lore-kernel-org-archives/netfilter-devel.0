From: Iain Fraser <iainkfraser@gmail.com>
Subject: netfilter hooks context?
Date: Fri, 19 Oct 2012 17:18:09 +0100
Message-ID: <CA+bLfK6x6F5g_h+0ersDHmPDCH14LEaoHQDPOmBP-uCUjBC+bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35020 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab2JSQSJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:18:09 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so893940iea.19
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Oct 2012 09:18:09 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I'm writing a LKM that uses netfilter hooks. I thought that netfilter
hooks were run in softirq context. So when using spinlocks in the
hooks I use plain spin_lock and in any process context code e.g. proc
I use spin_lock_bh. However my code occasionally deadlocks with this
single lock.

If the hooks were running in softirq context this wouldn't occur
because softirq's don't preemept each other on the same processor. So
now I'm wondering if my original softirq assumption was incorrect. Can
a hook be called from NON softirq context?

thanks in advance
Iain
