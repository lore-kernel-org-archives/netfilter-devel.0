From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: Re: [PATCH 1/3 nfnetlink_acct] numerous changes and improvements
 to the kernel code
Date: Tue, 26 Mar 2013 20:24:22 +0000
Message-ID: <515203F6.10503@googlemail.com>
References: <514D9D45.6090804@googlemail.com> <20130323151213.GA4925@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:50264 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab3CZUYu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Mar 2013 16:24:50 -0400
Received: by mail-la0-f42.google.com with SMTP id fe20so14428546lab.1
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Mar 2013 13:24:48 -0700 (PDT)
In-Reply-To: <20130323151213.GA4925@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Pablo,


My apologies for this late reply...

>>  struct nf_acct {
>>  	atomic64_t		pkts;
>>  	atomic64_t		bytes;
>> +	atomic64_t		bthr;
>> +	atomic_t		fmt;
> 
> These two new fields are meaningless to the kernel and they consume
> extra memory for other people that may not want to use these new
> features.
> 
> Instead of this, you can have a /etc/nfacct.conf file that contains
> the formats and thresholds:
> 
> name "ALL 27 net" {
>         pkts GiB
>         bytes TiB
>         threshold 6TiB
> }
> 
> name "ALL misc" {
>         bytes GiB
> }
> 
> ...
> 
> and so on. You can add new options for the `nfacct add' command so
> this formats and thresholds are automatically appended to the
> configuration file.
> 
> I can help you by making a little parser to read the file and put that
> formatting information into a list or hashtable. Thus, you can edit
> the format and thresholds by modifying the configuration file, without
> the need for interactions with the kernel.
> 
> BTW, atomic is not required for those two fields, this is protected by
> the nfnl_lock.
I disagree with you entirely.

The two fields above aren't "meaningless" - they have a purpose and are an integral part of the nfacct object. None of the fields in the nfacct object are really used in the operation of the kernel itself - the kernel merely updates these. To put it bluntly, the whole nfacct struct is used as storage and the kernel don't use any of these fields in its core operation. OK, I agree that packet and byte counters are going to be updated much more frequently by the kernel than the fmt and bthr variables, but the fact is that these, strictly speaking, do not dependent for the kernel to operate. What I've done above is not a unique approach - in the kernel code there are a lot of examples like this, it is not something new and we are not re-inventing the wheel here or breaking a new ground.

Another reason for having fmt and bthr as part of the kernel nfacct struct is that this data, alongside the bytes and packet counters, is shielded and protected (in ring0), its integrity guaranteed and can only be changed via the kernel itself and nothing else. This is very important for us.

In the early stages of the nfacct changes, we considered a very similar approach to what you have proposed above, but rejected it, not least because the integrity and security of the data encapsulated in the nfacct struct cannot be guaranteed otherwise. We will rely heavily on this and don't need it to be changed arbitrarily (either by "mistake" or intentionally), so we decided that this is the best way going forward.

In stage 2 (current plans are this to be completed by the end of q2 of this year) we will extend this and create a specifically designed daemon (nfacctd), which will "talk" directly to the kernel and retrieve accounting data (much like what nfacct executable currently does, but on a bigger scale) on-demand and in real time and then send it to a central point where such data will be collected from all other machines for statistics and analysis. That daemon can't be spending extra cpu cycles parsing files that may or may not exist or check whether the data in them is or isn't reliable (whether it is "changed" on purpose or not) - that really isn't good enough.

>>  	if (matching) {
>>  		if (nlh->nlmsg_flags & NLM_F_REPLACE) {
>> -			/* reset counters if you request a replacement. */
>> +			/* reset counters if you request a replacement */
>> +			if (!tb[NFACCT_PKTS]) {
>> +				/*
>> +				 * Prevent resetting the packets counter if
>> +				 * either fmt or bthr are specified.
>> +				 *
>> +				 * This is done for backward compatibility,
>> +				 * otherwise resetting these counters should
>> +				 * only be allowed when tb[NFACCT_PKTS] is
>> +				 * explicitly specified and == 0.
>> +				 *
>> +				 */
>> +				if (!tb[NFACCT_FMT] &&
>> +				    !tb[NFACCT_BTHR]) {
>>  			atomic64_set(&matching->pkts, 0);
>> +				}
>> +			} else {
>> +				atomic64_set(&matching->pkts,
>> +				be64_to_cpu(nla_get_be64(tb[NFACCT_PKTS])));
> 
> The replacement operation is not so easy. Note that you may hit
> inconsistencies if while replacing the packet counter, the kernel
> updates the byte counter, and then you replace the byte counter. You
> would be leaking bytes and packets.
If I understand you correctly Pablo, you are worried that the packet and byte counters can be, in a way "misaligned". But if we are to update these values we don't really care if the old values get updated or not prior to that change, do we?

In other words, the packet value is updated and the kernel changes the byte value in the meantime. If we are later (in the same call) replacing the bytes value why do we care that there is a momentary inconsistency - we are going to replace it with a new value anyway?

One thing I'll correct with the next submission is to make sure that request for packet counter update is made in the same call as a request for an update to byte counters, otherwise we might be having only the packet or only the byte counters updated, which will introduce an inconsistency. In other words, have something like:

if (tb[NFACCT_PKTS] && tb[NFACCT_BYTES]) {
 <do an update on both counters>
} else if (tb[NFACCT_PKTS] || tb[NFACCT_BYTES]) { // only one of packets/bytes request has been made, reject it
  return -EINVAL;
}

I hope I understood you correctly here.

One "technical" query regarding future submissions: from reading this list, I gather that the patches need to be submitted using git, is that correct?

The reason I ask this is because my git experience is zero (we use svn on all our development systems) and if it is possible to attach my patches as files (during my submission the last time, a friend of mine gave me a hand and prepared the patches for me as I am an absolute noob as far as git is concerned).

If it is too much trouble, I'll probably scratch out the commands needed to execute git and do it that way - let me know.
