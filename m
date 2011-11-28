From: Fiedler Roman <Roman.Fiedler@ait.ac.at>
Subject: Iptables ruleset modified somehow when performing "iptables-save"
 followed by "iptables-restore"
Date: Mon, 28 Nov 2011 12:47:23 +0100
Message-ID: <9F69795E29C890408AC2DAF646C89BB379CBDCB231@MAILBOX.arc.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from arcss01.ait.ac.at ([62.218.164.126]:50237 "EHLO mail.ait.ac.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751518Ab1K1LxN convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Nov 2011 06:53:13 -0500
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello List,

I've observed failure in POSTROUTING in a way so strange, that I did not find any suitable keywords to search the web for solution. But I guess, that someone, who also observed that, will remember and perhaps could help me towards a solution.

Setup and how to reproduce:
===================

X--->---
          |--------- FW-----Net-Z
Y----<---

The firewall FW receives SYN from X for IP in Net-Z on eth0. Connection is DNATed to Y and forwarded via eth0. To avoid TCP-breakup by reply from Y->X, connection is also SNATed to IP of firewall, so Y receives SYN from FW-IP.

When building the iptables ruleset using various iptables [-t nat] -A ... commands, the setup works. Conntrack shows

# conntrack -L | grep YYYYYY.13
tcp      6 431995 ESTABLISHED src=XXXXX.129 dst=NET-Z.252 sport=38231 dport=8080 packets=2 bytes=112 src=YYYYYY.13 dst=FW-IP.250 sport=8080 dport=38231 packets=1 bytes=60 [ASSURED] mark=0 secmark=0 use=2

After

# iptables-save > iptables.x 
# iptables-restore < iptables.x

and sending SYN from X again conntrack is
# conntrack -L | grep YYYYYY.13
tcp      6 115 SYN_SENT src=XXXXXX.129 dst=NET-Z.252 sport=38234 dport=8080 packets=2 bytes=120 [UNREPLIED] src=YYYYYY.13 dst=XXXXXXXX.129 sport=8080 dport=38234 packets=0 bytes=0 mark=0 secmark=0 use=2

It seems that the POSTROUTING rule is not active, tcpdump really shows the SYN leaving the firewall with source-IP unmodified (still X).

Kernel version: 2.6.32-35-generic
Iptables version: iptables-save v1.4.4 on Mon Nov 28 11:36:06 2011


Questions:
=======

* Should a save-restore-sequence lead to the exact same iptables-setup before save or is the some other constraint to be met to guarantee save-restore to restore exactly what was saved? (There were no concurrent iptables table-modify activities on that machine during test except but active network traffic).
* Why does the order of iptables rules created influence outcome?
* Does this behavior correspond to a known bug?
* If really bug, what are the exact effects? Could this be a security problem when affecting filter instead of nat?

Thanks for your help,

DI Roman Fiedler
Safety & Security Department
Information Management & eHealth

AIT Austrian Institute of Technology GmbH
Reininghausstrae 13/1  |  8020 Graz  |  Austria
T +43(0) 316 586570-63  |  M +43(0) 664 8561599  |  F +43(0) 316 586570-12
roman.fiedler@ait.ac.at <mailto:roman.fiedler@ait.ac.at> | http://www.ait.ac.at <http://www.ait.ac.at/>
http://www.ait.ac.at/eHealth/ <http://www.ait.ac.at/eHealth/>

Kennen Sie die www.eHealth2011.at?

FN: 115980 i HG Wien  |  UID: ATU14703506
This email and any attachments thereto, is intended only for use by the addressee(s) named herein and may contain legally privileged and/or confidential information. If you are not the intended recipient, please notify the sender by return e-mail or by telephone and delete this message from your system and any printout thereof. Any unauthorized use, reproduction, or dissemination of this message is strictly prohibited. Please note that e-mails are susceptible to change. AIT Austrian Institute of Technology GmbH shall not be liable for the improper or incomplete transmission of the information contained in this communication, nor shall it be liable for any delay in its receipt.