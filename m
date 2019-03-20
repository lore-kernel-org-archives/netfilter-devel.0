Return-Path: <SRS0=0f1v=RX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEBB8C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 07:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7ACE2184D
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 07:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfCTHcw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Mar 2019 03:32:52 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:35771 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbfCTHcw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Mar 2019 03:32:52 -0400
Received: from 148.160.broadband14.iol.cz ([90.181.160.148] helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1h6ViS-00066B-KR; Wed, 20 Mar 2019 08:32:50 +0100
Date:   Wed, 20 Mar 2019 08:32:48 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: add missing ->release_ops() in
 error path of newrule()
Message-ID: <20190320073248.tafevi56sobhpspa@salvia>
References: <20190319042241.22680-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190319042241.22680-1-ap420073@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 19, 2019 at 01:22:41PM +0900, Taehee Yoo wrote:
> ->release_ops() callback releases resources and this is used in error path.
> If nf_tables_newrule() fails after ->select_ops(), it should release
> resources. but it can not call ->destroy() because that should be called
> after ->init().
> At this point, ->release_ops() should be used for releasing resources.
> 
> Test commands:
>    modprobe -rv xt_tcpudp
>    iptables-nft -I INPUT -m tcp   <-- error command
>    lsmod
> 
> Result:
>    Module                  Size  Used by
>    xt_tcpudp              20480  2      <-- it should be 0

Applied, thanks!
