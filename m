Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5672E810A2
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 08:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbjI0IgM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 04:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbjI0Ifp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 04:35:45 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569DC10DB;
        Wed, 27 Sep 2023 01:35:16 -0700 (PDT)
Received: from [78.30.34.192] (port=49434 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qlQ0k-00BBzy-EC; Wed, 27 Sep 2023 10:35:12 +0200
Date:   Wed, 27 Sep 2023 10:35:09 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     joao@overdrivepizza.com
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        rkannoth@marvell.com, wojciech.drewek@intel.com,
        steen.hegenlund@microhip.com, keescook@chromium.org,
        Joao Moreira <joao.moreira@intel.com>
Subject: Re: [PATCH v2 0/2] Prevent potential write out of bounds
Message-ID: <ZRPpPet9tuNh07rx@calendula>
References: <20230927020221.85292-1-joao@overdrivepizza.com>
 <ZRPm2/KsmDmFTOcS@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZRPm2/KsmDmFTOcS@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 27, 2023 at 10:25:03AM +0200, Pablo Neira Ayuso wrote:
> On Tue, Sep 26, 2023 at 07:02:19PM -0700, joao@overdrivepizza.com wrote:
> > From: Joao Moreira <joao.moreira@intel.com>
> > 
> > The function flow_rule_alloc in net/core/flow_offload.c [2] gets an
> > unsigned int num_actions (line 10) and later traverses the actions in
> > the rule (line 24) setting hw.stats to FLOW_ACTION_HW_STATS_DONT_CARE.
> > 
> > Within the same file, the loop in the line 24 compares a signed int
> > (i) to an unsigned int (num_actions), and then uses i as an array
> > index. If an integer overflow happens, then the array within the loop
> > is wrongly indexed, causing a write out of bounds.
> > 
> > After checking with maintainers, it seems that the front-end caps the
> > maximum value of num_action, thus it is not possible to reach the given
> > write out of bounds, yet, still, to prevent disasters it is better to
> > fix the signedness here.
> > 
> > Similarly, also it is also good to ensure that an overflow won't happen
> > in net/netfilter/nf_tables_offload.c's function nft_flow_rule_create by
> > making the variable unsigned and ensuring that it returns an error if
> > its value reaches UINT_MAX.
> > 
> > This issue was observed by the commit author while reviewing a write-up
> > regarding a CVE within the same subsystem [1].
> 
> I keep spinning around this, this is not really an issue.
> 
> No frontend uses this amount of actions.
> 
> Probably cap this to uint16_t because 2^16 actions is more than
> sufficient by now.

Actually, even 2^8 actions is more than enough by now.
