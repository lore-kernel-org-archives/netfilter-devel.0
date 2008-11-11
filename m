From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/2 v2] New netfilter target to trigger LED devices
Date: Tue, 11 Nov 2008 13:19:43 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811111318020.19024@fbirervta.pbzchgretzou.qr>
References: <49196D12.1030803@shikadi.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53012 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbYKKMTp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Nov 2008 07:19:45 -0500
In-Reply-To: <49196D12.1030803@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-11-11 12:31, Adam Nielsen wrote:
> +++ b/include/linux/netfilter/xt_LED.h
> @@ -0,0 +1,12 @@
> +#ifndef _XT_LED_H
> +#define _XT_LED_H
> +
> +struct xt_led_info {
> +	char id[26];        /* Unique ID for this trigger in the LED class */
> +	__u32 delay;        /* Delay until LED is switched off after trigger */
> +	__u8 always_blink;  /* Blink even if the LED is already on */
> +
> +	void *internal_data; /* Kernel data used in the module */
> +};

You now have an alignment problem, and need at least
	void *internal_data __attribute__((aligned(8)))
as explained in the PDF. Ultimatively, these shouls be reordered to
accomodate for gaps (see doc).

Also, why is it 26?
