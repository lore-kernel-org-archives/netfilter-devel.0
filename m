Return-Path: <SRS0=TR/Z=U2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A2BFC48BD6
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 12:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 093DE2084B
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 12:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfF0Mce (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:32:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51682 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726375AbfF0Mce (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 08:32:34 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BF941C050918;
        Thu, 27 Jun 2019 12:32:28 +0000 (UTC)
Received: from egarver.localdomain (ovpn-120-117.rdu2.redhat.com [10.10.120.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A0375C25D;
        Thu, 27 Jun 2019 12:32:24 +0000 (UTC)
Date:   Thu, 27 Jun 2019 08:32:23 -0400
From:   Eric Garver <eric@garver.life>
To:     shekhar sharma <shekhar250198@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v9]tests: py: fix pyhton3
Message-ID: <20190627123223.viv3p7kn3lq7nxfi@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        shekhar sharma <shekhar250198@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list <netfilter-devel@vger.kernel.org>
References: <20190619175741.22411-1-shekhar250198@gmail.com>
 <20190620143731.jfnty672zi7rcxgs@salvia>
 <CAN9XX2r6FK6gn7X7i6krWOwaFTiad5OVQybT+qMYbuW1iFY1qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN9XX2r6FK6gn7X7i6krWOwaFTiad5OVQybT+qMYbuW1iFY1qQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 27 Jun 2019 12:32:33 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 20, 2019 at 11:08:18PM +0530, shekhar sharma wrote:
> On Thu, Jun 20, 2019 at 8:07 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Wed, Jun 19, 2019 at 11:27:41PM +0530, Shekhar Sharma wrote:
> > > This patch changes the file to run on both python2 and python3.
> > >
> > > The tempfile module has been imported and used.
> > > Although the previous replacement of cmp() by eric works,
> > > I have replaced cmp(a,b) by ((a>b)-(a<b)) which works correctly.
> >
> > Any reason not to use Eric's approach? This ((a>b)-(a<b)) is
> > confusing.
> 
> No, Eric's approach is also working nicely. I read on a website
> that cmp(a,b) of python2 can be replaced by ((a>b)-(a<b)) in python3.

This is true, but as Pablo stated it can be confusing. For this function
we only care if the sets are equivalent so I simplified it.

If you agree, the please drop this change from your next revision and
Pablo can take my patch.
