From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/2 v2] New netfilter target to trigger LED devices
Date: Wed, 12 Nov 2008 12:01:57 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811121157200.17100@fbirervta.pbzchgretzou.qr>
References: <49196D12.1030803@shikadi.net> <alpine.LNX.1.10.0811111318020.19024@fbirervta.pbzchgretzou.qr> <491AB0C5.9030305@shikadi.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41580 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbYKLLB6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Nov 2008 06:01:58 -0500
In-Reply-To: <491AB0C5.9030305@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-11-12 11:32, Adam Nielsen wrote:
>> 
>> You now have an alignment problem, and need at least
>> 	void *internal_data __attribute__((aligned(8)))
>> as explained in the PDF. Ultimatively, these shouls be reordered to
>> accomodate for gaps (see doc).
>> 
>> Also, why is it 26?
>
> Ah bummer, I forgot about that.  Is this the best order?

No, that will break offsetof() in .userspacesize, as it will
become 0.

> If I'm
> understanding correctly this order shouldn't need member alignment.
>
> struct xt_led_info {
> 	void *internal_data;
> 	__u32 delay;
> 	__u8 always_blink;
> 	char id[26];
> };
>
> The id[26] is for a 16 char ID + the 10 digit "netfilter-" prefix.
> Actually that's a good point, it needs to be 27 to accomodate the
> terminating NULL.  At any rate, I'm not sure of the best way to describe
> that, without using #define.  What do you suggest?

struct xt_led_tginfo {
	char id[27];
	__u8 always_blink;
	__u32 delay;
	void *internal_data __attribute__((aligned(8)));
};

add id - 27 bytes.
add always_blink - 28 bytes.
28? That's good for alignment of a u32. Add delay.
32? That's good for alignment of a potentially-ptr64.
And it's solved, even without thinking of NULs or prefixes.

>
>  /* strlen("netfilter-") + 16 char user-definable name */
>  #define LED_TRIGGER_ID_LENGTH (10 + 16)
>
>  char id[LED_TRIGGER_ID_LENGTH + 1];
>
> In that case it might be worth #defining the 16 char part separately,
> so that it can be used in the parameter verification code too.  Let
> me know what you think.

Just use [27] - the struct will be hardcoded forever,
and putting #defines somewhere gives a wrong illusion it might be changeable.

