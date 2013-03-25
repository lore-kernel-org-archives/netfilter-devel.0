From: dmitry pervushin <dpervushin@gmail.com>
Subject: Android netfilter patches (xt_IDLETIMER) [0/3]
Date: Mon, 25 Mar 2013 23:08:36 +0100
Message-ID: <5150CAE4.1050608@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53558 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758993Ab3CYWIk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Mar 2013 18:08:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello all,

I would like to return to the Android netfilter patches that were posted
in the thread here --
http://article.gmane.org/gmane.linux.kernel/1362838. These patches were
updated according to feedback that John Stultz had received from the list.

So, the first serie of patches is for xt_IDLETIMER.
The first small patches fixes the case when the idle timer has expired
and we refreshing it without any notifications.
The second patch adds capability to send netlink message notifications
in addition to sysfs notifications.
And the last patch is for iptables to use the updated IDLETIMER kernel
module.
