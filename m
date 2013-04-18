From: Jorge Ventura <jorge.araujo.ventura@gmail.com>
Subject: xt_CHECKSUM doesn't work as expected
Date: Thu, 18 Apr 2013 10:48:38 -0500
Message-ID: <CAJEG_Nc63CdikpWiuJrBrjZ08v8rY5c9PvFwqAKkynDyvfRqPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:56406 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967492Ab3DRPsj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:48:39 -0400
Received: by mail-lb0-f175.google.com with SMTP id o10so2801144lbi.6
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Apr 2013 08:48:38 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear nf devels,
I am trying to use the xt_CHECKSUM module to fix an UDP packet that
it's comming with check sum error. I have an iptables firewall with
two ethernet cards (eth0 private and eth1 public), all ethernet
offload parameters are off in both ethernet cards and
nf_conntrack_checksum = 0.

This is my iptables rule to fix the checksum:

iptables -A POSTROUTING -t mangle -p udp --dport 162 -j CHECKSUM --checksum-fill

The trafic resulting when the single UDP packet is received using tcpdump:

input at eth1 (public):  [src ip].1046 > [eth1 public ip].162: [bad
udp cksum ff!]
output at eth0 (private): [src ip].1046 > [eth0 private ip].162: [bad
udp cksum ff!]

I did use printk inside the module to see what do I have at
skb->ip_summed and I observed that the value is CHECKSUM_NONE, however
to have the checksum fixed by the function checksum_tg, this value
should be CHECKSUM_PARTIAL.

Please let me know if I am miss understanding the way that
--checksum-fill is handled by xt_CHECKSUM module.

Sincerely,
Ventura

-
