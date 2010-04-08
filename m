From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3] Add refcounts to LED target
Date: Thu, 8 Apr 2010 23:07:22 +0200
Message-ID: <20100408210722.GA18974@Chamillionaire.breakpoint.cc>
References: <alpine.LSU.2.01.1003251504500.32573@obet.zrqbmnf.qr>
 <4BAB6E70.8090605@trash.net>
 <4BAD841A.9060103@shikadi.net>
 <alpine.LSU.2.01.1003271214440.13915@obet.zrqbmnf.qr>
 <4BADEE6A.5000103@shikadi.net>
 <alpine.LSU.2.01.1003271253190.1149@obet.zrqbmnf.qr>
 <4BAEB013.6060001@shikadi.net>
 <alpine.LSU.2.01.1004041327160.22215@obet.zrqbmnf.qr>
 <4BBCAF97.6040806@trash.net>
 <4BBD478F.4050208@shikadi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
	Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:41165 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758913Ab0DHVHZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Apr 2010 17:07:25 -0400
Content-Disposition: inline
In-Reply-To: <4BBD478F.4050208@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adam Nielsen <a.nielsen@shikadi.net> wrote:
> +static struct xt_led_info_internal *led_trigger_lookup(const char *name)
> +{
> +	struct xt_led_info_internal *ledinternal;
> +
> +	list_for_each_entry(ledinternal, &xt_led_triggers, list) {
> +		if (!strcmp(name, ledinternal->netfilter_led_trigger.name)) {
> +			mutex_unlock(&xt_led_mutex);

This mutex_unlock looks out of place...

>  static int led_tg_check(const struct xt_tgchk_param *par)
>  {
>  	struct xt_led_info *ledinfo = par->targinfo;
> @@ -91,11 +109,26 @@ static int led_tg_check(const struct xt_tgchk_param *par)
>  		return -EINVAL;
>  	}
>  
> +	mutex_lock(&xt_led_mutex);
> +
> +	ledinternal = led_trigger_lookup(ledinfo->id);
> +	if (ledinternal) {
> +		ledinternal->refcnt++;
> +		goto out;

...its unlocked again here via goto.

> +	err = -ENOMEM;
>  	ledinternal = kzalloc(sizeof(struct xt_led_info_internal), GFP_KERNEL);
>  	if (!ledinternal)
> -		return -ENOMEM;
> +		goto exit_mutex_only;
> +
> +	ledinternal->trigger_id = kzalloc(strlen(ledinfo->id) + 1, GFP_KERNEL);

kstrdup()?
