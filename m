From: Kuzin Andrey <kuzinandrey@yandex.ru>
Subject: dmesg analyse
Date: Sun, 14 Feb 2010 20:54:39 +0300
Message-ID: <533455460.20100214205439@yandex.ru>
Reply-To: Kuzin Andrey <kuzinandrey@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward7.mail.yandex.net ([77.88.61.37]:51783 "EHLO
	forward7.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab0BNR5L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Feb 2010 12:57:11 -0500
Received: from smtp7.mail.yandex.net (smtp7.mail.yandex.net [77.88.61.55])
	by forward7.mail.yandex.net (Yandex) with ESMTP id 35B13310DFD
	for <netfilter-devel@vger.kernel.org>; Sun, 14 Feb 2010 20:50:45 +0300 (MSK)
Received: from dron (unknown [212.45.5.114])
	by smtp7.mail.yandex.net (Yandex) with ESMTPA id 1DB971CF8178
	for <netfilter-devel@vger.kernel.org>; Sun, 14 Feb 2010 20:50:45 +0300 (MSK)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello list !
Here is part of my dmesg log...

[770625.350197] bsalg: parser failed
[770625.350202] nf_ct_snmp: dropping packetIN= OUT=eth1 SRC=212.45.5.114 DST=83.99.195.159 LEN=95 TOS=0x00 PREC=0x00 TTL=127 ID=35401 PROTO=UDP SPT=8065 DPT=161 LEN=75 MARK=0x114
[770666.464746] UDP: bad checksum. From 89.85.97.98:42656 to 212.45.5.114:63925 ulen 285
[770701.508607] UDP: bad checksum. From 150.101.211.131:28465 to 212.45.5.114:8069 ulen 111
[770839.036065] UDP: bad checksum. From 91.193.68.134:64594 to 212.45.5.114:35955 ulen 331
[770846.520705] xt_TCPMSS: bad length (1500 bytes)
[770847.333322] bsalg: parser failed
[770847.333326] nf_ct_snmp: dropping packetIN= OUT=eth1 SRC=212.45.5.114 DST=83.99.195.159 LEN=95 TOS=0x00 PREC=0x00 TTL=127 ID=26026 PROTO=UDP SPT=8106 DPT=161 LEN=75 MARK=0x114
[770880.708220] UDP: bad checksum. From 91.193.68.134:64594 to 212.45.5.114:35955 ulen 331
[770929.042927] UDP: bad checksum. From 95.84.232.203:63126 to 212.45.5.114:26128 ulen 331
[770934.980900] UDP: bad checksum. From 95.84.232.203:63126 to 212.45.5.114:26128 ulen 331
[770953.541793] UDP: bad checksum. From 95.84.232.203:63126 to 212.45.5.114:26128 ulen 331
[770967.215508] UDP: bad checksum. From 95.84.232.203:63126 to 212.45.5.114:26128 ulen 331
[771099.549203] UDP: bad checksum. From 91.193.68.134:64594 to 212.45.5.114:35955 ulen 331
[771112.616361] bsalg: parser failed
[771112.616366] nf_ct_snmp: dropping packetIN= OUT=eth1 SRC=212.45.5.114 DST=83.99.195.159 LEN=95 TOS=0x00 PREC=0x00 TTL=126 ID=77 PROTO=UDP SPT=31613 DPT=161 LEN=75 MARK=0xfd
[771145.538934] xt_TCPMSS: bad length (1496 bytes)
[771145.538939] xt_TCPMSS: bad length (40 bytes)

First.
Here peer with ip 83.99.195.159 i think is torrent or any other p2p
application masking as snmp managed device (may be for cheat the
firewall), and nf_ct_snmp module (compiled in kernel) dropping wrong
packets and work as wrong configured firewall. I think udp/161 can
be used by any program for any other purposes, not only for snmp.
I'm right ?

Second.
Messages of xt_TCPMSS module not contain any important information,
any only garbage the dmesg. May be delete this ? Or add something
more useful info.

Third.
I think UDP protocol is very noisy with "bad checksum" and "short
packet" messages. This messages really needed ?

