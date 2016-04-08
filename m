From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v2] src: evaluate: Show error for fanout without
 balance
Date: Fri, 8 Apr 2016 13:26:52 +0200
Message-ID: <20160408112652.GA3580@salvia>
References: <20160407172854.GA3233@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55940 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbcDHL1A (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2016 07:27:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id DACA2C9EED
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 13:26:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CC322DA395
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 13:26:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CB958DA395
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 13:26:56 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160407172854.GA3233@shivani>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 07, 2016 at 10:58:54PM +0530, Shivani Bhardwaj wrote:
> The idea of fanout option is to improve the performance by indexing CPU
> ID to map packets to the queues. This is used for load balancing.
> Fanout option is not required when there is a single queue specified.
> 
> According to iptables, queue balance should be specified in order to use
> fanout. Following that, throw an error in nftables if the range of
> queues for load balancing is not specified with the fanout option.
> 
> After this patch,
> 
> $ sudo nft add rule ip filter forward counter queue num 0 fanout
> <cmdline>:1:46-46: Error: fanout requires queue num range to be specified
> add rule ip filter forward counter queue num 0 fanout
>                                              ^

Thanks, I'm applying this with updates, basically adding this chunk to
your patch:

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 4b7c1f5..444ed4c 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1722,6 +1722,7 @@ queue_stmt_args           :       queue_stmt_arg
 queue_stmt_arg         :       QUEUENUM        stmt_expr
                        {
                                $<stmt>0->queue.queue = $2;
+                               $<stmt>0->queue.queue->location = @$;
                        }
                        |       queue_stmt_flags
                        {

I'm basically reseting the location here.

So the error printing look like:

    $ sudo nft add rule ip filter forward counter queue num 0 fanout
    <cmdline>:1:46-46: Error: fanout requires a range to be specified
    add rule ip filter forward counter queue num 0 fanout
                                             ^^^^^

which seems slightly better.

We can probably use expr_binary_error() instead expr_error() so we get
something like:

    $ sudo nft add rule ip filter forward counter queue num 0 fanout
    <cmdline>:1:46-46: Error: fanout requires a range to be specified
    add rule ip filter forward counter queue num 0 fanout
                                             ^^^^^ ~~~~~~

But this requires revisiting the parser to convert the flags to
expressions, let's have a look at this later.
