Return-Path: <SRS0=BTt+=XF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59AEEC3A5A2
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Sep 2019 13:08:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15DDC20872
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Sep 2019 13:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbfIJNIP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Sep 2019 09:08:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53080 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbfIJNIP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Sep 2019 09:08:15 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 95F5C60AD7;
        Tue, 10 Sep 2019 13:08:14 +0000 (UTC)
Received: from egarver.localdomain (ovpn-123-28.rdu2.redhat.com [10.10.123.28])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BFB0100EBA2;
        Tue, 10 Sep 2019 13:08:13 +0000 (UTC)
Date:   Tue, 10 Sep 2019 09:08:12 -0400
From:   Eric Garver <eric@garver.life>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: mnl: fix --echo buffer size -- again
Message-ID: <20190910130812.5evglcak7tlkdugt@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190909221918.28473-1-fw@strlen.de>
 <20190910085056.bfbgsgvhraatmsuc@salvia>
 <20190910105242.GC2066@breakpoint.cc>
 <20190910112254.isfbdqjfg6aokcm7@salvia>
 <20190910114412.GA22704@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190910114412.GA22704@breakpoint.cc>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Tue, 10 Sep 2019 13:08:15 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 10, 2019 at 01:44:12PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I'd still like to keep setting the receive buffer for the non-echo
> > case, a ruleset with lots of acknowledments (lots of errors) might hit
> > ENOBUFS, I remember that was reproducible.
> > 
> > Probably this? it's based on your patch.
> 
> LGTM, feel free to apply this.

Pablo's version passes all my tests. But so does Florian's version.
Feel free to add my tested-by tag.

Tested-by: Eric Garver <eric@garver.life>
