From: Josue Alvarez <jalvarez@toulouse.viveris.com>
Subject: nfacct: setting quotas does not seem to work.
Date: Thu, 11 Aug 2016 16:00:37 +0200
Message-ID: <59114b3a-5fff-4099-e2f7-d749be4e1511@toulouse.viveris.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.toulouse.viveris.com ([212.99.125.10]:53613 "EHLO
	mailS.toulouse.viveris.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752111AbcHKOAl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Aug 2016 10:00:41 -0400
Received: from [172.20.0.155] (unknown [172.20.0.155])
	by mailS.toulouse.viveris.com (Postfix) with ESMTPSA id 9E5ABCC0085
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Aug 2016 16:00:38 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I tried to play a little bit with the quota features of the extended 
accounting infrastructure.
However, it seemed that the quotas were not registered when creating the 
accounting objects.

Example :
# nfacct add testquota packet 5
# iptables -I OUTPUT -p icmp -m nfacct --nfacct-name testquota
# nfacct get testquota
{ pkts = 00000000000000000000, bytes = 00000000000000000000 } = testquota;

When I ping the machine, I see the counters go above 5 packets, however 
I get no output when running :
# nfacct monitor

After a little bit of investigation in the code of nfacct, I checked 
that the NFACCT_ATTR_FLAGS and NFACCT_ATTR_QUOTA attributes were set. (i 
managed to call _nfacct_cmd_add with flags=NFACCT_F_QUOTA_PKTS).

However, the kernel code in netfilter/net/nfnetlink_acct.c somehow did 
not "get" the flags : the execution didn't enter in the  "if 
(tb[NFACCT_FLAGS]) { ... }" in nfnl_acct_new(). (checked that using printk).

Any idea how this could happen ?

Thanks :)
