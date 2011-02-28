From: xuhainanjing <xuhainanjing@126.com>
Subject: Re:[ANNOUNCE] conntrack-tools 1.0.0 released
Date: Mon, 28 Feb 2011 14:45:58 +0800 (CST)
Message-ID: <19d8f05.90c8.12e6b0428c5.Coremail.xuhainanjing@126.com>
References: <4D69B6BB.7020309@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	lwn@lwn.net, netfilter-announce@lists.netfilter.org
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m15-91.126.com ([220.181.15.91]:47067 "EHLO m15-91.126.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab1B1HSI convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Feb 2011 02:18:08 -0500
In-Reply-To: <4D69B6BB.7020309@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

unsubscribe
At 2011-02-27 10:28:11=A3=AC"Pablo Neira Ayuso" <pablo@netfilter.org> w=
rote:
>Hi!
>
>The Netfilter project presents the first stable release of the
>conntrack-tools, that is composed of:
>
>- The userspace daemon so-called conntrackd that covers the specific
>aspects of stateful Linux firewalls to enable high availability
>solutions. It can be used as statistics collector of the firewall use =
as
>well, although ulogd2 is the prefered option for logging. The daemon i=
s
>highly configurable and extensible.
>
>- The command line interface (CLI) conntrack that provides an interfac=
e
>to add, delete and update flow entries, list current active flows in
>plain text/XML, current IPv4 NAT'ed flows, reset counters, and flush t=
he
>complete connection tracking table among many other.
>
>This summary of changes with regards to previous is the following:
>
>- improvements for the autotools/build infrastructure from Jan Engelha=
rdt.
>- lots of documentation updates.
>- SYN_SENT2 support for the command line tool conntrack (which was add=
ed
>in Linux kernel >=3D 2.6.31).
>- allow to listen to update and destroy expectation events (it require=
s
>a Linux kernel >=3D 2.6.37).
>- conntrack timestamping support with -o ktimestamp (this support
>requires the upcoming Linux 2.6.38).
>- one fix for conntrackd: two very consecutive commit invocations with
>option -c may result in the hang of the second commit invocation if th=
e
>first commit did not finish yet. As a result the second commit
>invocation required a manual SIGTERM.
>
>See changelog attached for more details.
>
>You can download it from:
>http://www.netfilter.org/projects/conntrack-tools/downloads.html
>
>More information at:
>http://conntrack-tools.netfilter.org
>
>Official documentation at:
>http://conntrack-tools.netfilter.org/manual.html
>
>enjoy!
>Pablo

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
