From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/7] netfilter: xtables2: initial Netlink interface
Date: Tue, 14 Feb 2012 16:56:01 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1202141638480.31395@frira.zrqbmnf.qr>
References: <1326990381-14534-1-git-send-email-jengelh@medozas.de> <1326990381-14534-3-git-send-email-jengelh@medozas.de> <20120214104716.GA26628@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:51456 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002Ab2BNP4D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Feb 2012 10:56:03 -0500
In-Reply-To: <20120214104716.GA26628@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2012-02-14 11:47, Pablo Neira Ayuso wrote:
>>  include/linux/netfilter/nfnetlink_xtables.h |   20 ++++
>>  net/netfilter/Kconfig                       |    8 ++
>>  net/netfilter/Makefile                      |    1 +
>>  net/netfilter/xt2_nfnetlink.c               |  153 +++++++++++++++++++++++++++
>
>I prefer if you call this nfnetlink_xtables.c following the same
>naming convention.

(I dropped the '2' meanwhile) Hm I chose so as I planned to have
at least another file, xt_compat.c. In that regard, it's more like
what ipset/ has (also not nfnetlink_ipset). Should I pick a
different header name then?

>> +enum nfxt_msg_type {
>> +	NFXTM_IDENTIFY = 1,
>
>I'd suggest: NFXT_MSG_NEW, NFXT_MSG_GET,...and so on.

The identifiers are already long enough IMO. Hence the choice
to use NFXTM_ (msg), NFXTA_ (attr) and NFXTE_ (error codes).

>> +static struct nlmsghdr *
>> +xtnetlink_fill(struct sk_buff *skb, const struct xtnetlink_pktref *old,
>> +	       unsigned int flags)
>> +{ [...]
>> +	if (nlmsg == NULL) {
>> +		nlmsg_cancel(skb, nlmsg);
>> +		return ERR_PTR(-ENOBUFS);
>
>my experience is that it's better to use goto to handle errors.

There is just one error case here in this function,
so goto was nowhere to be desired :)

>> +static int
>> +xtnetlink_identify(struct sock *xtnl, struct sk_buff *iskb,
>> +		   const struct nlmsghdr *imsg, const struct nlattr *const *ad)
>> +{
>> +	return netlink_dump_start(xtnl, iskb, imsg, xtnetlink_identify2,
>> +				  NULL, 0);
>
>you have to check for NLM_F_DUMP. Otherwise, you are requesting one
>single table. Please, see ctnetlink or nfnetlink_acct for reference.

identify returns auxiliary information about the implementation.
For tables there is(will be) NFXTM_TABLE_DUMP.
