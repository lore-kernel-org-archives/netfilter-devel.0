From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables 1.4.0.77, Xtables-addons 1.5.4.1
Date: Sun, 27 Apr 2008 15:00:12 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804271425100.20150@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34918 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbYD0NAN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Apr 2008 09:00:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


I have uploaded an (unofficial) tarball of the current (official) HEAD 
from the SCM up to 
http://dev.medozas.de/files/xtables/iptables-1.4.0.77.tar.bz2 (+ .asc). 
The version number is derived from git-describe telling me it has been 
77 commits since the last tag (Dec 22 2007), and it should not interfere 
with any official release numbering plans. It seemed time to release 
something in tarball form, the 5-6 month turnaround period for 
official iptables tarballs is too long IMHO, at least when patches have 
gone in.


Second, the Xtables-addons compile error with 2.6.18-stable has been 
addressed, which should make a few Debian/Etch get better success. No 
other changes interesting for end-users were made. URL is 
http://dev.medozas.de/files/xtables/ where everything can be found 
(including the -combined package that many prefer for the time being).
