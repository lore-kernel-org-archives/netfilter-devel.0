Return-Path: <SRS0=5Ubq=RV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 792FDC10F00
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 15:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5451220863
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 15:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbfCRPWX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Mar 2019 11:22:23 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:58618 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbfCRPWX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Mar 2019 11:22:23 -0400
X-Greylist: delayed 1272 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Mar 2019 11:22:23 EDT
Received: from [195.39.71.253] (helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1h5u5i-0002hn-Rj; Mon, 18 Mar 2019 16:22:19 +0100
Date:   Mon, 18 Mar 2019 16:22:18 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, fw@strlen.de
Subject: Re: [PATCH net] netfilter: bridge: set skb transport_header before
 entering NF_INET_PRE_ROUTING
Message-ID: <20190318152218.hqy4oji6wo6cmqux@salvia>
References: <35febf82503a4126b5ba28b02a0ca6e8f37a2765.1552466009.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35febf82503a4126b5ba28b02a0ca6e8f37a2765.1552466009.git.lucien.xin@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 13, 2019 at 04:33:29PM +0800, Xin Long wrote:
> Since Commit 21d1196a35f5 ("ipv4: set transport header earlier"),
> skb->transport_header has been always set before entering INET
> netfilter. This patch is to set skb->transport_header for bridge
> before entering INET netfilter by bridge-nf-call-iptables.
> 
> It also fixes an issue that sctp_error() couldn't compute a right
> csum due to unset skb->transport_header.

Applied, thanks.
