From: manuprivat@gmx.de
Subject: mangle table shows error with MARK target
Date: Tue, 28 Apr 2009 09:16:11 +0200
Message-ID: <20090428071611.47750@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53158 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751450AbZD1HQP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Apr 2009 03:16:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi netfilter-list,

if I use command:

#iptables -nvL -t mangle

I get:

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
pkts bytes target     prot opt in     out     source               dest=
ination
insmod: ip_tables.ko: no module by that name found
modprobe: failed to load module ip_tables
insmod: ip_tables.ko: no module by that name found
modprobe: failed to load module ip_tables
insmod: ip_tables.ko: no module by that name found
modprobe: failed to load module ip_tables
insmod: ip_tables.ko: no module by that name found
modprobe: failed to load module ip_tables
   0     0 MARK       all  --  *      *       10.0.20.2            0.0.=
0.0/0           MARK set 0x14


Everything works fine, but I get this error message?
My kernel is built with every point of iptables stuff included, not as =
module.
This error occurs only if I did an entry with MARK target, and it depen=
ds on iptables-version.
with iptables v.1.2.9 there is no error displayed.


iptables: v1.4.3.2
kernel: 2.6.23.9

Hope somebody knows how to eliminate the error.

Regards,
Manu=20
--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger01
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
