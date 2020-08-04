Return-Path: <SRS0=6lPY=BO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E11BC433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 12:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 153552075A
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 12:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgHDM5s (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Aug 2020 08:57:48 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49442 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725856AbgHDM5s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Aug 2020 08:57:48 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-k88_szJdNpe3G8kI4aUz9A-1; Tue, 04 Aug 2020 08:57:40 -0400
X-MC-Unique: k88_szJdNpe3G8kI4aUz9A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 047C51DE0;
        Tue,  4 Aug 2020 12:57:39 +0000 (UTC)
Received: from localhost (ovpn-115-201.rdu2.redhat.com [10.10.115.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C46137178B;
        Tue,  4 Aug 2020 12:57:37 +0000 (UTC)
Date:   Tue, 4 Aug 2020 08:57:36 -0400
From:   Eric Garver <eric@garver.life>
To:     "Jose M. Guisado Gomez" <guigom@riseup.net>
Cc:     netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc
Subject: Re: [PATCH nft v4] src: enable json echo output when reading native
 syntax
Message-ID: <20200804125736.tsuz36h3wuycnjsf@egarver>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        "Jose M. Guisado Gomez" <guigom@riseup.net>,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc
References: <20200731104944.21384-1-guigom@riseup.net>
 <20200804103846.58872-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804103846.58872-1-guigom@riseup.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 04, 2020 at 12:38:46PM +0200, Jose M. Guisado Gomez wrote:
> This patch fixes a bug in which nft did not print any output when
> specifying --echo and --json and reading nft native syntax.
> 
> This patch respects behavior when input is json, in which the output
> would be the identical input plus the handles.
> 
> Adds a json_echo member inside struct nft_ctx to build and store the json object
> containing the json command objects, the object is built using a mock
> monitor to reuse monitor json code. This json object is only used when
> we are sure we have not read json from input.
> 
> Fixes: https://bugzilla.netfilter.org/show_bug.cgi?id=1446
> 
> Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
> ---
> v4 respects previous behavior for json echo when reading json input too

With this version all firewalld tests pass. Thanks!

Tested-by: Eric Garver <eric@garver.life>

