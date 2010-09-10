From: Fabricio Archanjo <farchanjo@gmail.com>
Subject: LVS with REDIRECT
Date: Fri, 10 Sep 2010 19:12:20 -0300
Message-ID: <AANLkTikbs-R1HN4=7AaWSvom2P0Lt8h+aGS5qS6KTRde@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39245 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab0IJWMV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Sep 2010 18:12:21 -0400
Received: by wwb13 with SMTP id 13so406943wwb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Sep 2010 15:12:20 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I've made a labs to test a load balance conection to Squid. I have two
machines with Squid, which are balanced with LVS on Firewall. Look at
my ipvsadm -L -n output:

TCP  10.10.10.1:8080 rr
  -> 192.168.1.2:3128             Masq    1      0          0
  -> 192.168.1.3:3128             Masq    1      0          0

The IP 10.10.10.1 is my local network, where are my hosts. 192.168.1.2
and 192.168.1.3 are my Squids. When I set 10.10.10.1 directly on
browser the balance works perfect. But i need to use like transparent
proxy, then i did this rule:

iptables -t nat -A PREROUTING -i eth2 -p tcp -s 10.10.10.0/24 --dport
80 -j REDIRECT --to-port 8080

When i applied this rule, any traffic to http port match in this rule
but it is not redirect my traffic to 8080. may someone help me???

Thanks all,
