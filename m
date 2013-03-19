From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH RFC 1/3] NFQUEUE: introduce CPU fanout
Date: Tue, 19 Mar 2013 22:57:35 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1303192249170.688@nerf07.vanv.qr>
References: <20130319141442.150005875@eitzenberger.org> <20130319141605.158831637@eitzenberger.org> <20130319.102620.2063759629502166169.davem@davemloft.net> <alpine.LNX.2.01.1303191531210.9679@nerf07.vanv.qr> <20130319213424.GE13505@imap.eitzenberger.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:32857 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868Ab3CSV5h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:57:37 -0400
In-Reply-To: <20130319213424.GE13505@imap.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2013-03-19 22:34, Holger Eitzenberger wrote:

>> http://www.braceless.org/Various/The%20Else%20Statement%20Considered%20Harmful
>> 
>> Something like
>> 
>> +static unsigned int
>> +nfqueue_tg_v3(struct sk_buff *skb, const struct xt_action_param *par)
>> +{
>> +	const struct xt_NFQ_info_v3 *info = par->targinfo;
>> +	u32 queue = info->queuenum;
>> +
>> +	if (info->queues_total == 1)
>> +		return NF_QUEUE_NR(queue);
>> ...
>> +}
>
>having read through the webpage - and using 'goto' for error handling
>in own code quite often - I don't see why your code above should be
>more readable.

It was only coincidental that the webpage also mentioned goto.
The general idea (and google keywords) was called something like
"Else Considered Harmful", and the lesson consisted of early
exclusion of simple cases from the flow of the remainder of the
function. Perhaps to illustrate it better:

	list_for_each_entry(thing, &yourlist, anchor) {
		if (thing->property == MAGIC) {
			do_stuff;
		}
	}

=>

	list_for_each_entry(thing, &yourlist, anchor) {
		if (thing->property != MAGIC)
			continue;
		do_stuff;
	}

Code may become more readable as one gains one level of indent and
have some more freedom in arranging the giblets inside the do_stuff parts.
