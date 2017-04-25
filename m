From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft RFC PATCH] rule: introduce new option to print set elements
 per line
Date: Tue, 25 Apr 2017 11:22:29 +0200
Message-ID: <20170425092229.GA3577@salvia>
References: <149277062417.14594.14270713486442491994.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54976 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1428602AbdDYJWe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2017 05:22:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A773952310
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:22:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 955DBDA90B
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:22:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 399D5FF2D2
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:22:26 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <149277062417.14594.14270713486442491994.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

On Fri, Apr 21, 2017 at 12:30:24PM +0200, Arturo Borrero Gonzalez wrote:
> Add a new option to nft to print set elements per line instead
> of all in a single line.
> This is useful when printing a ruleset with very big sets.
> 
> The new option is -t/--elements.
> 
> Annonymous sets/maps/concats are not affected by this. The default
> behaviour is not changed.
> 
> Example:
> 
> % nft list ruleset -t -nn
> table ip t {
> 	set s {
> 		type inet_service
> 		elements = { 1,
> 				2,
> 				3,
> 				4,
> 				12345 }

Can we do a more intelligent folding? Via TIOCGWINSZ we can obtain the
number of columns so we can try to fit as many elements as possible
without wrapping around. Instead of one element per line? I know what
I'm asking is harder, but I would like that we explore this path
before adding this.

And I think we should do this by default, no need for an option.
Unless you are a robot, you want an output that you can actually read
without lots of lines wrapping around, eg. a very large sets with
thousands of elements.
