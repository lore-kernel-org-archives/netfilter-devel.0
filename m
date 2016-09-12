From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft V2] src: fix compile error due to _UNTIL renamed to
 _MODULUS in libnftnl
Date: Mon, 12 Sep 2016 19:58:33 +0200
Message-ID: <20160912175833.GB1221@salvia>
References: <1473682744-5504-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, nevola@gmail.com,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51038 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755094AbcILR6i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 13:58:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 40D6F12A696
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 19:58:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3091D1153E3
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 19:58:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F11C6114D73
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 19:58:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473682744-5504-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 12, 2016 at 08:19:04PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> In the latest libnftnl, NFTNL_EXPR_NG_UNTIL was renamed to
> NFTNL_EXPR_NG_MODULUS, so compile error happened:
>   netlink_linearize.c: In function ‘netlink_gen_numgen’:
>   netlink_linearize.c:184:26: error: ‘NFTNL_EXPR_NG_UNTIL’ undeclared
>   (first use in this function)
> 
> Also update NFTA_NG_UNTIL to NFTA_NG_MODULUS.

Applied, thanks.
