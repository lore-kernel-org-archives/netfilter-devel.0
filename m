From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libnfnetlink-1.0.0 iftable.c:nlif_open() has handler
 unregister error
Date: Thu, 30 Sep 2010 13:28:30 +0200
Message-ID: <4CA4745E.6070000@netfilter.org>
References: <199131285829294@web100.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Kuzin Andrey <kuzinandrey@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59219 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab0I3L2g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Sep 2010 07:28:36 -0400
In-Reply-To: <199131285829294@web100.yandex.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 30/09/10 08:48, Kuzin Andrey wrote:
> struct nlif_handle *nlif_open(void)
> {
> ..........
>     if (rtnl_handler_register(h->rtnl_handle, &h->ifadd_handler) < 0)
>          goto err_close;
>     if (rtnl_handler_register(h->rtnl_handle, &h->ifdel_handler) < 0)
>          goto err_unregister;
>     return h;
> err_unregister:
>     rtnl_handler_unregister(h->rtnl_handle, &h->ifdel_handler);
> err_close:
>     rtnl_close(h->rtnl_handle);
>     free(h);
> err:
>     return NULL;
> }
> 
> 
> Here if was error after rtnl_handler_register(... ifdel_handler...) need to unregister the ifadd_handler,
> but in err_unregister: try to unregister the the ifdel_handler.

Applied, thanks Andrey.
