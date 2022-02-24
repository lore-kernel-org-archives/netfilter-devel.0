Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECC88C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Feb 2022 16:53:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiBXQx7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 11:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiBXQx6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 11:53:58 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE35F199D54
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Feb 2022 08:53:28 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nNGmE-0005Ud-L2; Thu, 24 Feb 2022 17:15:34 +0100
Date:   Thu, 24 Feb 2022 17:15:34 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/7] metfilter: remove pcpu dying list
Message-ID: <20220224161534.GH28705@breakpoint.cc>
References: <20220209161057.30688-1-fw@strlen.de>
 <Yhesc6YcUBrl27HX@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yhesc6YcUBrl27HX@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> net/netfilter/nf_conntrack_ecache.c:48:19: error: ‘nf_conn_retrans_list_head’ undeclared here (not in a function)
> 
> related to patch ("netfilter: conntrack: include ecache dying list in
> dumps")
> 
> I don't find the declaration in this patchset.

Sorry, I will send a v2.  This is supposed to export the function above,
not the nf_conn_retrans_list_head, which only existed in a earlier, not
sent, version of this patchset.
