From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/2] GTP tunneling fixes for net
Date: Thu, 15 Dec 2016 22:37:38 +0100
Message-ID: <20161215213738.GA10419@salvia>
References: <1481837753-10317-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33670 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754568AbcLOWCq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Dec 2016 17:02:46 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8E8637642
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Dec 2016 22:37:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7EFDADA729
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Dec 2016 22:37:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5E57EDA729
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Dec 2016 22:37:39 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1481837753-10317-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sorry for the noise, this is not Netfilter related, my robot has
tricked me, I have fixed it now.

On Thu, Dec 15, 2016 at 10:35:51PM +0100, Pablo Neira Ayuso wrote:
> Hi David,
> 
> The following patchset contains two GTP tunneling fixes for your net
> tree, they are:
> 
> 1) Offset to IPv4 header in gtp_check_src_ms_ipv4() is incorrect, thus
>    this function always succeeds and therefore this defeats this sanity
>    check. This allows packets that have no PDP to go though, patch from
>    Lionel Gauthier.
> 
> 2) According to Note 0 of Figure 2 in Section 6 of 3GPP TS 29.060 v13.5.0
>    Release 13, always set GTPv1 reserved bit to zero. This may cause
>    interoperability problems, patch from Harald Welte.
> 
> Please, apply, thanks a lot!
> 
> Harald Welte (1):
>   gtp: Fix initialization of Flags octet in GTPv1 header
> 
> Lionel Gauthier (1):
>   gtp: gtp_check_src_ms_ipv4() always return success
> 
>  drivers/net/gtp.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> -- 
> 2.1.4
> 
