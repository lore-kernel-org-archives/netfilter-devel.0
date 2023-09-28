Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D08CE7B1F
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 19:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbjI1TPS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Sep 2023 15:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbjI1TPR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2023 15:15:17 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780A1199;
        Thu, 28 Sep 2023 12:14:47 -0700 (PDT)
Received: from [78.30.34.192] (port=36456 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qlwTD-0041HR-HV; Thu, 28 Sep 2023 21:14:45 +0200
Date:   Thu, 28 Sep 2023 21:14:42 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>, audit@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [nf PATCH 2/3] netfilter: nf_tables: Deduplicate
 nft_register_obj audit logs
Message-ID: <ZRXQog2knfZ5n6Jp@calendula>
References: <20230923015351.15707-1-phil@nwl.cc>
 <20230923015351.15707-3-phil@nwl.cc>
 <ZRSFgQA+P9/L2uUb@calendula>
 <ZRWSKxKXjzlFHl7G@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZRWSKxKXjzlFHl7G@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 28, 2023 at 04:48:11PM +0200, Phil Sutter wrote:
> On Wed, Sep 27, 2023 at 09:41:53PM +0200, Pablo Neira Ayuso wrote:
> > OK, so nft_obj_notify() is called from nft_quota to notify that the
> > quota is depleted and the audit log is still there in this case.
> 
> Exactly. I needed an internal __nft_obj_notify() which just serves
> notify_list but not audit.

Patch LGTM, thanks for explaining!
