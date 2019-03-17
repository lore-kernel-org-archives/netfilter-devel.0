Return-Path: <SRS0=LKNA=RU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93DF1C43381
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 Mar 2019 18:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 695DC20854
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 Mar 2019 18:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbfCQSSe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 17 Mar 2019 14:18:34 -0400
Received: from wp260.webpack.hosteurope.de ([80.237.133.29]:46052 "EHLO
        wp260.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725914AbfCQSSd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 17 Mar 2019 14:18:33 -0400
Received: from p4feaf68d.dip0.t-ipconnect.de ([79.234.246.141] helo=deneb.skynet.aixah.de); authenticated
        by wp260.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1h5aMi-0005YB-4R; Sun, 17 Mar 2019 19:18:32 +0100
Received: by deneb.skynet.aixah.de (Postfix, from userid 1005)
        id 147DAC2D07; Sun, 17 Mar 2019 19:18:30 +0100 (CET)
Date:   Sun, 17 Mar 2019 19:18:30 +0100
From:   Luis Ressel <aranea@aixah.de>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] configure.ac: Clean up AC_ARG_{WITH,ENABLE}
 invocations
Message-ID: <20190317181830.7vsoie54muzgk7rg@deneb.skynet.aixah.de>
Mail-Followup-To: Jan Engelhardt <jengelh@inai.de>,
        netfilter-devel@vger.kernel.org
References: <20190317171912.14194-1-aranea@aixah.de>
 <20190317171912.14194-2-aranea@aixah.de>
 <nycvar.YFH.7.76.1903171856180.12959@n3.vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1903171856180.12959@n3.vanv.qr>
User-Agent: NeoMutt/20180716
X-bounce-key: webpack.hosteurope.de;aranea@aixah.de;1552846713;3ae2461b;
X-HE-SMSGID: 1h5aMi-0005YB-4R
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Mar 17, 2019 at 06:56:55PM +0100, Jan Engelhardt wrote:
> 
> On Sunday 2019-03-17 18:19, Luis Ressel wrote:
> > ])
> >-AC_SUBST(with_libxtables)
> >-AM_CONDITIONAL([BUILD_XTABLES], [test "x$with_libxtables" == xyes])
> >+AM_CONDITIONAL([BUILD_XTABLES], [test "x$with_xtables" == xyes])
> 
> Not sure when this was introduced, by it needs to be a single = after all.

Whoops, I missed that. Thanks for the catch!

Regards,
Luis
