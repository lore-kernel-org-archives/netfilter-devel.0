From: "Filka Michal" <Michal.Filka@sitronicsts.com>
Subject: nf_conntrack_alter_reply issue
Date: Wed, 29 Oct 2008 12:42:39 +0100
Message-ID: <BEC9960F39A76F42A01F47B8D8259DAA1C0569@exdoub2.stromtelecom.cz>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.strom.cz ([80.95.102.231]:11125 "EHLO mail.strom.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632AbYJ2Lzz convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Oct 2008 07:55:55 -0400
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I would like to ask for an explanation. 

I have a firewall with several nat rules (up to 700). When I run some
traffic over it, I get this: NF_CT_ASSERT:
net/netfilter/nf_conntrack_core.c:891(nf_conntrack_alter_reply).

For some reason historical kernel 2.6.20.8 is used.

I looked in source but I haven't much idea where a problem is.

Thank for your help


Michal Filka
