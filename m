From: Pierre Rondou <prondou@gmail.com>
Subject: Netfilter Module for NAT64 available
Date: Wed, 01 Jun 2011 01:57:22 +0200
Message-ID: <4DE58062.90207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: behave@ietf.org, v6ops@ietf.org, netfilter-devel@vger.kernel.org,
	evyncke@cisco.com, guy.leduc@ulg.ac.be,
	Cyril Soldani <cyril.soldani@ulg.ac.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:27551 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932972Ab1EaX5a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2011 19:57:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello everybody,

I'm currently a student at the University of Li=E8ge. As part of my mas=
ter=20
thesis, I have to develop a Linux kernel module for NAT64 (=20
http://datatracker.ietf.org/doc/rfc6146/ ).

I now consider my module as finished (i.e, all functionalities are=20
implemented) and publish it.

It is available on sourceforge:

http://sourceforge.net/projects/nat64/

=46eel free to test it and report to me any bug, bad implementation,=20
error, ...

Like my previous module (http://sourceforge.net/projects/nativi/ , whic=
h=20
have been updated), it can get included in Xtables/Kernel if you want,=20
for now it is limited to 2.6.32 kernel.
I may provide patches for this a bit later.

Documentation is provided in the source code, if you have any question=20
don't hesitate to ask me.

Regards,

Pierre RONDOU
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
