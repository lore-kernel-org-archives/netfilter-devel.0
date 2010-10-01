From: Anand Raj Manickam <anandrm@gmail.com>
Subject: IS Mapping ipset to iptable chains possible
Date: Fri, 1 Oct 2010 12:32:22 +0530
Message-ID: <AANLkTin81gLzh3iHbONkeAckWxc++WZtmuHXeFuMN6VT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37522 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab0JAHCl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:02:41 -0400
Received: by qyk36 with SMTP id 36so2858369qyk.19
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Oct 2010 00:02:37 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I m just learning to use ipsets .
I have a basic doubt

Suppose i create a ipset

ipset -N test ipmap --network 192.168.0.0/16

add a few ips
#ipset -A test 192.168.0.1
..
#ipset -A test 192.168.0.100

if i want to have 1 chain per ip

192.168.0.1 to CHAIN1
..
192.168.0.100 to CHAIN100


iptables -A FORWARD --set --match-set test src,dst -j DROP is perfect

--SET helps in add /del sets

is there a possiblity or am i not understanding it
Any pointers wud be helpful.

Thanks,
Anand
