From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_ct_tcp: Remove the duplicated word in
 comment
Date: Sat, 29 Aug 2015 01:14:36 +0200
Message-ID: <20150828231436.GA24569@salvia>
References: <CA+6hz4o+XCrHt_f31kK1d2=jsHY3mDvU4rEM=8DbmhiVbxDSNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Feng Gao <gfree.wind@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43254 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbbH1XIS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Aug 2015 19:08:18 -0400
Content-Disposition: inline
In-Reply-To: <CA+6hz4o+XCrHt_f31kK1d2=jsHY3mDvU4rEM=8DbmhiVbxDSNw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 22, 2015 at 11:27:56AM +0800, Feng Gao wrote:
> Hi Pablo,
> 
> To try to resolve the "git am" issue, so I start the new email
> conversation. The attachment is the latest patch file.
> 
> The following is the patch content too.

Still not working, I think your MUA is mangling the patch. I can see
that tabs are converted to spaces.

$ git am /temporary/netfilter-nf_ct_tcp-Remove-the-duplicated-word-in-comment.patch -s
Applying: netfilter: nf_ct_tcp: Remove the duplicated word in comment
error: patch failed: net/netfilter/nf_conntrack_proto_tcp.c:1088
error: net/netfilter/nf_conntrack_proto_tcp.c: patch does not apply
Patch failed at 0001 netfilter: nf_ct_tcp: Remove the duplicated word in comment
When you have resolved this problem run "git am --resolved".
If you would prefer to skip this patch, instead run "git am --skip".
To restore the original branch and stop patching run "git am --abort".
$ git am --abort
$ patch -p1 < /temporary/netfilter_ct_tcp-Remove-the-duplicated-word-in-comment.patch 
patching file net/netfilter/nf_conntrack_proto_tcp.c
Hunk #1 FAILED at 1088.
1 out of 1 hunk FAILED -- saving rejects to file
net/netfilter/nf_conntrack_proto_tcp.c.rej

> -       /* Set ASSURED if we see see valid ack in ESTABLISHED
> -          after SYN_RECV or a valid answer for a picked up
> -          connection. */
> +       /* Set ASSURED if we see valid ack in ESTABLISHED after
> +        * SYN_RECV or a valid answer for a picked up connection.
> +        */
   ^^^^^^^^
I can see space here instead of tab.

