Return-Path: <SRS0=5Ubq=RV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7566BC43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 15:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50AD82085A
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 15:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbfCRPT6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Mar 2019 11:19:58 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:37591 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726868AbfCRPT6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Mar 2019 11:19:58 -0400
Received: from [195.39.71.253] (helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1h5u3P-0002fr-G3; Mon, 18 Mar 2019 16:19:57 +0100
Date:   Mon, 18 Mar 2019 16:19:54 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Alin Nastac <alin.nastac@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        =?iso-8859-1?Q?M=E1t=E9?= Eckl <ecklm94@gmail.com>
Subject: Re: [PATCH] netfilter: nf_conntrack_sip: remove direct dependency on
 IPv6
Message-ID: <20190318151954.rbmecgkstrqa3g4t@salvia>
References: <1552321122-23626-1-git-send-email-alin.nastac@technicolor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1552321122-23626-1-git-send-email-alin.nastac@technicolor.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Mar 11, 2019 at 05:18:42PM +0100, Alin Nastac wrote:
> From: Alin Nastac <alin.nastac@gmail.com>
> 
> Previous implementation was not usable with CONFIG_IPV6=m.

Applied, thanks.
