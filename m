From: Kamal Kumar <malkarikamalkumar@gmail.com>
Subject: Sub: NAT issue in netfilter
Date: Thu, 26 Jun 2014 15:14:51 +0530
Message-ID: <CAJQ3KZXNSCgV0mRx6jDwWk85sJRFY5pKKFJbLuzaEmW1kzFAfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ve0-f180.google.com ([209.85.128.180]:35475 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979AbaFZJow (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:44:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear Hambourg,

My response to your previous mail,

> Below is my exact scenario -> Network 1 wants to communicate with Network 2 using NAT enabled router with two ethernet interfaces eth0(192.168.1.1) and eth1 (192.168.2.1).

|    Network 1    |---| NAT Router |---|     Network 2   |
(192.168.1.0/24)   ^                  ^     (192.168.2.0/24)
                             |                  |
             eth0(192.168.1.1)   eth1(192.168.2.1)

> What I did is as mentioned below.

>Step1: I am applying the following command "iptables -t nat -A POSTROUTING -s 0.0.0.0/0 -d 0.0.0.0/0 -o eth1 -j SNAT --to 192.168.2.1" in nat router.

>Step2: Started initiating traffic(ICMP) from network 1 to network 2 and using wireshark I observed source ip of traffic from network 1 being translated to ip 192.168.2.1 in nat router.

>Step3: With traffic from network 1 to network 2 in PROGRESS I am flushing the nat table using the command "iptables -t nat -F".

> Now as there is no rule the sourece ip of traffic from network 1 should not be translated to ip 192.168.2.1 (which is my requirement), but it is being translated.

> What should I do to fullfill my requirement.
