Return-Path: <SRS0=OoGW=RW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4E96C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 19:44:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1AEB2085A
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 19:44:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbfCSToP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 15:44:15 -0400
Received: from a3.inai.de ([88.198.85.195]:56744 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbfCSToO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 15:44:14 -0400
Received: by a3.inai.de (Postfix, from userid 25121)
        id 7AB723BACCC3; Tue, 19 Mar 2019 20:44:12 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 719C13BB8A95;
        Tue, 19 Mar 2019 20:44:12 +0100 (CET)
Date:   Tue, 19 Mar 2019 20:44:12 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Phil Sutter <phil@nwl.cc>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Thomas Graf <tgraf@infradead.org>,
        James Czyzak <czyzak2@linux.vnet.ibm.com>,
        Tom Callaway <spot@fedoraproject.org>,
        Netfilter Developer Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: Re: [ebtables PATCH 3/3] extensions: Add AUDIT target
In-Reply-To: <20190319190938.20751-4-phil@nwl.cc>
Message-ID: <nycvar.YFH.7.76.1903192026550.7166@n3.vanv.qr>
References: <20190319190938.20751-1-phil@nwl.cc> <20190319190938.20751-4-phil@nwl.cc>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tuesday 2019-03-19 20:09, Phil Sutter wrote:

>This is a barn find from Fedora package, actually spooking around in
>various places in the internet. No idea who wrote it, but it seems to be
>used. So add it for the time being.

Not sure, but I added some people in the Cc that may know more (and the 
hope is that the ibm address still delivers).


 * xt_AUDIT made its appearance around January 2011 
   https://lwn.net/Articles/423402/ (tgraf@)

 * "ebtables --audit-type" made an appearence in the audit-test code 
   repository https://sourceforge.net/p/audit-test/code/ref/master/ in 
   June 2011 (czyzak@). This means that ebt_audit existed in some form
   at that time already.

 * Fedora ebtables (only) gained the patch 2013-March-21 (spot@)
