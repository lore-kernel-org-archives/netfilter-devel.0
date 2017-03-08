From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] xtables-translate: Avoid querying the kernel
Date: Wed, 8 Mar 2017 16:45:22 +0100
Message-ID: <20170308154522.GA1586@salvia>
References: <20170308133842.GA31371@salvia>
 <20170308154325.9121-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36012 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750728AbdCHPqy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 10:46:54 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2F80D1770FD
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 16:45:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2272FDA84C
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 16:45:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CD2CEDA809
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 16:45:27 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170308154325.9121-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 08, 2017 at 04:43:25PM +0100, Phil Sutter wrote:
> This originally came up when accidentally calling iptables-translate as
> unprivileged user - nft_compatible_revision() then fails every time,
> making the translator fall back to using revision 0 only which often
> leads to failed translations (due to missing xlate callback).
> 
> The bottom line is there is no need to check what revision of a given
> iptables match the kernel supports when it is only to be translated into
> an nftables equivalent. So just assign a dummy callback returning good
> for any revision being asked for.

Applied, thanks a lot Phil.
