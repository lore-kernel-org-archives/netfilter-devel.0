From: Pierre Rondou <prondou@gmail.com>
Subject: Netfilter Module for NAT IVI available
Date: Thu, 05 May 2011 03:18:04 +0200
Message-ID: <4DC1FACC.4080204@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: guy.leduc@ulg.ac.be, evyncke@cisco.com,
	Cyril Soldani <cyril.soldani@ulg.ac.be>
To: behave@ietf.org, v6ops@ietf.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:35714 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252Ab1EEBSG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 May 2011 21:18:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello everybody,

I'm currently a student at the University of Li=E8ge. As part of my mas=
ter=20
thesis, I have to develop a Linux kernel module for IVI (=20
http://datatracker.ietf.org/doc/rfc6219/ ).

I now consider my module as finished (i.e, all functionalities are=20
implemented) and publish it.

It is available on sourceforge:

http://sourceforge.net/projects/nativi/

=46eel free to test it and report to me any bug, bad implementation,=20
error, ...

If you believe that this module can be included is the Linux Kernel or=20
in the Xtables-addons framework, I'll be glad and will help you in this=
=20
task.


I have tested my module inside the Xtables-addons framework (version=20
1.32) on a debian squeeze (6.0.1) linux with a 2.6.32-5  kernel (i686).

Because of the lack of "EXPORT_SYMBOL" in the kernel, I had to=20
copy-paste several functions from the kernel into the=20
nativi_kernel_code.c file in order to use some features already=20
available in the kernel (ip_finish_output, ip6_output, icmp_send).

Documentation is provided in the source code, if you have any question=20
don't hesitate to ask me.

Regards,

Pierre RONDOU
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
