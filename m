Return-Path: <SRS0=0f1v=RX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B60DEC43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 07:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D7AC2184E
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 07:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfCTHWu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Mar 2019 03:22:50 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:57727 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbfCTHWu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Mar 2019 03:22:50 -0400
Received: from 148.160.broadband14.iol.cz ([90.181.160.148] helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1h6VYk-0005Zm-Rz; Wed, 20 Mar 2019 08:22:48 +0100
Date:   Wed, 20 Mar 2019 08:22:46 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Brian Haley <bhaley@redhat.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack-tools] Allow protocol number zero
Message-ID: <20190320072246.kzyb6hckikujpnsv@salvia>
References: <20190319195655.14200-1-bhaley@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190319195655.14200-1-bhaley@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 19, 2019 at 03:56:55PM -0400, Brian Haley wrote:
> /etc/protocols defines protocol zero as 'ip' for IPv4, and
> 'hopopt' for IPv6, which can be used with conntrack as '-p ip'
> or '-p hopopt'.  However it's equivalent, '-p 0' is considered
> unsupported.  Change the range check in findproto() to allow
> zero as well.

Applied, thanks.
