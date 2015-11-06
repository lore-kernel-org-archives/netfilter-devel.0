From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrackd PATCH 2/2 v2] conntrackd: add systemd support
Date: Fri, 6 Nov 2015 14:53:18 +0100
Message-ID: <20151106135318.GA7657@salvia>
References: <144619584355.30622.12279676149815885959.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52370 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1033190AbbKFNp5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2015 08:45:57 -0500
Content-Disposition: inline
In-Reply-To: <144619584355.30622.12279676149815885959.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 30, 2015 at 10:04:34AM +0100, Arturo Borrero Gonzalez wrote:
> diff --git a/src/systemd.c b/src/systemd.c
> new file mode 100644
> index 0000000..82f1dd5
> --- /dev/null
> +++ b/src/systemd.c
> @@ -0,0 +1,61 @@
> +/*
> + * (C) 2015 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include "systemd.h"
> +#include "conntrackd.h"
> +#include "alarm.h"
> +#include <systemd/sd-daemon.h>
> +#include <sys/types.h>
> +#include <unistd.h>
> +
> +static struct alarm_block	sd_watchdog;
> +static uint64_t			sd_watchdog_interval;
>
> +static void sd_ct_watchdog_alarm(struct alarm_block *a, void *data)
> +{
> +	sd_notify(0, "WATCHDOG=1");
> +	add_alarm(&sd_watchdog, 0, sd_watchdog_interval);
> +}
> +
> +void sd_ct_watchdog_init(void)
> +{
> +	/* ignoring systemd API erros: only care if admin expects watchdog */

Not sure what you mean with this comment.

> +	if (sd_watchdog_enabled(0, &sd_watchdog_interval) < 1)

So sd_watchdog_enabled is setting sd_watchdog_interval?

What is the value that sd_watchdog_interval is being set?

> +		return;
> +
> +	/* from man page, recommended interval is half of set by admin */
> +	sd_watchdog_interval = sd_watchdog_interval / 2;
> +
> +	init_alarm(&sd_watchdog, &sd_watchdog_interval, sd_ct_watchdog_alarm);
> +	add_alarm(&sd_watchdog, 0, sd_watchdog_interval);
> +}

Let me know, thanks.
