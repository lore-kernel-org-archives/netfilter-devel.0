From: Falk Nisius <f.nisius@mediadesign-fh.de>
Subject: Are pre- postrouting states device independent ?
Date: Mon, 02 May 2011 11:37:28 +0200
Message-ID: <4DBE7B58.6000800@mediadesign-fh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx01.qsc.de ([213.148.129.14]:53237 "EHLO mx01.qsc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757045Ab1EBJq2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 May 2011 05:46:28 -0400
Received: from Falk-Nisiuss-MacBook-Pro.local (91-66-230-116-dynip.superkabel.de [91.66.230.116])
	by mx01.qsc.de (Postfix) with ESMTPA id 269573C9FC
	for <netfilter-devel@vger.kernel.org>; Mon,  2 May 2011 11:37:29 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I have a box with some virtual machines.
One of them has a firewalling function without any natting,
like the following scheme.

+--------+
|        |192.168.11.42/30
| guest1 |------------------+
|        |       br11       |
+--------+                  |  192.168.11.41/30  +---------+
                            +--------------------|         |
                                                 | guest3  |
+--------+                  +--------------------| (fw)    |
|        |192.168.11.46/30  |  192.168.11.45/30  +---------+
| guest2 |------------------+                         | 192.168.10.2/30
|        |       br12                                 | hostnet
+--------+
=20
The traffic on the br11 and br12 is allowed.
There is an rule to SNAT guest1 to extern-IP-one
There is an rule to SNAT guest2 to extern-IP-two
There is an rule to SNAT guest3 to extern-IP-three

The natting for guest3 works fine.
The natting for guest1 and guest2 doesn't work. The packets goes to
the internet without any natting. They are not dropped.

It looks like the ACCEPT state on the br11/br12 are assumed for the
handling on the bridge hostnet. I can see the packets at the hostnet,
but no prerouting/postrouting like that for the traffic origined from g=
uest3
is done. The route 192.168.11.0/24 is set for the hostnet via 192.168.1=
0.2.

Perhaps someone can help.

Many thanks
=46alk



=20
--=20
=46alk Nisius
=46achbereichsleiter Informatik

-----------------------------------------------------------------------=
-
MEDIADESIGN HOCHSCHULE
f=FCr Design und Informatik - University of Applied Sciences
Lindenstra=DFe 20-25
10969 Berlin
TEL. +49 (0) 30 399 266-22
=46AX +49 (0) 30 399 266-15
f.nisius@mediadesign-fh.de | www.mediadesign.de
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
