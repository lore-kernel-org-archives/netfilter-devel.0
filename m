From: Josh Hunt <johunt@akamai.com>
Subject: Re: [PATCH 1/3] xtables: tarpit: Make tarpit code generic
Date: Sun, 08 Jul 2012 08:58:37 -0500
Message-ID: <4FF9920D.2000808@akamai.com>
References: <1341696061-21863-1-git-send-email-johunt@akamai.com> <1341696061-21863-2-git-send-email-johunt@akamai.com> <alpine.LNX.2.01.1207081448340.29827@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:43571 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307Ab2GHN6j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Jul 2012 09:58:39 -0400
In-Reply-To: <alpine.LNX.2.01.1207081448340.29827@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07/08/2012 07:58 AM, Jan Engelhardt wrote:
>
> On Saturday 2012-07-07 23:20, Josh Hunt wrote:
>
>> Moves TCP header manipulation into a separate function to allow code-sharing for
>> IPv6 support.
>
> Hi Josh,
>
>
> in your patch, you seem to oversee that the tarpit_generic block that
> you are moving into a new function had "return;"s to exit from
> the tarpit_tcp function. With your change,
>
>> +	niph->tot_len = htons(nskb->len);
>> +	tcph->urg_ptr = 0;
>> +	/* Reset flags */
>> +	((u_int8_t *)tcph)[13] = 0;
>> +
>> +	tarpit_generic(oth, tcph, payload, mode);
>>
>> 	/* Adjust TCP checksum */
>> 	tcph->check = 0;
>
> The checksum code (and what follows) it will be executed in all cases,
> even though TCP RST are supposed not to get any reply per the comment.
>
> tarpit_generic would have to return a bool value propagating this
> exit style. In other words,
>
>
> static bool tarpit_generic
> {
> 	if (mode == XTTARPIT_TARPIT)
> 		/* No replies for RST, FIN , ... */
> 		if (oth->rst ...)
> 			return false;
> 	}
> 	...
> 	return true;
> }
>
> static void tarpit_tcp
> {
> 	...
> 	if (!tarpit_generic())
> 		return;
> 	tcph->check = 0;
> 	...
> }

Doh! Yep totally overlooked that. Thanks for catching. Will update and 
resend.

>
> It would also be appreciated if you could move each case
> (XTTARPIT_{TARPIT,HONEYPOT,RESET}) into their own functions in three
> patches added to the front of the set.
> (Reduces indent and makes the diffs simpler.)
>

Sure. I'll do this as well.

Thanks for the review.

Josh
