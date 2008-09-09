From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [NETFILTER]: Make Ebtables use Xtables infrastructure
Date: Tue, 9 Sep 2008 09:16:36 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809090906300.30845@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0809061209150.14936@fbirervta.pbzchgretzou.qr> <48C615DF.4090009@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Bart De Schuymer <bdschuym@pandora.be>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51350 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbYIINQi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Sep 2008 09:16:38 -0400
In-Reply-To: <48C615DF.4090009@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-09-09 02:21, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> commit bf161deb157ce95ac28b534a86fc1b18fe4d9aa4
>> Author: Jan Engelhardt <jengelh@medozas.de>
>> Date:   Sun Aug 10 22:16:14 2008 -0400
>> 
>> [NETFILTER]: Make Ebtables use Xtables infrastructure
>> ...
>> 22 files changed, 620 insertions(+), 593 deletions(-)
>
> Nice work, thanks. The patch is really huge though and I would
> prefer a slightly more gradual conversion, like first adjust
> the return conventions (and only those), than convert to x_tables.

The change of function signature must come in lockstep with moving
to Xtables. I can't just change it in Ebtables because that would
surely break semantics, even if it's just a commit.

>> @@ -325,7 +325,8 @@ int xt_check_match(const struct xt_match *match, unsigned
>> short family,
>>       unsigned int size, const char *table, unsigned int hook_mask,
>>       unsigned short proto, int inv_proto)
>> {
>> -	if (XT_ALIGN(match->matchsize) != size) {
>> +	/* testing for -1 is temporary until ebtables is fixed up */
>> +	if (match->matchsize != -1 && XT_ALIGN(match->matchsize) != size) {
>
> What exactly is the problem here (and when will ebtables be fixed up)?
>
Well first of all, just for reminder, Ebtables mimics the pre-2.6.18
Netfilter API. That is when there was no ->matchsize and no
->targetsize inside (what is now) xt_match/xt_target. As such,
extensions were left to do their own checking, leaving room for
(ab)use of a dynamic targetsize.

The "offending" extension is ebt_among. Using a dynamic size is ok if
it is done right (and it seems to be done right), but the centralized
error checking introduced in commit 1d5cd909 left no way for
userspace to send anything but one size.

The best way I can come up for ebt_among is to rewrite ebt_among in a
new revision so that it uses a fixed size and indirect pointer
grabbing, in other words, something like xt_geoip uses currently
( http://tinyurl.com/6hpfke , function geoip_add_node()), where the
kernel-side module uses extra copy_from_user() calls to read in
additional data that could not have been passed over the
struct xt_match xt_geoip_match.

I hope this does not delay this patch..
