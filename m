Return-Path: <SRS0=21Bs=SF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B9CC4360F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 17:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E30CB20657
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 17:58:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbfDCR6d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 13:58:33 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:53099 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbfDCR6d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 13:58:33 -0400
Received: from sys.soleta.eu ([212.170.55.40] helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1hBk9e-0001tP-0A; Wed, 03 Apr 2019 19:58:31 +0200
Date:   Wed, 3 Apr 2019 19:58:29 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] parser_json: Rewrite echo support
Message-ID: <20190403175829.o2dlmcqgm45micl5@salvia>
References: <20190402133443.6140-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190402133443.6140-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 02, 2019 at 03:34:43PM +0200, Phil Sutter wrote:
> Instead of guessing which object to update with retrieved handle,
> introduce a list containing struct cmd <-> json_t associations. Upon
> batch commit, allocated cmd objects are assigned a unique netlink
> sequence number. Monitor events contain that number as well, so they may
> be associated to the cmd object which triggered them. Using
> json_cmd_assoc list the event may in turn be associated to the input's
> JSON object which should receive the handle value.
> 
> This also fixes incorrect behaviour if JSON input contained "insert"
> commands.

Applied, thanks Phil!
