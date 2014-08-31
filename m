From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: does "iptables -t filter -A INPUT --match conntrack --ctstate RELATED,ESTABLISHED
 -j ACCEPT" gives a false sense of security ?
Date: Sun, 31 Aug 2014 13:52:48 +0200
Message-ID: <54030C90.4090300@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:54671 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbaHaLww (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 31 Aug 2014 07:52:52 -0400
Received: from [192.168.178.21] ([85.177.149.110]) by mail.gmx.com (mrgmx102)
 with ESMTPSA (Nemesis) id 0LsOsW-1YQ5Pd3WZ6-011xiP for
 <netfilter-devel@vger.kernel.org>; Sun, 31 Aug 2014 13:52:49 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I misconfigured my Gentoo iptables script and could therefore not download source code archives via ftp. I "repaired" that script and restarted it - ftp was possible. After a reboot however ftp won't work again. I realized that probably a parallel Gentoo emerge job jumped into the restart sequence of the iptables script and therefore the ftp download could be finished.

Now I'm wondering if this is a "works as desigend" feature and how this racy mischance can be avoided.

-- 
Toralf
pgp key: 0076 E94E

