From: Maxim Britov <maxim.britov@gmail.com>
Subject: iptables 1.4.1 + iprange fails for me
Date: Fri, 13 Jun 2008 09:02:36 +0300
Message-ID: <20080613090236.417411cd@maxim.office.modum.by>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.office.modum.by ([212.98.173.82]:57896 "EHLO
	mail.office.modum.by" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbYFMGJZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2008 02:09:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I updated yesterday kernel + iptables on my router (into Internet) box.
Kernel from kernel.org 2.6.25.6 + iptables 1.4.1-1 from fedora rawhide.
I'm use kernel without modules on that box.

I found troubles with iprange:
# iptables -A INPUT -m iprange --src-range 1.1.1.1-2.2.2.2 -j DROP
# iptables-save |fgrep range
-A INPUT -m iprange -j DROP

iptables -L -n show it as:
DROP       all  --  0.0.0.0/0            0.0.0.0/0           



-- 
Maxim Britov

GnuPG KeyID 0x4580A6D66F3DB1FB              xmpp:maxim@modum.by
Fingerprint:  4059 B5C5 8985 5A47 8F5A 8623 4580 A6D6 6F3D B1FB
GnuPG-ru Team (http://lists.gnupg.org/mailman/listinfo/gnupg-ru
               xmpp:gnupg-ru@conference.jabber.ru)
