From: Pietro Paolini <pulsarpietro@aol.com>
Subject: recent module
Date: Mon, 3 Nov 2014 05:42:04 -0500
Message-ID: <8D1C569F1803AFD-7C0-3D4A0@webmail-vm135.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 8BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from omr-m08.mx.aol.com ([64.12.222.129]:60512 "EHLO
	omr-m08.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaKCKrL convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:47:11 -0500
Received: from mtaomg-mad01.mx.aol.com (mtaomg-mad01.mx.aol.com [172.26.221.207])
	by omr-m08.mx.aol.com (Outbound Mail Relay) with ESMTP id 226CE7032BEA2
	for <netfilter-devel@vger.kernel.org>; Mon,  3 Nov 2014 05:42:05 -0500 (EST)
Received: from core-aca09b.mail.aol.com (core-aca09.mail.aol.com [172.27.9.9])
	by mtaomg-mad01.mx.aol.com (OMAG/Core Interface) with ESMTP id D28C238000081
	for <netfilter-devel@vger.kernel.org>; Mon,  3 Nov 2014 05:42:04 -0500 (EST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>





Hi all,



I am trying to use the recent module to stop the slate of attacks I get

everyday, but I am not sure my understanding of its logic it is correct.



-A INPUT -i eth0 -p tcp -m tcp --dport 22 -m state --state NEW -m

recent --update --seconds 1800 --hitcount 5 --name ssh-defensive

--rsource -j DROP

-A INPUT -i eth0 -p tcp -m tcp --dport 22 -m state --state NEW -m

recent --set --name ssh-defensive --rsource



I am testing this solution - which works as intended - but the packet

counters do not make  sense to me, during my test

I start the ssh client, I get the prompt asking for the password and I

immediately check the iptables counters:



Chain INPUT (policy ACCEPT 81 packets, 8996 bytes)

  pkts bytes target     prot opt in     out     source

destination

     1    52 LOG        tcp  --  *      *       0.0.0.0/0

0.0.0.0/0            state NEW tcp dpt:22 LOG flags 0 level 4

     0     0 DROP       tcp  --  eth0   *       0.0.0.0/0

0.0.0.0/0            tcp dpt:22 state NEW recent: UPDATE seconds: 1800

hit_count: 5 name: ssh-defensive side: source

     1    52            tcp  --  eth0   *       0.0.0.0/0

0.0.0.0/0            tcp dpt:22 state NEW recent: SET name:

ssh-defensive side: source





I expected to see more packets, what about the TCP handshake ?



Thanks in advance,

Pietro
