Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4506C7EE23
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Jun 2023 19:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbjFATSI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Jun 2023 15:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbjFATSI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Jun 2023 15:18:08 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F09513E;
        Thu,  1 Jun 2023 12:18:07 -0700 (PDT)
Date:   Thu, 1 Jun 2023 21:18:05 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Abhijeet Rastogi <abhijeet.1989@gmail.com>
Subject: Re: [PATCH net-next] ipvs: dynamically limit the connection hash
 table
Message-ID: <ZHju7cARozHokVFU@calendula>
References: <20230517123731.56733-1-ja@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230517123731.56733-1-ja@ssi.bg>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 17, 2023 at 03:37:31PM +0300, Julian Anastasov wrote:
> As we allow the hash table to be configured to rows above 2^20,
> we should limit it depending on the available memory to some
> sane values. Switch to kvmalloc allocation to better select
> the needed allocation type.
> 
> Signed-off-by: Julian Anastasov <ja@ssi.bg>
> ---
>  net/netfilter/ipvs/ip_vs_conn.c | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
> 
>  NOTE: This patch needs to be applied on top of V3 (or above) of patch
>  "ipvs: increase ip_vs_conn_tab_bits range for 64BIT" from Abhijeet

Done, thanks for this note.

Applied to nf-next, thanks.
