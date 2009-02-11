From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/2 v3] New netfilter target to trigger LED devices
Date: Wed, 11 Feb 2009 17:05:34 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902111704030.22845@fbirervta.pbzchgretzou.qr>
References: <4992B8AF.3080608@shikadi.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, rpurdie@linux.intel.com
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54059 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbZBKQFf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 11:05:35 -0500
In-Reply-To: <4992B8AF.3080608@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-02-11 12:38, Adam Nielsen wrote:
> +struct xt_led_info {
> +	char id[26];        /* Unique ID for this trigger in the LED class */
> +	__u32 delay;        /* Delay until LED is switched off after trigger */
> +	__u8 always_blink;  /* Blink even if the LED is already on */
> +
> +	void *internal_data; /* Kernel data used in the module */

I wonder. We talked about alignment and padding, but it seemed
to not have helped :)

This really needs
	void *internal_data __attribute__((aligned(8)))

And because 26+4+1 = 31, you can make that id[27] to fill-it-up.

Otherwise pretty clean.
