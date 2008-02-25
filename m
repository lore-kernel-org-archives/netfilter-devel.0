From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nf_conntrack_core: Updated nf_conntrack to destroy/refresh
 conn irrespective of del_timer status
Date: Mon, 25 Feb 2008 13:11:02 +0100
Message-ID: <47C2B056.3010609@trash.net>
References: <1203916760-12951-1-git-send-email-Kapil.Juneja@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Emil Medve <Emilian.Medve@freescale.com>
To: Kapil Juneja <Kapil.Juneja@freescale.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep11-int.chello.at ([62.179.121.31]:51688 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbYBYMLJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Feb 2008 07:11:09 -0500
In-Reply-To: <1203916760-12951-1-git-send-email-Kapil.Juneja@freescale.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Kapil Juneja wrote:
> Currently NF_CONNTRACK assumes that a running timer is present before refreshing
> the connection or destroying it. This may not be the case when, for example,
> another forwarding engine hooks up to it to listen to new connections
> but disables the NF_CONNTRACK timer in order to have more control.
> In such a scenario, only control packets may be terminated to NF_CONNTRACK for
> it to decode and update the connection status. It will not impact the present
> scenario of kernel forwarding without the aid of any forwarding engine. 

Do you have a pointer to the code you're talking about?

> +		if (newtime - ct->timeout.expires >= HZ) {
> +			/*
> +			 * The timer could have already been deleted
> +			 * while still alive (for example connection
> +			 * offloaded to a forwarding module other than
> +			 * the kernel stack).
> +			 */
> +			mod_timer(&ct->timeout, newtime);
>  			event = IPCT_REFRESH;

This adds a race, we don't want to update the timer if it already
went off this that means the connection is already destroyed.
Same problem with the other chunk.
