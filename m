From: Jan Engelhardt <jengelh@medozas.de>
Subject: ipset: make header files usable from userspace (v2)
Date: Wed, 31 Aug 2011 14:10:03 +0200
Message-ID: <1314792606-9930-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:60273 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755243Ab1HaMKI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Aug 2011 08:10:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


While refreshing iptables's header files with new ones from the
kernel, libxt_SET fails to compile because some definitions were
locked away in __KERNEL__ sections when they should not have been.

>In the second patch please move the type id and the ip_set_dim enum
>together outside of the __KERNEL__ section. Thus a single #ifdef
>section suffices. Thanks!

done so now.
