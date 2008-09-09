From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: Make Ebtables use Xtables infrastructure
Date: Tue, 09 Sep 2008 15:29:13 +0200
Message-ID: <48C67A29.1030802@trash.net>
References: <alpine.LNX.1.10.0809061209150.14936@fbirervta.pbzchgretzou.qr> <48C615DF.4090009@trash.net> <alpine.LNX.1.10.0809090906300.30845@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Bart De Schuymer <bdschuym@pandora.be>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40603 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbYIIN3R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Sep 2008 09:29:17 -0400
In-Reply-To: <alpine.LNX.1.10.0809090906300.30845@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2008-09-09 02:21, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> commit bf161deb157ce95ac28b534a86fc1b18fe4d9aa4
>>> Author: Jan Engelhardt <jengelh@medozas.de>
>>> Date:   Sun Aug 10 22:16:14 2008 -0400
>>>
>>> [NETFILTER]: Make Ebtables use Xtables infrastructure
>>> ...
>>> 22 files changed, 620 insertions(+), 593 deletions(-)
>> Nice work, thanks. The patch is really huge though and I would
>> prefer a slightly more gradual conversion, like first adjust
>> the return conventions (and only those), than convert to x_tables.
> 
> The change of function signature must come in lockstep with moving
> to Xtables. I can't just change it in Ebtables because that would
> surely break semantics, even if it's just a commit.


Thats just not true. The bulk of your patch is made up of renames,
changing -EINVAL to -1 and similar changes. All these changes can
easily be done while keeping ebtables (f.i. add a revision field
to ebt_match thats unused, change return convention for ->check
and do the right think in ebtables, ...), and then switch it all
over. However you do it, please separate functional changes from
the noise.

>>> @@ -325,7 +325,8 @@ int xt_check_match(const struct xt_match *match, unsigned
>>> short family,
>>>       unsigned int size, const char *table, unsigned int hook_mask,
>>>       unsigned short proto, int inv_proto)
>>> {
>>> -	if (XT_ALIGN(match->matchsize) != size) {
>>> +	/* testing for -1 is temporary until ebtables is fixed up */
>>> +	if (match->matchsize != -1 && XT_ALIGN(match->matchsize) != size) {
>> What exactly is the problem here (and when will ebtables be fixed up)?
>>
> Well first of all, just for reminder, Ebtables mimics the pre-2.6.18
> Netfilter API. That is when there was no ->matchsize and no
> ->targetsize inside (what is now) xt_match/xt_target. As such,
> extensions were left to do their own checking, leaving room for
> (ab)use of a dynamic targetsize.
> 
> The "offending" extension is ebt_among. Using a dynamic size is ok if
> it is done right (and it seems to be done right), but the centralized
> error checking introduced in commit 1d5cd909 left no way for
> userspace to send anything but one size.

I remeber now. That seems fine to me, please just extend the comment
to say ebt_among, since thats whats actually requiring this change.
