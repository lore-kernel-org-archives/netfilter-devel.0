From: Florian Westphal <fw@strlen.de>
Subject: NOTRACK removal breaks working configurations
Date: Thu, 20 Dec 2012 11:23:58 +0100
Message-ID: <20121220102358.GC17461@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Cong Wang <xiyou.wangcong@gmail.com>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33631 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336Ab2LTKYA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Dec 2012 05:24:00 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo,

please consider reverting

commit 965505015beccc4ec900798070165875b8e8dccf
Author: Cong Wang <xiyou.wangcong@gmail.com>
Subject: netfilter: remove xt_NOTRACK

It breaks working netfilter configurations.
At the very least, NOTRACK should have printk'd

BIG FAT REMOVAL WARNING

for a year or so.  Which it didn't do.

Now, someone updating from 3.6 to 3.7 will get iptables-restore failure.
