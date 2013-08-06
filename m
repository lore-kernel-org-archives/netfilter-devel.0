From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] (fix_led_parse_delay) value will now be set
Date: Tue, 6 Aug 2013 15:38:09 +0200
Message-ID: <20130806133809.GA15437@localhost>
References: <1375795561-11839-1-git-send-email-Eckert.Florian@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Florian Eckert <eckert.florian@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36225 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab3HFNiO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Aug 2013 09:38:14 -0400
Content-Disposition: inline
In-Reply-To: <1375795561-11839-1-git-send-email-Eckert.Florian@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 06, 2013 at 03:26:01PM +0200, Florian Eckert wrote:
> ---
>  extensions/libxt_LED.c |    2 ++
>  1 Datei ge=E4ndert, 2 Zeilen hinzugef=FCgt(+)
>=20
> diff --git a/extensions/libxt_LED.c b/extensions/libxt_LED.c
> index 8622c37..fd1e726 100644
> --- a/extensions/libxt_LED.c
> +++ b/extensions/libxt_LED.c
> @@ -63,6 +63,8 @@ static void LED_parse(struct xt_option_call *cb)
>  			xtables_error(PARAMETER_PROBLEM,
>  				"Delay value must be within range 0..%u",
>  				UINT32_MAX);
> +		else
> +			led->delay=3Datoi(cb->arg);
>  		break;

We have a fix for this already:

http://git.netfilter.org/iptables/commit/?id=3D96c42d4c46df3edbd41fa47b=
860fba217f03cfeb

Will be available in upcoming iptables 1.4.20.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
