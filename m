Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5114AC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 14:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242235AbhK3OiM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 09:38:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52506 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242222AbhK3OiM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 09:38:12 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-5jPsumc4Oumeh-9dNTjcig-1; Tue, 30 Nov 2021 09:34:46 -0500
X-MC-Unique: 5jPsumc4Oumeh-9dNTjcig-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3933190D35B;
        Tue, 30 Nov 2021 14:34:42 +0000 (UTC)
Received: from localhost (unknown [10.22.33.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 07CE279452;
        Tue, 30 Nov 2021 14:34:41 +0000 (UTC)
Date:   Tue, 30 Nov 2021 09:34:41 -0500
From:   Eric Garver <eric@garver.life>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf] netfilter: nat: force port remap to prevent shadowing
 well-known ports
Message-ID: <YaY2gbreectkdeX3@egarver.remote.csb>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Phil Sutter <phil@nwl.cc>
References: <20211129144218.2677-1-fw@strlen.de>
 <YaU2gndowxjvV+zn@egarver.remote.csb>
 <20211129220254.GA17540@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129220254.GA17540@breakpoint.cc>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Nov 29, 2021 at 11:02:54PM +0100, Florian Westphal wrote:
> Eric Garver <eric@garver.life> wrote:
> > On Mon, Nov 29, 2021 at 03:42:18PM +0100, Florian Westphal wrote:
> > > If destination port is above 32k and source port below 16k
> > > assume this might cause 'port shadowing' where a 'new' inbound
> > > connection matches an existing one, e.g.
> > 
> > How did you arrive at 16k?
> 
> I had to pick some number.  1k is too low since some administrative
> portals (or openvpn for that matter) are on ports above that.
> 
> I wanted to pick something that would not kick in for most cases.
> 16k just seemed like a good compromise, thats all.

Understood. I don't have a real reason to choose anything else.

That being said, there are more things registered in the > 16k range
than I realized.

