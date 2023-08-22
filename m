Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C07C8EE4993
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Aug 2023 16:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235129AbjHVQG1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Aug 2023 12:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234828AbjHVQG0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2023 12:06:26 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B3210F
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2023 09:06:25 -0700 (PDT)
Received: from [78.30.34.192] (port=54896 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qYTtc-000xx8-Sb; Tue, 22 Aug 2023 18:06:23 +0200
Date:   Tue, 22 Aug 2023 18:06:20 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH 2/2] meta: use reentrant localtime_r()/gmtime_r()
 functions
Message-ID: <ZOTc/MhL3Y+abhFX@calendula>
References: <20230822081318.1370371-1-thaller@redhat.com>
 <20230822081318.1370371-2-thaller@redhat.com>
 <ZOR3za+Z+1X0VnIo@calendula>
 <f5680cd01051242a87f768f5770b062c199971b1.camel@redhat.com>
 <ba3ff8dcecbd37a3e59c30dc26fd4e8fc6734352.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ba3ff8dcecbd37a3e59c30dc26fd4e8fc6734352.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 22, 2023 at 05:15:14PM +0200, Thomas Haller wrote:
> On Tue, 2023-08-22 at 13:39 +0200, Thomas Haller wrote:
> > On Tue, 2023-08-22 at 10:54 +0200, Pablo Neira Ayuso wrote:
> > 
> > 
> > nftables calls localtime_r() from print/parse functions. Presumably,
> > we
> > will print/parse several timestamps during a larger operation, it
> > would
> > be odd to change/reload the timezone in between or to meaningfully
> > support that.
> > 
> > 
> > I think it is all good, nothing to change. Just to be aware of.
> > 
> 
> Thinking some more, the "problem" is that when we parse a larger data,
> then multiple subfields are parsed. Thereby we call "time()" and
> "localtime()" multiple times. The time() keeps ticking, and time and tz
> can be reset at any moment -- so we see different time/tz, in the
> middle of parsing the larger set of data.
> 
> What IMO should happen, is that for one parse operation, we call such
> operations at most once, and cache them in `struct netlink_parse_ctx`.
>
> Is that considered a problem to be solved? Seems simple. Would you
> accept a patch for that?

Caching this information in the context should be fine, and it might
speed up things for a large batch? How complicate will the update look
like?
