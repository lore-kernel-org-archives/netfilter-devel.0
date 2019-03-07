Return-Path: <SRS0=ah1+=RK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D112AC43381
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Mar 2019 09:30:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49CEE20835
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Mar 2019 09:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbfCGJaz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Mar 2019 04:30:55 -0500
Received: from a3.inai.de ([88.198.85.195]:35278 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbfCGJaz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Mar 2019 04:30:55 -0500
Received: by a3.inai.de (Postfix, from userid 25121)
        id 12E503BB8963; Thu,  7 Mar 2019 10:30:53 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 0621A3BB6EF6;
        Thu,  7 Mar 2019 10:30:53 +0100 (CET)
Date:   Thu, 7 Mar 2019 10:30:52 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     PGNet Dev <pgnet.dev@gmail.com>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: xtables-addons build fail with linux 5.0: "error: implicit
 declaration of function 'do_gettimeofday'; did you mean
 'do_settimeofday64'?"
In-Reply-To: <24a74393-c0ef-72ae-88df-81734c27f699@gmail.com>
Message-ID: <nycvar.YFH.7.76.1903071030470.6336@n3.vanv.qr>
References: <c4382224-6bfa-3604-28c4-4ab1ea61e943@gmail.com> <7604c2e7-e477-028f-d0cd-2b57a56c08b1@gmail.com> <24a74393-c0ef-72ae-88df-81734c27f699@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Monday 2019-03-04 21:10, PGNet Dev wrote:

>this patch,
>
>  https://bugzilla.opensuse.org/show_bug.cgi?id=1127790#c3

Applied.
