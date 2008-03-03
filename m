From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: iptables/xtables git repository
Date: Mon, 3 Mar 2008 01:08:12 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803030025380.27717@fbirervta.pbzchgretzou.qr>
References: <47BEC691.8040905@trash.net> <200802221313.m1MDDEBV012684@toshiba.co.jp>
 <47BECB78.4060405@trash.net> <200803011036.m21Aajwa005038@toshiba.co.jp>
 <Pine.LNX.4.64.0803011344200.20168@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44289 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbYCCAIN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Mar 2008 19:08:13 -0500
In-Reply-To: <Pine.LNX.4.64.0803011344200.20168@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>On Mar 1 2008 19:36, Yasuyuki KOZAKAI wrote:
>>
>>I've updated them and created some more trees.
>>
>>Now the recent trees are available at
>>
>>	rsync://people.netfilter.org/users/yasuyuki/git/iptables.git
>>	rsync://people.netfilter.org/users/yasuyuki/git/iptables.git

I have refined this, tracked all author information, tagged it, etc.
(Latest commit from Pablo also included ...)

I already named the repository xtables because that is what it
is going to be (the presence of both iptables and ip6tables itself
already gives reason to use 'x'tables ;-)

	git://dev.computergmbh.de/xtables
	http://dev.computergmbh.de/gitweb.cgi?p=xtables

Feel free to clone, or give faith to declare it official.

I will rebase my Xtables 1.5.x branch on top of that, then submit.

Again, I would like to make aware of Xtables-addons, which is
supposed to be a new patch-o-matic from the ground up.

>>	rsync://people.netfilter.org/users/yasuyuki/git/conntrack-tools.git
>>	rsync://people.netfilter.org/users/yasuyuki/git/ipset.git
>>	rsync://people.netfilter.org/users/yasuyuki/git/libnetfilter_conntrack.git
>>	rsync://people.netfilter.org/users/yasuyuki/git/libnetfilter_cthelper.git
>>	rsync://people.netfilter.org/users/yasuyuki/git/libnetfilter_log.git
>>	rsync://people.netfilter.org/users/yasuyuki/git/libnetfilter_queue.git
>>	rsync://people.netfilter.org/users/yasuyuki/git/libnfnetlink.git
>>	rsync://people.netfilter.org/users/yasuyuki/git/patch-o-matic-ng.git
>>	rsync://people.netfilter.org/users/yasuyuki/git/ulog.git

You can postprocess these with the quick translators I wrote:

	http://dev.computergmbh.de/f/iptables.aux/

do_rewrite will translate the X509 style author names to git,
do_rewrite2 will go through each commit which allows to clean it
according to Linux-2.6.git log standards (= one subject line,
and then the message). Often a subject line is missing, which
looks very odd in gitk then. This is where do_rewrite2 helps.

	$ rsync://people.netfilter.org/.../conntrack-tools.git
	  .git/
	$ git-reset --hard
	$ git-status
	$ /tmp/iptables.aux/do_rewrite HEAD
	$ /tmp/iptables.aux/do_rewrite2 HEAD

	Should you get tired during edit or want to re-edit a commit,
	touch /tmp/skip and finish the rewrite process.
	Then remove /tmp/skip again and use

	do_rewrite2  commit^..HEAD
