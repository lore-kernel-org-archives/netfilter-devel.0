From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 3/3 v2] src: add list ruleset command
Date: Thu, 25 Sep 2014 19:21:33 +0200
Message-ID: <20140925172133.GA14121@salvia>
References: <1411554740-16660-1-git-send-email-arturo.borrero.glez@gmail.com>
 <1411554740-16660-3-git-send-email-arturo.borrero.glez@gmail.com>
 <CAOkSjBjRPH3hDJrVY5YPn0Db8vQgPZxdnHoPhrHHW90wjvz0vQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34308 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbaIYRUX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2014 13:20:23 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBjRPH3hDJrVY5YPn0Db8vQgPZxdnHoPhrHHW90wjvz0vQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 24, 2014 at 04:54:10PM +0200, Arturo Borrero Gonzalez wrote:
> On 24 September 2014 12:32, Arturo Borrero Gonzalez
> <arturo.borrero.glez@gmail.com> wrote:
> > This patch adds a new command to nft:
> >         % nft list ruleset [family]
> >
> 
> Hi,
> 
> this patch requires further review and tuning.
> 
> When using the interactive mode there are weird behaviours I need to
> investigate.
> Any pointer will be appreciated.

static LIST_HEAD(table_list);

void table_add_hash(struct table *table)
{
        list_add_tail(&table->list, &table_list);
}

+static int do_list_ruleset(struct netlink_ctx *ctx, struct cmd *cmd)
+{
+       struct table *table, *next;
+       LIST_HEAD(table_list);
        ^------------------^

I think we have to select a different name for this variable that is
allocated in the stack, since we already have a global table_list.
