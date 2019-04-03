Return-Path: <SRS0=21Bs=SF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 392DEC4360F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 17:51:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 108792084B
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 17:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbfDCRv6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 13:51:58 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:47194 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbfDCRv6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 13:51:58 -0400
Received: from sys.soleta.eu ([212.170.55.40] helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1hBk3H-0001pD-Cl; Wed, 03 Apr 2019 19:51:57 +0200
Date:   Wed, 3 Apr 2019 19:51:54 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org,
        Wenle Chen <solachenclever@hotmail.com>
Subject: Re: [iptables PATCH] extensions: Install symlinks as such
Message-ID: <20190403175154.ltx3z3duuz5q5omz@salvia>
References: <20190322183106.14668-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190322183106.14668-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 22, 2019 at 07:31:06PM +0100, Phil Sutter wrote:
> Fake shared objects which are actually symlinks to others are installed
> using 'install' tool which follows them and therefore installs a copy of
> the file they point at. Fix this by introducing special handling for
> them in install target.

Applied, thanks.
