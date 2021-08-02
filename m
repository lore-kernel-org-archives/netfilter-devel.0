Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B82C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 15:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16BF3610A8
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 15:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbhHBPcb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Aug 2021 11:32:31 -0400
Received: from mail.netfilter.org ([217.70.188.207]:50242 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235044AbhHBPc2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 11:32:28 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id AF4BA60038;
        Mon,  2 Aug 2021 17:31:42 +0200 (CEST)
Date:   Mon, 2 Aug 2021 17:32:11 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] ebtables: Dump atomic waste
Message-ID: <20210802153211.GA29822@salvia>
References: <20210730103715.20501-1-phil@nwl.cc>
 <20210802090404.GA1252@salvia>
 <20210802110555.GW3673@orbyte.nwl.cc>
 <20210802115127.GA29324@salvia>
 <20210802115902.GA29377@salvia>
 <20210802115930.GA29440@salvia>
 <20210802125448.GX3673@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210802125448.GX3673@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 02, 2021 at 02:54:48PM +0200, Phil Sutter wrote:
> On Mon, Aug 02, 2021 at 01:59:30PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Aug 02, 2021 at 01:59:02PM +0200, Pablo Neira Ayuso wrote:
> > > offlist
> > 
> > actually not :)
> 
> :D
> 
> The file is written by store_table_in_file() in communication.c, writing
> a struct ebt_replace plus a number of struct ebt_entries. At this point
> I stopped, assuming that translating back and forth would involve too
> much legacy cruft.

Hm, so it looks like a memory dump of the ruleset blob representation
into a file.
