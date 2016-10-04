From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] doc: Fix wrong word in description of option "-n
 --numberic"
Date: Tue, 4 Oct 2016 09:29:18 +0200
Message-ID: <20161004072917.GA19465@salvia>
References: <1475152783-379-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53050 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752253AbcJDH3e (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Oct 2016 03:29:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ABB1D15AEAC
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Oct 2016 09:29:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9F78DBAC22
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Oct 2016 09:29:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D6903DA91E
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Oct 2016 09:29:26 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1475152783-379-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 29, 2016 at 08:39:43PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> There is one wrong word in description of option "-n --numberic" in
> nft.xml. There are duplicated "used twice", and the former one should
> be "used once".
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  doc/nft.xml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/doc/nft.xml b/doc/nft.xml
> index 3b215f8..bc09623 100644
> --- a/doc/nft.xml
> +++ b/doc/nft.xml
> @@ -113,7 +113,7 @@ vi:ts=4 sw=4
>  					<para>
>  						Numeric output: Addresses and other information
>  						that might need network traffic to resolve to symbolic names
> -						are shown numerically (default behaviour). When used twice,
> +						are shown numerically (default behaviour). When used once,

No, this is done on purpose. The first -n is these days noop.

Originally, this first -n displayed IP addresses as we were displaying
names by default.

See commit 31f031b0d348afd1c343692eca4b496c4bf5d05d
Author: Arturo Borrero <arturo.borrero.glez@gmail.com>
Date:   Thu Nov 6 09:05:28 2014 +0100

    nft: don't resolve hostnames by default

