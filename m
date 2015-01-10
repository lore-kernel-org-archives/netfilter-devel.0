From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 1/2] src: not create iterator with empty list
Date: Sat, 10 Jan 2015 19:20:22 +0100
Message-ID: <20150110182022.GA5185@salvia>
References: <1420807661-29751-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44903 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012AbbAJSRj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 Jan 2015 13:17:39 -0500
Content-Disposition: inline
In-Reply-To: <1420807661-29751-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 09, 2015 at 01:47:40PM +0100, Alvaro Neira Ayuso wrote:
> Now, we create iterator without test if the list is empty. If the list
> is empty, we have a crash when we set up the current element.
> With this patch, we test if the list is empty before to create the iterator. If
> the list is empty the iterator return NULL.

Please, handle this from the _next() function.

The idea is to set iter->cur to NULL if the list is empty from
iter_create, ie.

        if (iter->r->expr_list.next == &iter->r.expr_list)
                iter->cur = NULL;
        else
                iter->cur = list_entry(...);

Then, from _next() you check for:

        if (expr == NULL)
                return NULL;

> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
>  src/chain.c    |    3 +++
>  src/rule.c     |    6 ++++++
>  src/set.c      |    3 +++
>  src/set_elem.c |    3 +++
>  src/table.c    |    3 +++

I can count up to six iterator interfaces, I only see 5 here, please
make sure you adapt all spots. Thanks.
