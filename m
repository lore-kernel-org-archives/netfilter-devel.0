From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: iptables release
Date: Fri, 30 Nov 2007 18:49:48 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711301846491.18767@fbirervta.pbzchgretzou.qr>
References: <474F2670.8080509@trash.net> <Pine.LNX.4.64.0711292205040.3089@fbirervta.pbzchgretzou.qr>
 <474F312B.5060103@trash.net> <200711301737.lAUHbXWh002545@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, hawk@diku.dk, netfilter-devel@vger.kernel.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52292 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758230AbXK3Rtt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Nov 2007 12:49:49 -0500
In-Reply-To: <200711301737.lAUHbXWh002545@toshiba.co.jp>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Dec 1 2007 02:37, Yasuyuki KOZAKAI wrote:
>
>$ svn log -r5092 -v http://svn.netfilter.org/netfilter
>------------------------------------------------------------------------
>r5092 | (no author) | 2004-10-11 22:40:52 +0900 (Mon, 11 Oct 2004) | 1 line
>
>This is an empty revision for padding.

While empty commits can happen (it does take a specific course of action
though), the log message is unusual, esp. with (no author) and "This is an
empty revision for padding".

>------------------------------------------------------------------------
>
>** What I did to create iptables git tree
>
>I did
>	$ git-svnimport -v -s 702 -l 3070 -T iptables/trunk	\
>		http://svn.netfilter.org/netfilter 
>
>I thought that such argument to -T was not expected by the author of
>git-svnimport, but it seemd to work. ;) I did not use -b and -t for
>branches and tags. Because I found that some commits on 'origin' were
>broken by them.
>
>Sometimes the TCP connection to SVN server was disconnected while importing.
>In that case, I reset 'origin' and 'master' branch so that they refered
>the last suceeded commit, removed .git/SVN2GIT_HEAD and .git/ORIG_HEAD,
>and excecuted git-svnimport without '-s' again.

I would have rsynced the svn tree off, then do a local svn-to-git transform.
That would have avoided potentially dangerous disconnects.

>** A Comment
>Well, I don't want to do this again :)

Heh.
