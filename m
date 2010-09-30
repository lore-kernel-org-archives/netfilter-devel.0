From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/6] ulogd.conf: Comment library dependant plugins
Date: Thu, 30 Sep 2010 11:51:27 +0200
Message-ID: <4CA45D9F.3050703@netfilter.org>
References: <1285116442-32490-1-git-send-email-eric@inl.fr> <1285116442-32490-3-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44182 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755517Ab0I3Jva (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Sep 2010 05:51:30 -0400
In-Reply-To: <1285116442-32490-3-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 22/09/10 02:47, Eric Leblond wrote:
> diff --git a/ulogd.conf.in b/ulogd.conf.in
> index cda5bb9..de5bc11 100644
> --- a/ulogd.conf.in
> +++ b/ulogd.conf.in
> @@ -25,9 +25,9 @@ loglevel=1
>  # 2. options for each plugin in seperate section below
>  
>  
> -plugin="@libdir@/ulogd/ulogd_inppkt_NFLOG.so"
> +#plugin="@libdir@/ulogd/ulogd_inppkt_NFLOG.so"
>  #plugin="@libdir@/ulogd/ulogd_inppkt_ULOG.so"
> -plugin="@libdir@/ulogd/ulogd_inpflow_NFCT.so"
> +#plugin="@libdir@/ulogd/ulogd_inpflow_NFCT.so"

I prefer leaving this there. I know that you are doing this because of
the compile time new option that you have inserted. But these are the
main plugins!
