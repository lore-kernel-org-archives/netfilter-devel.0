From: Adam Nielsen <a.nielsen@shikadi.net>
Subject: Re: [PATCH v3] Add refcounts to LED target
Date: Fri, 09 Apr 2010 08:45:31 +1000
Message-ID: <4BBE5C8B.3070307@shikadi.net>
References: <alpine.LSU.2.01.1003251504500.32573@obet.zrqbmnf.qr> <4BAB6E70.8090605@trash.net> <4BAD841A.9060103@shikadi.net> <alpine.LSU.2.01.1003271214440.13915@obet.zrqbmnf.qr> <4BADEE6A.5000103@shikadi.net> <alpine.LSU.2.01.1003271253190.1149@obet.zrqbmnf.qr> <4BAEB013.6060001@shikadi.net> <alpine.LSU.2.01.1004041327160.22215@obet.zrqbmnf.qr> <4BBCAF97.6040806@trash.net> <4BBD478F.4050208@shikadi.net> <20100408210722.GA18974@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:52957 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933331Ab0DHWpi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Apr 2010 18:45:38 -0400
In-Reply-To: <20100408210722.GA18974@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> +static struct xt_led_info_internal *led_trigger_lookup(const char *name)
>> +{
>> +	struct xt_led_info_internal *ledinternal;
>> +
>> +	list_for_each_entry(ledinternal, &xt_led_triggers, list) {
>> +		if (!strcmp(name, ledinternal->netfilter_led_trigger.name)) {
>> +			mutex_unlock(&xt_led_mutex);
> 
> This mutex_unlock looks out of place...

Oh well spotted, I forgot to take that out when moving the mutex out of this
function.

>> +	ledinternal->trigger_id = kzalloc(strlen(ledinfo->id) + 1, GFP_KERNEL);
> 
> kstrdup()?

Thanks for the suggestion, I will change this to use kstrdup().

Cheers,
Adam.
