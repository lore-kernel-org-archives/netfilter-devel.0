From: Luis Henriques <luis.henriques@canonical.com>
Subject: Re: [PATCH -stable-3.9 01/15] netfilter: xt_TCPOPTSTRIP: fix possible mangling beyond packet boundary
Date: Fri, 05 Jul 2013 09:36:55 +0100
Message-ID: <87k3l5qu6w.fsf@canonical.com>
References: <1372776665-6795-1-git-send-email-pablo@netfilter.org>
	<87ehbe5q1h.fsf@canonical.com> <20130705050152.GA3925@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	stable@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:55567 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083Ab3GEIg6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jul 2013 04:36:58 -0400
In-Reply-To: <20130705050152.GA3925@localhost> (Pablo Neira Ayuso's message of
	"Fri, 5 Jul 2013 07:01:52 +0200")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> On Thu, Jul 04, 2013 at 03:59:54PM +0100, Luis Henriques wrote:
>> Hi Pablo,
>> 
>> Apparently, most of these patches are also applicable to older kernel
>> trees.  I did a quick check and the following seem to be applicable to
>> the 3.5 kernel:
>> 
>> bc6bcb5 netfilter: xt_TCPOPTSTRIP: fix possible mangling beyond packet boundary
>> 4f36ea6 netfilter: ipt_ULOG: fix non-null terminated string in the nf_log path
>> 2a7851b netfilter: add nf_ipv6_ops hook to fix xt_addrtype with IPv6
>> d660164 netfilter: xt_LOG: fix mark logging for IPv6 packets
>> a8241c6 ipvs: info leak in __ip_vs_get_dest_entries()
>> 37bc4f8 netfilter: nfnetlink_cttimeout: fix incomplete dumping of objects
>> 991a6b7 netfilter: nfnetlink_acct: fix incomplete dumping of objects
>> 409b545 netfilter: xt_TCPMSS: Fix violation of RFC879 in absence of MSS option
>> ed82c43 netfilter: xt_TCPOPTSTRIP: don't use tcp_hdr()
>> b396966 netfilter: xt_TCPMSS: Fix missing fragmentation handling
>> 70d19f8 netfilter: xt_TCPMSS: Fix IPv6 default MSS too
>> 06f3d7f ipvs: SCTP ports should be writable in ICMP packets
>> 
>> Only these 3 were left out:
>> 
>> dc7b3eb ipvs: Fix reuse connection if real server is dead
>> 5aed938 netfilter: nf_nat_sip: fix mangling
>> 797a7d6 netfilter: ctnetlink: send event when conntrack label was modified
>> 
>> Do you have any reason for including them on 3.9 kernel only, or
>> should they be queued for older kernels as well?
>
> Those can be queued for old kernels as well.

Great, thanks for clarifying.  I'll queue the above list for the 3.5
kernel.

Cheers,
-- 
Luis
