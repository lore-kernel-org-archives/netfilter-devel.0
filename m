From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack-tools] ipv6: remove use of HAVE_INET_PTON_IPV6
Date: Mon, 29 May 2017 18:25:23 +0200
Message-ID: <20170529162523.GA22681@salvia>
References: <1496072655-26752-1-git-send-email-nicolas.dichtel@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50186 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750844AbdE2QZn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 May 2017 12:25:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 65FC581424
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 18:25:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 57070102186
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 18:25:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6727E100A41
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 18:25:32 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1496072655-26752-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 29, 2017 at 05:44:15PM +0200, Nicolas Dichtel wrote:
> The goal of this patch is to fix the ipv6 support when conntrackd is
> cross-compiled. The AC_RUN_IFELSE macro must be avoided as much as possible.
> See section 6.6 of the gnu autoconf:
> "If you really need to test for a runtime behavior while configuring, you can
>  write a test program to determine the result, and compile and run it using
>  AC_RUN_IFELSE. Avoid running test programs if possible, because this prevents
>  people from configuring your package for cross-compiling."
> 
> Let's remove this check and test the returned error to handle the case where
> ipv6 is not supported (inet_pton() returns -1 when the family is not supported).

Much less ifdef pollution, much better indeed.

One comment below:

> diff --git a/src/read_config_yy.y b/src/read_config_yy.y
> index 3bb7c5f90017..e4fd277a47ea 100644
> --- a/src/read_config_yy.y
> +++ b/src/read_config_yy.y
> @@ -240,17 +240,17 @@ multicast_option : T_IPV4_ADDR T_IP
>  multicast_option : T_IPV6_ADDR T_IP
>  {
>  	__max_dedicated_links_reached();
> +	int err;
>  
> -#ifdef HAVE_INET_PTON_IPV6
> -	if (inet_pton(AF_INET6, $2,
> -		      &conf.channel[conf.channel_num].u.mcast.in) <= 0) {
> +	err = inet_pton(AF_INET6, $2,
> +			&conf.channel[conf.channel_num].u.mcast.in);
> +	if (err == 0) {
>  		dlog(LOG_WARNING, "%s is not a valid IPv6 address", $2);
>  		break;
> +	} else if (err < 0) {
> +		dlog(LOG_WARNING, "inet_pton(): IPv6 unsupported!");
> +		break;

Probably better to exit() here and to use LOG_ERR instead?

If we cannot interpret this IPv6 address, we shouldn't go much
further.
