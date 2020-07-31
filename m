Return-Path: <SRS0=oAJK=BK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32F67C433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 18:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C332208E4
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 18:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387693AbgGaSgm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 Jul 2020 14:36:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37519 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730040AbgGaSgl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Jul 2020 14:36:41 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-6L3hB-IQNxWBi1INu7MN5w-1; Fri, 31 Jul 2020 14:36:36 -0400
X-MC-Unique: 6L3hB-IQNxWBi1INu7MN5w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDC25100AA24;
        Fri, 31 Jul 2020 18:36:34 +0000 (UTC)
Received: from localhost (ovpn-115-201.rdu2.redhat.com [10.10.115.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C2E126E40;
        Fri, 31 Jul 2020 18:36:34 +0000 (UTC)
Date:   Fri, 31 Jul 2020 14:36:33 -0400
From:   Eric Garver <eric@garver.life>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>,
        "Jose M. Guisado Gomez" <guigom@riseup.net>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2 1/1] src: enable output with "nft --echo --json"
 and nftables syntax
Message-ID: <20200731183633.eyobtrbgrmsgv7b7@egarver>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
        "Jose M. Guisado Gomez" <guigom@riseup.net>,
        netfilter-devel@vger.kernel.org
References: <20200730195337.3627-1-guigom@riseup.net>
 <20200731000020.4230-2-guigom@riseup.net>
 <20200731092212.GA1850@salvia>
 <20200731123342.GF13697@orbyte.nwl.cc>
 <20200731125825.GA12545@salvia>
 <20200731134828.GG13697@orbyte.nwl.cc>
 <20200731141742.so3oklljvtuad2cl@egarver>
 <20200731171906.GA15741@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731171906.GA15741@salvia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 31, 2020 at 07:19:06PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Jul 31, 2020 at 10:17:42AM -0400, Eric Garver wrote:
> > On Fri, Jul 31, 2020 at 03:48:28PM +0200, Phil Sutter wrote:
> > > On Fri, Jul 31, 2020 at 02:58:25PM +0200, Pablo Neira Ayuso wrote:
> > > > On Fri, Jul 31, 2020 at 02:33:42PM +0200, Phil Sutter wrote:
> [...]
> > > I'm assuming scripts will work directly with the Python data structures
> > > that are later passed to libnftables as JSON. If they want to change a
> > > rule, e.g. add a statement, it is no use if other statements disappear
> > > or new ones are added by the commit->retrieve action.
> > > 
> > > Maybe Eric can shed some light on how Firewalld uses echo mode and
> > > whether my concerns are relevant or not.
> > 
> > How it stands today is exactly as you described above. firewalld relies
> > on the output (--echo) being in the same order as the input. At the
> > time, and I think still today, this was the _only_ way to reliably get
> > the rule handles. It's mostly due to the fact that input != output.
> > 
> > In the past we discussed allowing a user defined cookie/handle. This
> > would allow applications to perform in a write only manner. They would
> > not need to parse back the JSON since they already know the
> > cookie/handle. IMO, this would be ideal for firewalld's use case.
> 
> The question is: Is this patch breaking anything in firewalld?

I tried v2 and v3. Neither break firewalld.

I think this is because firewalld only relies on the input and output
_order_ being identical. That is, the Nth input json element corresponds
to the Nth output json element.

