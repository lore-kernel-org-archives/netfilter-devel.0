Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B01E5C43334
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Jul 2022 22:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbiGLWbT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Jul 2022 18:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbiGLWbS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Jul 2022 18:31:18 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708B3C594D
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Jul 2022 15:31:17 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1oBOPR-0005wR-Rh; Wed, 13 Jul 2022 00:31:13 +0200
Date:   Wed, 13 Jul 2022 00:31:13 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Yuxuan Luo <luoyuxuan.carl@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de,
        marcelo.leitner@gmail.com, lucien.xin@gmail.com,
        pablo@netfilter.org, Yuxuan Luo <yuluo@redhat.com>
Subject: Re: [IPTABLES][PATCHv3] xt_sctp: support a couple of new chunk types
Message-ID: <Ys32MQzY+u9jcas3@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Yuxuan Luo <luoyuxuan.carl@gmail.com>,
        netfilter-devel@vger.kernel.org, fw@strlen.de,
        marcelo.leitner@gmail.com, lucien.xin@gmail.com,
        pablo@netfilter.org, Yuxuan Luo <yuluo@redhat.com>
References: <20220711161237.522258-1-yuluo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711161237.522258-1-yuluo@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 11, 2022 at 12:12:38PM -0400, Yuxuan Luo wrote:
> There are new chunks added in Linux SCTP not being traced by iptables.
> 
> This patch introduces the following chunks for tracing:
> I_DATA, I_FORWARD_TSN (RFC8260), RE_CONFIG(RFC6525) and PAD(RFC4820)
> 
> Signed-off-by: Yuxuan Luo <luoyuxuan.carl@gmail.com>

Applied after fixing libxt_sctp.txlate. Thanks!
