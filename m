From: Pete Kay <petedao@gmail.com>
Subject: using libiptc to append iptables rule but no effect
Date: Mon, 26 Jul 2010 12:05:16 +0800
Message-ID: <AANLkTim=SU3KrHWbQhEU9Y0hh7UazhX7SafJEcLikrL4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:45774 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab0GZEFR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Jul 2010 00:05:17 -0400
Received: by pxi14 with SMTP id 14so4397021pxi.19
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Jul 2010 21:05:16 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am able to use libiptc to append rules into iptables and I can
verify those rules from using the iptables command.

However, when I send traffic to the machine, it is not forwarding the
packets as I requested it to.  However, if I use iptables -A to add
the entry, it can work.  Can someone help me out?  What is the
difference between using libiptc to append rules and using iptables
-A?  I did use ipt_commit() at the end.

Here are the rules I am appending.  Any suggestion will be greatly appreciated.


iptc_first_rule: first rule(PREROUTING): 0x1e7aac0
WARNING: handle->chain_index_sz == 0
DNAT       udp  --  192.168.1.251        anywhere            udp
spt:61002 to:192.168.1.252:60998
iptc_next_rule: rule_iterator_cur=0x1e7aac0...next=0x1e7abe0,
head=0x1e7aa90...returning rule 0x1e7abe0
WARNING: handle->chain_index_sz == 0
DNAT       udp  --  192.168.1.252        anywhere            udp
spt:60998 to:192.168.1.251:61002
iptc_next_rule: rule_iterator_cur=0x1e7abe0...next=0x1e7ad00,
head=0x1e7aa90...returning rule 0x1e7ad00
WARNING: handle->chain_index_sz == 0
DNAT       udp  --  192.168.1.56         anywhere            udp
spt:16385 to:192.168.1.20:10004
iptc_next_rule: rule_iterator_cur=0x1e7ad00...next=0x1e7ae20,
head=0x1e7aa90...returning rule 0x1e7ae20
WARNING: handle->chain_index_sz == 0
DNAT       udp  --  192.168.1.20         anywhere            udp
spt:10004 to:192.168.1.56:16385
iptc_next_rule: rule_iterator_cur=0x1e7ae20...next=0x1e7aa90,
head=0x1e7aa90...finished, returning NULL
iptc_next_chain: : returning `POSTROUTING'

iptc_get_policy: called for chain POSTROUTING
Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination
iptc_first_rule: first rule(POSTROUTING): 0x1e7b0b0
WARNING: handle->chain_index_sz == 0
SNAT       udp  --  192.168.1.251        anywhere            udp
spt:61002 to:192.168.1.114:18352
iptc_next_rule: rule_iterator_cur=0x1e7b0b0...next=0x1e7b1d0,
head=0x1e7b080...returning rule 0x1e7b1d0
WARNING: handle->chain_index_sz == 0
SNAT       udp  --  192.168.1.252        anywhere            udp
spt:60998 to:192.168.1.114:18354
iptc_next_rule: rule_iterator_cur=0x1e7b1d0...next=0x1e7b2f0,
head=0x1e7b080...returning rule 0x1e7b2f0
WARNING: handle->chain_index_sz == 0
SNAT       udp  --  192.168.1.56         anywhere            udp
spt:16385 to:192.168.1.114:24608
iptc_next_rule: rule_iterator_cur=0x1e7b2f0...next=0x1e7b410,
head=0x1e7b080...returning rule 0x1e7b410
WARNING: handle->chain_index_sz == 0
SNAT       udp  --  192.168.1.20         anywhere            udp
spt:10004 to:192.168.1.114:24610
iptc_next_rule: rule_iterator_cur=0x1e7b410...next=0x1e7b080,
head=0x1e7b080...finished, returning NULL
iptc_next_chain: : returning `OUTPUT'
