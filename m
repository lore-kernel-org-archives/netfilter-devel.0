Return-Path: <SRS0=21Bs=SF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14997C4360F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 17:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA3C42084B
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 17:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbfDCRsx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 13:48:53 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:43829 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbfDCRsx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 13:48:53 -0400
Received: from sys.soleta.eu ([212.170.55.40] helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1hBk0I-0001e5-Gb; Wed, 03 Apr 2019 19:48:52 +0200
Date:   Wed, 3 Apr 2019 19:48:49 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [ebtables PATCH 0/3] Misc items found in Fedora package
Message-ID: <20190403174849.ucvzxroendyyixrk@salvia>
References: <20190319190938.20751-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190319190938.20751-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 19, 2019 at 08:09:35PM +0100, Phil Sutter wrote:
> Patch 1 is something I discovered when dealing with the rest. Patches 2
> and 3 stem from Fedora package. Actually, I wrote patch 2 from scratch
> (to avoid patching Makefile) and slightly adjusted patch 3 so it
> compiles with current sources.

Series applied, thanks Phil.
