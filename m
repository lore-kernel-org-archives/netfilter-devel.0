From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] extensions: libxt_hashlimit: fix 64-bit printf
 formats
Date: Tue, 11 Apr 2017 09:00:19 +0200
Message-ID: <20170411070019.GA2180@salvia>
References: <1491565649-16679-1-git-send-email-James.Cowgill@imgtec.com>
 <20170408202917.GA3568@salvia>
 <nycvar.YFH.7.76.1704101749480.27401@n3.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: James Cowgill <James.Cowgill@imgtec.com>,
        netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60696 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752335AbdDKHA1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Apr 2017 03:00:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EC50BD25F7
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Apr 2017 09:00:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DDCBEDA873
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Apr 2017 09:00:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9DF53DA873
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Apr 2017 09:00:20 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1704101749480.27401@n3.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 10, 2017 at 05:59:07PM +0200, Jan Engelhardt wrote:
> 
> On Saturday 2017-04-08 22:29, Pablo Neira Ayuso wrote:
> >> @@ -262,7 +262,7 @@ static uint64_t parse_burst(const char *burst, int revision)
> >>  	if (v > max)
> >>  		xtables_error(PARAMETER_PROBLEM, "bad value for option "
> >>  			"\"--hashlimit-burst\", value \"%s\" too large "
> >> -				"(max %lumb).", burst, max/1024/1024);
> >> +				"(max %" PRIu64 "mb).", burst, max/1024/1024);
> >                                        ^      ^
> >
> >I can remove this whitespaces, right?
> 
> With my distro hat on:
> 
> Clumping these together like "foo"BAR"baz" has already caused compile failures
> in the broader scope of distributions (thousands of packages) because languages
> introduced new tokenization rules. Admittedly, this occurred in C++ (namely,
> user-defined string literals), but it does show that tokens which logically are
> separate should stay separate.

Existing code doesn't add space, so I would like we don't introduce
inconsistencies.
