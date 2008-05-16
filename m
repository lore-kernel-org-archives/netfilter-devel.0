From: Patrick McHardy <kaber@trash.net>
Subject: [ANNOUNCE]: Move to git completed
Date: Fri, 16 May 2008 15:31:28 +0200
Message-ID: <482D8CB0.4020507@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	netfilter <netfilter@lists.netfilter.org>,
	Netfilter Core Team <coreteam@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44723 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbYEPNbb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 May 2008 09:31:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I've completed the move to git for iptables, all libraries
and conntrack-tools and SVN for these subtrees will not be
updated anymore from now on.

The remaining alive subtrees will follow shortly:

- documentation
- homepage
- ulog
- ulog2 branch
- patch-o-matic-ng

and possibly ipset in case Jozsef wants to switch it as well. I'll
send a seperate announcement when these trees have moved.

gitweb is set up at [1], the git-daemon is running on [2]. A link
to a git overview, a tutorial and the manual is on the main gitweb
page.

If there are any problems, please let me know.


[1] http://git.netfilter.org/cgi-bin/gitweb.cgi
[2] git://git.netfilter.org
