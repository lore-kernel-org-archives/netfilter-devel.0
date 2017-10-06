From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: man page nft.8 add chain synopsis
Date: Fri, 6 Oct 2017 14:52:50 +0200
Message-ID: <20171006125250.GA7768@salvia>
References: <20171006050838.GA9956@dimstar.local.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Netfilter Development <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:41773 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751841AbdJFMw5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Oct 2017 08:52:57 -0400
Received: from 129.166.216.87.static.jazztel.es ([87.216.166.129] helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1e0S7X-0006va-KM
        for netfilter-devel@vger.kernel.org; Fri, 06 Oct 2017 14:52:56 +0200
Content-Disposition: inline
In-Reply-To: <20171006050838.GA9956@dimstar.local.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Duncan,

On Fri, Oct 06, 2017 at 04:08:38PM +1100, Duncan Roe wrote:
> Hi,
> 
> The man page says this:
> 
> > {add | create} chain [family] table chain [ { {type} {hook} [device] {priority} } [policy] ]
> 
> But I suggest it should say this:
> 
> > {add | create} chain [family] table chain [ { {type} {hook} [device] {priority ;} [policy ;] } ]
> 
> i.e. the policy tuple should be inside the braces along with type, hook, device
> & priority. Also the device & priority tuples each need to be followed by a
> semicolon.
> 
> ** Is the above change correct?

This looks good to me.

I will include your Signed-off-by tag and will take this into the git
tree.

BTW, please next time submit your patches via git format-patch.

> * Assuming it is correct, the patch below makes the change. Can someone pick it
>   up from here or should I submit a bug report?

I'll pick it, no need for bug report.

Thanks!
