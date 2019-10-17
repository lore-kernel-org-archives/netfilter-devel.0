Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2768FFA372A
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 11:34:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03D0420659
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 11:34:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406038AbfJQLeO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 07:34:14 -0400
Received: from correo.us.es ([193.147.175.20]:48962 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405275AbfJQLeO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 07:34:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 260E4C1A1F
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 13:34:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1754EDA4CA
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 13:34:10 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0CC9CDA840; Thu, 17 Oct 2019 13:34:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27226A7EE5;
        Thu, 17 Oct 2019 13:34:08 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 17 Oct 2019 13:34:08 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 060034251480;
        Thu, 17 Oct 2019 13:34:07 +0200 (CEST)
Date:   Thu, 17 Oct 2019 13:34:10 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 4/4] rule: Fix for single line ct timeout printing
Message-ID: <20191017113410.bjgueemfs3htoiqh@salvia>
References: <20191016230322.24432-1-phil@nwl.cc>
 <20191016230322.24432-5-phil@nwl.cc>
 <20191017111437.6rhllpyuw3wbti56@salvia>
 <20191017112910.GK12661@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017112910.GK12661@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 17, 2019 at 01:29:10PM +0200, Phil Sutter wrote:
> On Thu, Oct 17, 2019 at 01:14:37PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Oct 17, 2019 at 01:03:22AM +0200, Phil Sutter wrote:
> > > Commit 43ae7a48ae3de ("rule: do not print semicolon in ct timeout")
> > > removed an extra semicolon at end of line, but thereby broke single line
> > > output. The correct fix is to use opts->stmt_separator which holds
> > > either newline or semicolon chars depending on output mode.
> > 
> > What output mode this breaks? It looks indeed like I overlook
> > something while fixing up this.
> 
> It breaks syntax of monitor and echo output. We don't propagate it, but
> the goal always has been for those to print syntactically correct
> commands.
> 
> The concrete test case in tests/monitor/testcases/object.t is:
> 
> | add ct timeout ip t ctt { protocol udp; l3proto ip; policy = { unreplied : 15, replied : 12 }; }
> 
> Omitting the semicolon before 'l3proto' is illegal syntax.

Ah, the echo mode indeed. LGTM. Thanks for explaining.
