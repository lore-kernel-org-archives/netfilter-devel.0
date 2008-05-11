From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: Re: CAN you give me a piece of sample code to implement this
	iptablescommand? thanks
Date: Mon, 12 May 2008 01:11:50 +0200
Message-ID: <1210547510.23433.28.camel@henriknordstrom.net>
References: <200805112243513753221@fiberhome.com.cn>
	 <200805112347000787949@fiberhome.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: cyx <cyx@fiberhome.com.cn>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vps1.henriknordstrom.net ([195.20.207.177]:43335 "EHLO
	vps1.henriknordstrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758064AbYEKXa3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 May 2008 19:30:29 -0400
In-Reply-To: <200805112347000787949@fiberhome.com.cn>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On s=C3=B6n, 2008-05-11 at 23:47 +0800, cyx wrote:
> So there is no APIs we can use to manipulate the kernel's iptables,
> except invoking the "iptables" command from shell? so wired, it shoul=
d
> be have some APIs to do the same as the "iptables" does.         =20

A pipe to iptables-restore -n is generally the recommended API. Gives
you the full command line of iptables in an reasonably efficient manner=
=2E

*nat
-A POSTROUTING -o ppp0 -j MASQUERADE
COMMIT

You may want to restart iptables-restore from time to time just in case
there is memory leaks somewhere, but other than that the pipe can stay
persistent, at least until there is an error in the submitted rules
(causes iptables-restore to exit with an error)

What is missing is an efficient way to read out rules from the kernel.
iptables-restore can only read the human intented version (-L), and
iptables-save is a little too blunt in what it dumps for many purposes.=
=2E

Regards
Henrik



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
