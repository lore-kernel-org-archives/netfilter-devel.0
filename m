From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: xt_ipcomp: add "ip[6]t_ipcomp" module
 alias name
Date: Mon, 17 Oct 2016 17:22:55 +0200
Message-ID: <20161017152255.GA7730@salvia>
References: <1476277762-58471-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38524 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755068AbcJQPXM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 11:23:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 40C976EACA
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 17:23:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 31C7CDA84C
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 17:23:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 36212DA7F7
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 17:23:04 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1476277762-58471-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 12, 2016 at 09:09:22PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Otherwise, user cannot add related rules if xt_ipcomp.ko is not loaded:
>   # iptables -A OUTPUT -p 108 -m ipcomp --ipcompspi 1
>   iptables: No chain/target/match by that name.

Applied, thanks.
