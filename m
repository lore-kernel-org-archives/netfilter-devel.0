From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft RFC PATCH] src: add import operation
Date: Tue, 21 Jan 2014 17:32:03 +0000
Message-ID: <20140121173203.GA19183@macbook.localnet>
References: <20140121170211.31038.31659.stgit@nfdev.cica.es>
 <20140121172209.GB8194@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41326 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbaAURcH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 12:32:07 -0500
Content-Disposition: inline
In-Reply-To: <20140121172209.GB8194@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 21, 2014 at 05:22:09PM +0000, Patrick McHardy wrote:
> On Tue, Jan 21, 2014 at 06:02:11PM +0100, Arturo Borrero Gonzalez wrote:
> > The import operation reads XML/JSON data from stdin.
> > 
> > A basic way to test is:
> >  % nft export json | nft import json
> > 
> > This operation flush the kernel ruleset before adding the one imported.
> > 
> > Adding data from a file:
> >  % cat file.json | nft import json
> >  % nft import json < file.json
> 
> OK I think I understand your -EBUSY problem. We're destroying the rules'
> expressions from within the RCU callback, so its happening asynchronous.
> You most likely don't get EBUSY when deleting the table, but when deleting
> the set because the bindings from the lookup rules are not released yet.
> You then will *also* get -EBUSY from table deletion.
> 
> Basically I see these possibilities to fix this:
> 
> - Use synchronize_rcu() instead of call_rcu() for rule deletion. We
>   added the call_rcu() because deletion performance was suffering
>   badly from lots of synchronize_rcu() calls. This is obviously not
>   a problem anymore with batched deletion.
> 
> - Use synchronize_rcu() before deleting sets. Same effect, but in case
>   someone really does unbatched deletes, it will very likely result in
>   less synchronize_rcu() calls.

Actually this one is nonsense. synchronize_rcu() doesn't guarantee that
a scheduled RCU callback has already returned. I'd suggest to switch back
rule deletion to use synchronize_rcu().

Basically our API is currently broken since it contains a race condition.
Userspace must be able to assume that the referenced objects can be
removed after the DELRULE command has completed.

> Regarding this patch, I don't think we should add this before we support
> atomic replacement of tables, chains and sets as well. IOW, this needs
> quite a bit of kernel work.
