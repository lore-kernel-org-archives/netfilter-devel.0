From: Hemant-vilas RAMDASI <hemant.ramdasi@stericsson.com>
Subject: dun using l3tp
Date: Mon, 28 May 2012 11:36:02 +0200
Message-ID: <81C3A93C17462B4BBD7E272753C10579232F445C7B@EXDCVYMBSTM005.EQ1STM.local>
References: <20120526182350.GB32109@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"netfilter@vger.kernel.org" <netfilter@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:37645 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790Ab2E1JgM convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 May 2012 05:36:12 -0400
In-Reply-To: <20120526182350.GB32109@1984>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am having difficulty in PPP connection between 2 machines and not able to figure out how to solve it. I have a windows machine connected to my phone running 3.0 kernel though dial-up connection. The PPP connection terminates on Phone.

When I run below commands on phone, it shows below output.

-----------
#ip rule show
0:      from all lookup local
32764:  from all iif rmnet0 lookup PS_DUN
32765:  from all iif ppp0 lookup PS_DUN
32766:  from all lookup main
32767:  from all lookup default
#
# ip route show
# ip route show table PS_DUN
default dev rmnet0  scope link
27.57.179.150 dev ppp0  scope link
#
# iptables -t nat -L
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination

Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination

# iptables -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
ACCEPT     all  --  anywhere             anywhere
           all  --  anywhere             anywhere             owner socket exists

Chain FORWARD (policy DROP)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
ACCEPT     all  --  anywhere             anywhere
           all  --  anywhere             anywhere             owner socket exists

Chain costly_shared (0 references)
target     prot opt source               destination
           all  --  anywhere             anywhere             owner socket exists
ACCEPT     all  --  anywhere             anywhere

#ip route show table PS_DUN
Default dev rmnet0 scope link
223.228.243.29 de ppp0 scope link
#ip rule show 

--------------
On a setup (running 2.6.35 kernel) I have same output for above commands. But here the packets are forwarded out of phone correctly.

Is there any kernel configuration I am missing in 3.0?

Can anyone help in this?

Thanks,
Hemant
