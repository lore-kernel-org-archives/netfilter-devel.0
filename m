Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B7EFC7618F
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 19:02:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6107720665
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 19:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbfGPTC0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 15:02:26 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:51176 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728137AbfGPTC0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 15:02:26 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hnSiW-0006KG-Kw; Tue, 16 Jul 2019 21:02:24 +0200
Date:   Tue, 16 Jul 2019 21:02:24 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: json_cmd_assoc and cmd
Message-ID: <20190716190224.GB31548@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190716183101.pev5gcmk3agqwpsm@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716183101.pev5gcmk3agqwpsm@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, Jul 16, 2019 at 08:31:01PM +0200, Pablo Neira Ayuso wrote:
> Why json_cmd_assoc is not placed in struct cmd instead? I mean, just
> store the json_t *json in cmd?

The global list (json_cmd_list) is used in json_events_cb(). Unless I
miss something, the cmd list is not available from struct
netlink_mon_handler.

Maybe I could move struct cmds list head into struct nft_ctx?

Thanks, Phil
