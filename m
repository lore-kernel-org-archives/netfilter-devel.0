From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: [0/3] conntrack event kernel issues
Date: Thu, 22 May 2008 10:12:53 +0100
Message-ID: <1211447573.6878.36.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36336 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760439AbYEVJNL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 05:13:11 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I plan to use netfilter conntrack events to count the number of
connections which timed out without having received a reply. To make
this as efficient as possible I only want to monitor destroy events. I
have noticed three issues with that and wrote patches to solve them.
They follow in separate mails.

Please let me know what you think about them and if they could be useful
for other people as well.

patch1: export ct->status on all conntrack events
patch2: set SEEN_REPLY before destroying a conntrack on TCP RST
patch3: new status flag SEEN_RELATED


Regards,

Fabian

