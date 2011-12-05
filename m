From: James Sinclair <james.sinclair@linode.com>
Subject: Re: Rule counter update bug in ebtables-v2.0.10-2
Date: Mon, 5 Dec 2011 10:38:16 -0500
Message-ID: <741FF1D1-F173-4A08-A471-09A9BDFE5AB7@linode.com>
References: <6E506E1B-00FB-4900-8EE3-9C72F26B8CD0@linode.com> <4EDB3F3A.1000903@pandora.be>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.linode.com ([67.18.92.99]:50577 "EHLO www.linode.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932399Ab1LEPis convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Dec 2011 10:38:48 -0500
In-Reply-To: <4EDB3F3A.1000903@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Dec 4, 2011, at 4:36 AM, Bart De Schuymer wrote:

> On 29-11-11 21:08, James Sinclair wrote:
>> I was doing some testing with the latest ebtables and I think I've found a bug in ebt_deliver_counters that was introduced in the following commit:
>> 
>> http://ebtables.cvs.sourceforge.net/viewvc/ebtables/ebtables2/userspace/ebtables2/communication.c?r1=1.40&r2=1.41
>> 
>> It seems that the chainnr++ on line 308 is only reached when entries is NULL, causing the code to repeatedly loop over the rules for the first non-empty chain. This manifests as every chain having its counters copied from the first non-empty chain instead of getting the counters assigned with -c:
> 
> Thanks for the bug report. I've applied the following fix instead.
> 
> --- ebtables-v2.0.10-2/communication.c	2011-08-11 19:56:16.000000000 +0100
> +++ ebtables-v2.0.10-3/communication.c	2011-12-04 09:29:23.000000000 +0000
> @@ -309,6 +309,7 @@ void ebt_deliver_counters(struct ebt_u_r
> 	new = newcounters;
> 	while (cc != u_repl->cc) {
> 		if (!next || next == entries->entries) {
> +			chainnr++;
> 			while (chainnr < u_repl->num_chains && (!(entries = u_repl->chains[chainnr]) ||
> 			       (next = entries->entries->next) == entries->entries))
> 				chainnr++;
> 
> cheers,
> Bart
> 
> 
> 
> -- 
> Bart De Schuymer
> www.artinalgorithms.be


Thanks for taking the time to look at my patch, Bart.

It looks like the fix you applied introduces a new bug. It works in most cases, but when a rules is set in the first built-in chain (such as PREROUTING in the nat table) all counters get reset to zero.

ebtables -t nat -A PREROUTING -s 0:0:0:0:0:1 -j ACCEPT -c 10 10
ebtables -t nat -N CHAIN1
ebtables -t nat -A CHAIN1 -s 0:0:0:0:1:1 -j ACCEPT -c 101 101
ebtables -t nat -A CHAIN1 -s 0:0:0:0:1:2 -j ACCEPT -c 102 102
ebtables -t nat -N CHAIN2
ebtables -t nat -A CHAIN2 -s 0:0:0:0:2:1 -j ACCEPT -c 201 201
ebtables -t nat -A CHAIN2 -s 0:0:0:0:2:2 -j ACCEPT -c 202 202
ebtables -t nat -N CHAIN3
ebtables -t nat -A CHAIN3 -s 0:0:0:0:3:1 -j ACCEPT -c 302 302
ebtables -t nat -A CHAIN3 -s 0:0:0:0:3:2 -j ACCEPT -c 303 303
ebtables -t nat -L --Lc

    Bridge table: nat

    Bridge chain: PREROUTING, entries: 1, policy: ACCEPT
    -s 0:0:0:0:0:1 -j ACCEPT , pcnt = 0 -- bcnt = 0

    Bridge chain: OUTPUT, entries: 0, policy: ACCEPT

    Bridge chain: POSTROUTING, entries: 0, policy: ACCEPT

    Bridge chain: CHAIN1, entries: 2, policy: ACCEPT
    -s 0:0:0:0:1:1 -j ACCEPT , pcnt = 0 -- bcnt = 0
    -s 0:0:0:0:1:2 -j ACCEPT , pcnt = 0 -- bcnt = 0

    Bridge chain: CHAIN2, entries: 2, policy: ACCEPT
    -s 0:0:0:0:2:1 -j ACCEPT , pcnt = 0 -- bcnt = 0
    -s 0:0:0:0:2:2 -j ACCEPT , pcnt = 0 -- bcnt = 0

    Bridge chain: CHAIN3, entries: 2, policy: ACCEPT
    -s 0:0:0:0:3:1 -j ACCEPT , pcnt = 0 -- bcnt = 0
    -s 0:0:0:0:3:2 -j ACCEPT , pcnt = 0 -- bcnt = 0

James Sinclair
Linode, LLC

