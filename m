Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 670C1C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jan 2022 21:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244285AbiAJVgP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jan 2022 16:36:15 -0500
Received: from mail.netfilter.org ([217.70.188.207]:44694 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345453AbiAJVfT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jan 2022 16:35:19 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3543C63F5A;
        Mon, 10 Jan 2022 22:32:27 +0100 (CET)
Date:   Mon, 10 Jan 2022 22:35:13 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 06/11] xtables: Do not pass nft_handle to
 do_parse()
Message-ID: <YdymkeJgwz4BYSAz@salvia>
References: <20211224171754.14210-1-phil@nwl.cc>
 <20211224171754.14210-7-phil@nwl.cc>
 <YdylQQa+QMyS5lcQ@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YdylQQa+QMyS5lcQ@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jan 10, 2022 at 10:29:37PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Dec 24, 2021 at 06:17:49PM +0100, Phil Sutter wrote:
> [...]
> > diff --git a/iptables/xshared.h b/iptables/xshared.h
> > index dde94b7335f6a..1954168f64058 100644
> > --- a/iptables/xshared.h
> > +++ b/iptables/xshared.h
> [...]
> >  struct xt_cmd_parse {
> >  	unsigned int			command;
> >  	unsigned int			rulenum;
> > @@ -272,6 +305,11 @@ struct xt_cmd_parse {
> >  	bool				restore;
> >  	int				verbose;
> >  	bool				xlate;
> 
> Probably wrap these two common functions between legacy and nft in a
> structure? Something like: struct nft_parse_ops...

struct xt_parse_ops...

> > +	void		(*proto_parse)(struct iptables_command_state *cs,
> > +				       struct xtables_args *args);
> > +	void		(*post_parse)(int command,
> > +				      struct iptables_command_state *cs,
> > +				      struct xtables_args *args);
> >  };
> >  
> >  #endif /* IPTABLES_XSHARED_H */
> > diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
> > index 9d312b244657e..b0b27695cbb8c 100644
> > --- a/iptables/xtables-translate.c
> > +++ b/iptables/xtables-translate.c
> > @@ -252,6 +252,8 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
> >  		.table		= *table,
> >  		.restore	= restore,
> >  		.xlate		= true,
> > +		.proto_parse	= h->ops->proto_parse,
> > +		.post_parse	= h->ops->post_parse,
> 
> so you could just do:
> 
>                 .parse          = h->ops->parse,
> 
> and if you need to extend this structure in the future for whatever
> revolutionary reason, you will need to update this part of the code to
                        ^....
                        you will *not* need

> do:
> 
>                 .another_parse  = h->ops->another_parse,
> 
> Apart from this, anything else LGTM.
