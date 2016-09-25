From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 2/2] netfilter: nf_log: get rid of XT_LOG_* macros
Date: Sun, 25 Sep 2016 15:16:39 +0200
Message-ID: <20160925131639.GA12153@salvia>
References: <1474793225-4065-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54552 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966265AbcIYNQq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Sep 2016 09:16:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5BDB8F9460
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Sep 2016 15:16:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4E997DA815
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Sep 2016 15:16:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1DAF4DA818
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Sep 2016 15:16:41 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1474793225-4065-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 25, 2016 at 04:47:05PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> nf_log is used by both nftables and iptables, so use XT_LOG_XXX macros
> here is not appropriate. Replace them with NF_LOG_XXX.

Applied, thanks!

> Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
> ---
>  I received the reject msg: "The capital Triple-X in subject is way too
>  often associated  with junk email, please rephrase ..."
>  So I rename LOG_XXX to LOG_*, and resend this patch again!

Good to know.
