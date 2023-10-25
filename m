Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B2C1C25B6F
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 09:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbjJYJrP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 05:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbjJYJrB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 05:47:01 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D46C18D
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Oct 2023 02:46:25 -0700 (PDT)
Received: from [78.30.35.151] (port=42890 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qvaSz-00Ci5v-Qe; Wed, 25 Oct 2023 11:46:23 +0200
Date:   Wed, 25 Oct 2023 11:46:21 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v4 1/3] netfilter: nf_tables: Open-code audit log
 call in nf_tables_getrule()
Message-ID: <ZTjj7V234giF3ZTH@calendula>
References: <20231019140336.31563-1-phil@nwl.cc>
 <20231019140336.31563-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231019140336.31563-2-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 19, 2023 at 04:03:34PM +0200, Phil Sutter wrote:
> The table lookup will be dropped from that function, so remove that
> dependency from audit logging code. Using whatever is in
> nla[NFTA_RULE_TABLE] is sufficient as long as the previous rule info
> filling succeded.

Series applied to nf-next, thanks
