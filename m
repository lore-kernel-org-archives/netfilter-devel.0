From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nfacct: setting quotas does not seem to work.
Date: Thu, 18 Aug 2016 00:44:57 +0200
Message-ID: <20160817224457.GA5647@salvia>
References: <59114b3a-5fff-4099-e2f7-d749be4e1511@toulouse.viveris.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Josue Alvarez <jalvarez@toulouse.viveris.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50684 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbcHQWpG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 18:45:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 89554E8E8A
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2016 00:45:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 794B21B3336
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2016 00:45:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5777C1B332B
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2016 00:45:02 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <59114b3a-5fff-4099-e2f7-d749be4e1511@toulouse.viveris.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 11, 2016 at 04:00:37PM +0200, Josue Alvarez wrote:
> Hi,
> 
> I tried to play a little bit with the quota features of the extended
> accounting infrastructure.
> However, it seemed that the quotas were not registered when creating the
> accounting objects.
> 
> Example :
> # nfacct add testquota packet 5
> # iptables -I OUTPUT -p icmp -m nfacct --nfacct-name testquota
> # nfacct get testquota
> { pkts = 00000000000000000000, bytes = 00000000000000000000 } = testquota;
> 
> When I ping the machine, I see the counters go above 5 packets, however I
> get no output when running :
> # nfacct monitor

I get this here:

{ pkts = 00000000000000000005, bytes = 00000000000000000420, quota =
00000000000000000005, mode = packet, overquota = yes } = testquota;

> After a little bit of investigation in the code of nfacct, I checked that
> the NFACCT_ATTR_FLAGS and NFACCT_ATTR_QUOTA attributes were set. (i managed
> to call _nfacct_cmd_add with flags=NFACCT_F_QUOTA_PKTS).
> 
> However, the kernel code in netfilter/net/nfnetlink_acct.c somehow did not
> "get" the flags : the execution didn't enter in the  "if (tb[NFACCT_FLAGS])
> { ... }" in nfnl_acct_new(). (checked that using printk).
> 
> Any idea how this could happen ?

Probably using an old kernel version with no quota support?
