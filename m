Return-Path: <SRS0=21Bs=SF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4706FC4360F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 17:53:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A60E2084B
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 17:53:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfDCRxZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 13:53:25 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:34938 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbfDCRxZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 13:53:25 -0400
Received: from sys.soleta.eu ([212.170.55.40] helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1hBk4g-0001qE-Ku; Wed, 03 Apr 2019 19:53:24 +0200
Date:   Wed, 3 Apr 2019 19:53:22 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] man: iptables-save: Add note about module
 autoloading
Message-ID: <20190403175322.yg5ge54rhyu3ywr4@salvia>
References: <20190326180343.4253-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190326180343.4253-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 26, 2019 at 07:03:43PM +0100, Phil Sutter wrote:
> Using '-t' parameter in iptables-save might lead to kernel module
> loading, just like with iptables itself. Copy the hint from iptables.8
> to inform users.

Applied, thanks Phil.
