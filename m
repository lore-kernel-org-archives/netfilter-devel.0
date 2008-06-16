From: Patrick McHardy <kaber@trash.net>
Subject: Re: Support NAT-ed expect entries from user space
Date: Mon, 16 Jun 2008 22:52:28 +0200
Message-ID: <4856D28C.3030302@trash.net>
References: <20080616092148.GB2860@phoenix.home> <4856C8C6.3070309@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: BORBELY Zoltan <bozo@andrews.hu>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42862 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbYFPUwe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2008 16:52:34 -0400
In-Reply-To: <4856C8C6.3070309@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> BORBELY Zoltan wrote:
>> Hi,
>>
>> I'm developing a transparent user space ftp proxy, and I'm using expect
>> entries to accept incoming data connections.

Sounds reasonable.

>> It works quite well, but I
>> had to patch the kernel to get it work. It's quite small, so I put it
>> inline:
> 
> Just a wild thought. What if you create a new conntrack (instead of an
> expectation) using a small timeout in state TCP SYN_SENT that represents
> the new flow that it is expected to arrive? The first packet would seen
> as a resent by the connection tracking so it would accept it. However,
> the TCP sequence tracking may complain about it. Nevertheles, we can
> also access to the internal TCP flags to enable   IP_CT_TCP_FLAG_BE_LIBERAL.

That sounds like a bit of a hack.

>> --- nf_conntrack_netlink-orig-2.6.22.9.c        2007-09-26 20:03:01.000000000 +0
>> +++ nf_conntrack_netlink-new-2.6.22.9.c 2008-06-13 17:14:17.000000000 +0200
>> @@ -39,6 +39,7 @@
>>  #ifdef CONFIG_NF_NAT_NEEDED
>>  #include <net/netfilter/nf_nat_core.h>
>>  #include <net/netfilter/nf_nat_protocol.h>
>> +#include <net/netfilter/nf_nat_helper.h>
>>  #endif
>>
>>  #include <linux/netfilter/nfnetlink.h>
>> @@ -1439,7 +1440,11 @@
>>                 goto out;
>>         }
>>
>> -       exp->expectfn = NULL;
>> +       exp->expectfn = nf_nat_follow_master;
>> +#ifdef CONFIG_NF_NAT_NEEDED
>> +       exp->saved_proto.tcp.port = tuple.dst.u.tcp.port;       //!!!FIXME
>> +       exp->dir = IP_CT_DIR_ORIGINAL;
>> +#endif
>>         exp->flags = 0;
>>         exp->master = ct;
>>         exp->helper = NULL;
>>
>> It's ugly as hell in the current form, but I have some ideas how to
>> improve it to integrate it into the main kernel tree. Maybe we can add a
>> new CTA_EXPECT_SAVED_PROTO attribute and get it from user space. What
>> is your opinion?
> 
> Would this change be generic enough for userspace transparent proxies or
> only for FTP?

I'm wondering, how is this expectation creation working at all?
The NULL expectfn makes me think it will crash as soon as the
expectation arrives. This *needs* support from the helpers to
properly set the expectfn.

And more specific to this problem: back when Harald was working
on userspace helpers, the idea was to add a dummy helper specifically
so we have one to assign to the connection. The helper would (IIRC)
just queue the expected packets and userspace could take it from
there. Of course queuing could be made optional and (f.i.) it could
just use nf_nat_follow_master.

And related to this patch: the direction needs to be provided
by userspace to be generically useful. The saved_port (and saved_ip
possibly) could either be provided by userspace or selected
based on a couple of flags.
