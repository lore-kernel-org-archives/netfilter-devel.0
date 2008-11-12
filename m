From: Adam Nielsen <a.nielsen@shikadi.net>
Subject: Re: [PATCH 1/2 v2] New netfilter target to trigger LED devices
Date: Wed, 12 Nov 2008 20:32:37 +1000
Message-ID: <491AB0C5.9030305@shikadi.net>
References: <49196D12.1030803@shikadi.net> <alpine.LNX.1.10.0811111318020.19024@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:1807 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYKLKck (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Nov 2008 05:32:40 -0500
In-Reply-To: <alpine.LNX.1.10.0811111318020.19024@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> +struct xt_led_info {
>> +	char id[26];        /* Unique ID for this trigger in the LED class */
>> +	__u32 delay;        /* Delay until LED is switched off after trigger */
>> +	__u8 always_blink;  /* Blink even if the LED is already on */
>> +
>> +	void *internal_data; /* Kernel data used in the module */
>> +};
> 
> You now have an alignment problem, and need at least
> 	void *internal_data __attribute__((aligned(8)))
> as explained in the PDF. Ultimatively, these shouls be reordered to
> accomodate for gaps (see doc).
> 
> Also, why is it 26?

Ah bummer, I forgot about that.  Is this the best order?  If I'm
understanding correctly this order shouldn't need member alignment.

struct xt_led_info {
	void *internal_data;
	__u32 delay;
	__u8 always_blink;
	char id[26];
};

The id[26] is for a 16 char ID + the 10 digit "netfilter-" prefix.
Actually that's a good point, it needs to be 27 to accomodate the
terminating NULL.  At any rate, I'm not sure of the best way to describe
that, without using #define.  What do you suggest?

   /* strlen("netfilter-") + 16 char user-definable name */
   #define LED_TRIGGER_ID_LENGTH (10 + 16)

   char id[LED_TRIGGER_ID_LENGTH + 1];

In that case it might be worth #defining the 16 char part separately,
so that it can be used in the parameter verification code too.  Let
me know what you think.

Thanks,
Adam.
