From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: cant specify -m mark and -m connmark in same rule
Date: Fri, 22 Jul 2011 11:18:38 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1107221116020.16357@frira.zrqbmnf.qr>
References: <6F5DE7538AFCDA45A114F5E7510424A70295CBBC@hq-exchange01.bytemobile.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jeff Haran <jharan@bytemobile.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:39418 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab1GVJSl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Jul 2011 05:18:41 -0400
In-Reply-To: <6F5DE7538AFCDA45A114F5E7510424A70295CBBC@hq-exchange01.bytemobile.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-07-22 01:46, Jeff Haran wrote:

>Is this a bug?
>
> [root@cap-x2100m2-01 ~]# \
>> iptables -A FORWARD -i eth2.11 -o eth1.111 -p tcp -m mark --mark
>0x0/0xfff -m connmark --mark 0x0/0xfff -j NFQUEUE --queue-num 10
>iptables v1.4.7: mark: "--mark" option may only be specified once
>Try `iptables -h' or 'iptables --help' for more information.
>[root@cap-x2100m2-01 ~]#

Fixed since iptables 1.4.11.
