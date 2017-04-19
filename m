From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: tcp: Use TCP_MAX_WSCALE instead of
 literal 14
Date: Wed, 19 Apr 2017 17:58:22 +0200
Message-ID: <20170419155822.GA8603@salvia>
References: <1492565022-110676-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>
To: gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57034 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965466AbdDSP6h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2017 11:58:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 155E82EFEAC
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 17:58:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E57D2FC600
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 17:58:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E11EEFEFCB
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 17:58:23 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1492565022-110676-1-git-send-email-gfree.wind@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 19, 2017 at 09:23:42AM +0800, gfree.wind@foxmail.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> The window scale may be enlarged from 14 to 15 according to the itef
> draft https://tools.ietf.org/html/draft-nishida-tcpm-maxwin-03.
> 
> Use the macro TCP_MAX_WSCALE to support it easily with TCP stack in
> the future.

Applied, thanks.
