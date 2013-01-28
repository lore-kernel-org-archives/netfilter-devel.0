From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 6/8] iptables: fall back to using save function when
 print is not defined
Date: Mon, 28 Jan 2013 12:37:20 +0100
Message-ID: <20130128113720.GD15781@1984>
References: <1359056278-27618-1-git-send-email-jengelh@inai.de>
 <1359056278-27618-7-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41434 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091Ab3A1Lhl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:37:41 -0500
Content-Disposition: inline
In-Reply-To: <1359056278-27618-7-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 24, 2013 at 08:37:56PM +0100, Jan Engelhardt wrote:
> diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
> index 371d700..aa22e52 100644
> --- a/iptables/ip6tables.c
> +++ b/iptables/ip6tables.c
[...]
> @@ -617,6 +621,10 @@ print_firewall(const struct ip6t_entry *fw,
>  		if (target->print)
>  			/* Print the target information. */
>  			target->print(&fw->ipv6, t, format & FMT_NUMERIC);
> +		else if (target->save != NULL) {
> +			printf("hi world");
                               ^^^^^^^^^^
                                hi Jan :-)
