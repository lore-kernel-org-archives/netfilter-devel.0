From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Implicit flow tables can't be listed
Date: Wed, 22 Jun 2016 14:15:03 +0200
Message-ID: <20160622121503.GA12472@salvia>
References: <20160616102901.GA27422@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: nf-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36425 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbcFVM1Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 08:27:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BE42B1682E2
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 14:15:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id ADD729EBA1
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 14:15:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B55259EBA1
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 14:15:04 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160616102901.GA27422@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Thu, Jun 16, 2016 at 12:29:01PM +0200, Florian Westphal wrote:
> nft currently can't list implicit flow tables, e.g.:
> 
>  nft add rule ip filter forward flow { ip daddr counter }
> 
> ... will work, and it shows up in
> 
> 'nft list flow tables' as 'flow table __ft0' (or some other number) but
> 
>  nft list flow table filter __ft0
> ... will error out ('unexpected junk, expecting string').
> 
> We can either teach scanner.l that __ft{decstring} is a string,
> or force users to always provide a name.
>
> Any preference?

How can we actually relate the rule with the flow table if we have
several anonymous flow tables?

More thoughts on flow tables thing. I think we should explore flow
table declarations support like:

table ip filter {
        flow table ft {
                ip saddr counter
                # content here
        }

        chain forward {
                type filter hook forward priority 0;
                flow @ft
        }

So we can dereference existing flow tables from rules.

This also provides a way to restore blacklist/whitelist in case we want
to save them into file and restore them later. The original idea is
that flow tables contain volatile information, but I think someone may
want to store the current state into file and restore it, eg. in case
it needs to reboot the system.

Moreover, the output of the list flow tables command in nft should be
parseable, as it is the case for the existing object listings.

This needs a bit of code update so we can get the listing working
properly (currently what Pablo Bermudo added is a bit of a hack just
to allow people inspect their content, but as I said in the nft 0.6
announcement, this output format is not stable).
