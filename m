From: "Gareth Williams" <gwilliams@ubicom.com>
Subject: br_netfilter post routing hook question...
Date: Fri, 2 Apr 2010 07:18:54 -0700
Message-ID: <CB2DD11991B27C4F99935E6229450D320566AC7B@STORK.scenix.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from server70b.appriver.com ([74.205.4.150]:2379 "EHLO
	server70.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753880Ab0DBP13 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Apr 2010 11:27:29 -0400
Received: from [216.112.109.98] (HELO stork.scenix.com)
  by server70.appriver.com (CommuniGate Pro SMTP 5.3.3)
  with ESMTP id 117014210 for netfilter-devel@vger.kernel.org; Fri, 02 Apr 2010 10:19:35 -0400
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello chaps.

I have a module which hooks into the bridge on the post routing hook
(PF_BRIDGE).

I also enable bridge netfilter to allow iptables rules to process
packets - I set rules on the post_routing chain (mangle table) to set
marks on packets.

Unfortunately I cannot see these marks in my code because the priority
on the bridge_netfilter post routing hook is PRI_LAST.

Since it is PRI_LAST I have no room to put my hook lower than it - so I
will never see these marks.

The comment in br_netfilter.c for this hook says it has to be PRI_LAST
because ip_refrag() can return STOLEN - but does it really have to be
LAST???  Can't it be say, last-1 so I have at least some room to move my
module to see those marks?

I know I could enable ebtables and do it that way but I am happy using
the conntrack facilities within the iptables framework to monitor
connections over the bridge.  The product I am working on also has
limited power and adding yet another set of tables and hooks would just
cause more slowdown in the fast path - something I don't think we can
stand right now.

Am I missing something obvious?

Cheers for any advice.

Gareth
