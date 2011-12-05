From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: Rule counter update bug in ebtables-v2.0.10-2
Date: Mon, 05 Dec 2011 20:34:04 +0000
Message-ID: <4EDD2ABC.6090205@pandora.be>
References: <6E506E1B-00FB-4900-8EE3-9C72F26B8CD0@linode.com> <4EDB3F3A.1000903@pandora.be> <741FF1D1-F173-4A08-A471-09A9BDFE5AB7@linode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: James Sinclair <james.sinclair@linode.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from brigitte.telenet-ops.be ([195.130.137.66]:44666 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121Ab1LEUeK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Dec 2011 15:34:10 -0500
In-Reply-To: <741FF1D1-F173-4A08-A471-09A9BDFE5AB7@linode.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05-12-11 15:38, James Sinclair wrote:
> On Dec 4, 2011, at 4:36 AM, Bart De Schuymer wrote:
> 
>> On 29-11-11 21:08, James Sinclair wrote:
>>> I was doing some testing with the latest ebtables and I think I've found a bug in ebt_deliver_counters that was introduced in the following commit:
>>>
>>> http://ebtables.cvs.sourceforge.net/viewvc/ebtables/ebtables2/userspace/ebtables2/communication.c?r1=1.40&r2=1.41
>>>
>>> It seems that the chainnr++ on line 308 is only reached when entries is NULL, causing the code to repeatedly loop over the rules for the first non-empty chain. This manifests as every chain having its counters copied from the first non-empty chain instead of getting the counters assigned with -c:
>>
>> Thanks for the bug report. I've applied the following fix instead.
>>
>> --- ebtables-v2.0.10-2/communication.c	2011-08-11 19:56:16.000000000 +0100
>> +++ ebtables-v2.0.10-3/communication.c	2011-12-04 09:29:23.000000000 +0000
>> @@ -309,6 +309,7 @@ void ebt_deliver_counters(struct ebt_u_r
>> 	new = newcounters;
>> 	while (cc != u_repl->cc) {
>> 		if (!next || next == entries->entries) {
>> +			chainnr++;
>> 			while (chainnr<  u_repl->num_chains&&  (!(entries = u_repl->chains[chainnr]) ||
>> 			       (next = entries->entries->next) == entries->entries))
>> 				chainnr++;
>>
>> cheers,
>> Bart
>>
>>
>>
>> -- 
>> Bart De Schuymer
>> www.artinalgorithms.be
> 
> 
> Thanks for taking the time to look at my patch, Bart.
> 
> It looks like the fix you applied introduces a new bug. It works in most cases, but when a rules is set in the first built-in chain (such as PREROUTING in the nat table) all counters get reset to zero.

Thanks for verifying this.

Please try the incremental patch below (patch -p1 < file). I'll wait for your verification this time before making another release :)

--- ebtables-v2.0.10-3/communication.c	2011-12-04 09:46:26.000000000 +0000
+++ ebtables-v2.0.10-4/communication.c	2011-12-05 20:29:17.864018957 +0000
@@ -295,7 +295,7 @@ void ebt_deliver_counters(struct ebt_u_r
 	struct ebt_cntchanges *cc = u_repl->cc->next, *cc2;
 	struct ebt_u_entries *entries = NULL;
 	struct ebt_u_entry *next = NULL;
-	int i, chainnr = 0;
+	int i, chainnr = -1;
 
 	if (u_repl->nentries == 0)
 		return;


Best regards,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be
