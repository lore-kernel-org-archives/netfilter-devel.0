From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] extensions: libxt_hashlimit: fix 64-bit printf
 formats
Date: Sat, 8 Apr 2017 22:29:17 +0200
Message-ID: <20170408202917.GA3568@salvia>
References: <1491565649-16679-1-git-send-email-James.Cowgill@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: James Cowgill <James.Cowgill@imgtec.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55584 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751505AbdDHU3X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Apr 2017 16:29:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4567F24935
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Apr 2017 22:29:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DB6BBDA7E9
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Apr 2017 22:29:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C55B8DA7F7
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Apr 2017 22:29:21 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1491565649-16679-1-git-send-email-James.Cowgill@imgtec.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 07, 2017 at 12:47:29PM +0100, James Cowgill wrote:
> hashlimit was using "%lu" in a lot of printf format specifiers to print
> 64-bit integers. This is incorrect on 32-bit architectures because
> "long int" is 32-bits there. On MIPS, it was causing iptables to
> segfault when printing these integers.
> 
> Fix by using the correct format specifier.

One comment below...

> @@ -262,7 +262,7 @@ static uint64_t parse_burst(const char *burst, int revision)
>  	if (v > max)
>  		xtables_error(PARAMETER_PROBLEM, "bad value for option "
>  			"\"--hashlimit-burst\", value \"%s\" too large "
> -				"(max %lumb).", burst, max/1024/1024);
> +				"(max %" PRIu64 "mb).", burst, max/1024/1024);
                                        ^      ^

I can remove this whitespaces, right? I'm looking at other spots in
the iptables code and I would like to keep this consistent.

No need to resent the patch, I can just mangle this here and apply.

Thanks!
