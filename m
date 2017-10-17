From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Outreachy kernel] [PATCH] update INSTALL to add library
 libnfnetlink
Date: Tue, 17 Oct 2017 15:07:21 +0200
Message-ID: <20171017130721.GA21026@salvia>
References: <20171014125145.8336-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37600 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754099AbdJQNHb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 09:07:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E919952309
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 15:07:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D86E1BAAC3
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 15:07:29 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171014125145.8336-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Oct 14, 2017 at 06:21:45PM +0530, Harsha Sharma wrote:
> configure.ac checks for libnfnetlink(>=1.0) library
> 
> Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
> ---
>  INSTALL | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/INSTALL b/INSTALL
> index d62b428c..d28ea5c1 100644
> --- a/INSTALL
> +++ b/INSTALL
> @@ -11,6 +11,7 @@ iptables uses the well-known configure(autotools) infrastructure.
>  Prerequisites
>  =============
>  
> +	* libnfnetlink

OK, but this is optional, please try to compile this without
libnfnetlink and see what it happens. IIRC, this is only needed by
nfnl_osf.
