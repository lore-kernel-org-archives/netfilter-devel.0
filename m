Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F75C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 May 2022 13:26:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244576AbiEEN37 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 May 2022 09:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236054AbiEEN36 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 May 2022 09:29:58 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C01547ADC
        for <netfilter-devel@vger.kernel.org>; Thu,  5 May 2022 06:26:19 -0700 (PDT)
Date:   Thu, 5 May 2022 15:26:15 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Phil Sutter <phil@netfilter.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ANNOUNCE] libnetfilter_cttimeout 1.0.1 release
Message-ID: <YnPQd5A92CBRlgAY@salvia>
References: <YnO5/SN2W7IJ9mpM@orbyte.nwl.cc>
 <347p284-s84q-1pqp-27o7-90q1s8926srq@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <347p284-s84q-1pqp-27o7-90q1s8926srq@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 05, 2022 at 03:19:09PM +0200, Jan Engelhardt wrote:
> 
> On Thursday 2022-05-05 13:50, Phil Sutter wrote:
> >
> >        libnetfilter_cttimeout 1.0.1
> >You can download the new release from:
> >
> >https://netfilter.org/projects/libnetfilter_cttimeout/downloads.html#libnetfilter_cttimeout-1.0.1
> 
> It's there alright, but if you go to "download", then to
> libnetfilter_cttimeout, it's not there.
> (this points to https://www.netfilter.org/pub/libnetfilter_cttimeout/ )

Fixed, thanks.
