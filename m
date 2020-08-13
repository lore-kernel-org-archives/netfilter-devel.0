Return-Path: <SRS0=kGcq=BX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46781C433E1
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Aug 2020 15:40:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BD5F20829
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Aug 2020 15:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgHMPk3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Aug 2020 11:40:29 -0400
Received: from verein.lst.de ([213.95.11.211]:46768 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgHMPk2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Aug 2020 11:40:28 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E699968C65; Thu, 13 Aug 2020 17:40:26 +0200 (CEST)
Date:   Thu, 13 Aug 2020 17:40:26 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, hch@lst.de,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        syzbot+5accb5c62faa1d346480@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter/ebtables: reject bogus getopt len value
Message-ID: <20200813154026.GA14095@lst.de>
References: <000000000000ece9db05ac4054e8@google.com> <20200813074611.281558-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813074611.281558-1-fw@strlen.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Looks good, sorry:

Reviewed-by: Christoph Hellwig <hch@lst.de>
