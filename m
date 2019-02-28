Return-Path: <SRS0=zt5D=RD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1711BC43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Feb 2019 11:23:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E26DC20857
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Feb 2019 11:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731793AbfB1LXk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Feb 2019 06:23:40 -0500
Received: from mail.us.es ([193.147.175.20]:45188 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbfB1LXk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Feb 2019 06:23:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 34C4F1031F5
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Feb 2019 12:23:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 23370DA797
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Feb 2019 12:23:38 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 22217DA796; Thu, 28 Feb 2019 12:23:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C54ADA867;
        Thu, 28 Feb 2019 12:23:35 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 28 Feb 2019 12:23:35 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 45E5C4265A4C;
        Thu, 28 Feb 2019 12:23:35 +0100 (CET)
Date:   Thu, 28 Feb 2019 12:23:34 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 4/5] json: Fix memleaks in echo support
Message-ID: <20190228112334.3k4igre2tx7oocn4@salvia>
References: <20190226211342.15125-1-phil@nwl.cc>
 <20190226211342.15125-5-phil@nwl.cc>
 <20190227102920.waqyt4kp7e7bc7wo@salvia>
 <20190227111525.GF2478@orbyte.nwl.cc>
 <20190227222926.bfj5p2d4civilbao@salvia>
 <20190228103026.GG2478@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190228103026.GG2478@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Feb 28, 2019 at 11:30:26AM +0100, Phil Sutter wrote:
> On Wed, Feb 27, 2019 at 11:29:26PM +0100, Pablo Neira Ayuso wrote:
> [...]
> > Not related to this patch: IIRC this echo support is not using the
> > nlmsg_seq to correlate the command and the result that we obtain,
> > right? Telling this because this should work with a batch that
> > contains several requests to create rules, then use this sequence
> > number to correlate things the reply with the original rule creation
> > command.
> 
> I think you once suggested that and I promised to look into it. :)
> 
> So I just did and while nlmsg_seq would serve nice to clearly identify
> which command a returned handle belongs to, I don't know how to map the
> command back to the JSON object from which it was created.

If you have a structure that stores commands in a list or such, the
idea would be to store the sequence number in the command object.
You can just keep this in the radar, no need to work on this right now.

Thanks!
