Return-Path: <SRS0=9u1R=UN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7347BC31E4B
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jun 2019 12:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49DC4208CA
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jun 2019 12:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbfFNMye (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Jun 2019 08:54:34 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:53412 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbfFNMye (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Jun 2019 08:54:34 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hbliy-0003R3-Cw; Fri, 14 Jun 2019 14:54:32 +0200
Date:   Fri, 14 Jun 2019 14:54:32 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nft,v2] cache: do not populate the cache in case of flush
 ruleset command
Message-ID: <20190614125432.GO31548@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20190614123630.17341-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614123630.17341-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Fri, Jun 14, 2019 at 02:36:30PM +0200, Pablo Neira Ayuso wrote:
> __CMD_FLUSH_RULESET is a dummy definition that used to skip the netlink
> dump to populate the cache. This patch is a workaround until we have a
> better infrastructure to track the state of the cache objects.

I assumed the problem wouldn't exist anymore since we're populating the
cache just once. Can you maybe elaborate a bit on the problem you're
trying to solve with that workaround?

Cheers, Phil
