Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5AB7C4167B
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 19:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjKITQC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 14:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjKITQC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 14:16:02 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B793A98
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 11:15:59 -0800 (PST)
Received: from [78.30.43.141] (port=39292 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1r1AVP-00G2Sc-VB; Thu, 09 Nov 2023 20:15:57 +0100
Date:   Thu, 9 Nov 2023 20:15:55 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v2 0/4] [RESENT] remove xfree() and add
 free_const()+nft_gmp_free()
Message-ID: <ZU0v60ai0StX0ktF@calendula>
References: <20231024095820.1068949-1-thaller@redhat.com>
 <ZU0DY9x7h5q1och2@calendula>
 <76fee659f586988888d1805c5a69627dda5c4f03.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <76fee659f586988888d1805c5a69627dda5c4f03.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 09, 2023 at 06:14:56PM +0100, Thomas Haller wrote:
> On Thu, 2023-11-09 at 17:05 +0100, Pablo Neira Ayuso wrote:
[...]
> > I might end up myself using
> > free_const() everywhere not to figure out if it is const or not,
> > because I don't really care.
> 
> That seems not a good practice. Const-correctness may help you to catch
> bugs via unwanted modifications. If constness is unnecessarily cast
> away, it's looses such hints from the compiler.

Why should I care if the pointer is const or not if what I need to
free it?
