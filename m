From: "Jeff Haran" <jharan@bytemobile.com>
Subject: cant specify -m mark and -m connmark in same rule
Date: Thu, 21 Jul 2011 16:46:00 -0700
Message-ID: <6F5DE7538AFCDA45A114F5E7510424A70295CBBC@hq-exchange01.bytemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ironport.bytemobile.com ([12.153.136.13]:47568 "EHLO
	ironport.bytemobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab1GUXqB convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Jul 2011 19:46:01 -0400
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Is this a bug?

 [root@cap-x2100m2-01 ~]# \
> iptables -A FORWARD -i eth2.11 -o eth1.111 -p tcp -m mark --mark
0x0/0xfff -m connmark --mark 0x0/0xfff -j NFQUEUE --queue-num 10
iptables v1.4.7: mark: "--mark" option may only be specified once
Try `iptables -h' or 'iptables --help' for more information.
[root@cap-x2100m2-01 ~]#

Seems that other combinations of match extension can be combined in the
same rule and if I specify the above with just -m mark or just -m
connmark, it takes it just fine.

Is the command line parser confusing the two different usages of --mark?

If this is a bug, has it been fixed in a later version than what I have?
This is from RHEL 6.0.

[root@cap-x2100m2-01 ~]# iptables --version
iptables v1.4.7
[root@cap-x2100m2-01 ~]#

Thanks,

Jeff Haran



