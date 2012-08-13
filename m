From: Stephen Clark <sclark46@earthlink.net>
Subject: nat not working as expected
Date: Mon, 13 Aug 2012 13:50:25 -0400
Message-ID: <50293E61.8080308@earthlink.net>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-spurfowl.atl.sa.earthlink.net ([209.86.89.66]:58994
	"EHLO elasmtp-spurfowl.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861Ab2HMRu1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Aug 2012 13:50:27 -0400
Received: from [69.22.83.100] (helo=joker.seclark.com)
	by elasmtp-spurfowl.atl.sa.earthlink.net with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.67)
	(envelope-from <sclark46@earthlink.net>)
	id 1T0ymY-0000iH-Ja
	for netfilter-devel@vger.kernel.org; Mon, 13 Aug 2012 13:50:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I have a problem I am trying to solve and nat doesn't seem to be 
working. I have a set of ip addresses I don't
want to go thru my transparent proxy so I have the following:

  Chain PREROUTING (policy ACCEPT 1413 packets, 206K bytes)
  pkts bytes target     prot opt in     out     source               
destination
     0     0 ACCEPT     tcp  --  eth0   *       10.254.150.0/24      
10.0.0.0/8          tcp dpt:80
...
     0     0 ACCEPT     tcp  --  eth0   *       10.254.150.0/24      
8.15.7.123          tcp dpt:80
     2   120 ACCEPT     tcp  --  eth0   *       10.254.150.0/24      
216.16.243.121      tcp dpt:80
     0     0 ACCEPT     tcp  --  eth0   *       10.254.150.0/24      
216.16.242.222      tcp dpt:80
  ...
     0     0 ACCEPT     tcp  --  eth0   *       10.254.150.0/24      
216.171.106.210     tcp dpt:80
     0     0 DNAT       tcp  --  eth0   *       10.254.150.0/24      
0.0.0.0/0           tcp dpt:80 to:10.254.150.1:8080

Chain POSTROUTING (policy ACCEPT 922 packets, 81534 bytes)
  pkts bytes target     prot opt in     out     source               
destination
     0     0 ACCEPT     all  --  *      eth1    10.254.150.0/24      
10.0.0.0/8
     0     0 ACCEPT     all  --  *      eth1    10.254.150.0/24      
172.16.0.0/12
     0     0 ACCEPT     all  --  *      eth1    10.254.150.0/24      
192.168.0.0/16
     0     0 SNAT       all  --  *      eth1    10.254.150.0/24      
0.0.0.0/0           to:xxx.xxx.149.209

My packet hits the pre-routing chain and is accepted but then seems to 
get lost, it doesn't get
natted and go out my external interface.

tcpdump on internal interface:
13:33:03.157163 IP 10.254.150.91.53169 > 216.16.243.121.http: Flags [S], 
seq 1127713574, win 5840, options [mss 1460,sackOK,TS val 2344806144 ecr 
0,nop,wscale 6], length 0

nothing shows on external interface:

The routing looks correct.
$ ip r g 216.16.243.121
216.16.243.121 via xxx.xxx.149.1 dev eth1  src xxx.xxx.149.209


What am I missing?

Thanks for your indulgence,
Steve



