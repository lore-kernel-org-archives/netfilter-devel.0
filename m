Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39B97C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 13:23:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20D416120D
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 13:23:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239917AbhKHN0a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 08:26:30 -0500
Received: from latitanza.investici.org ([82.94.249.234]:64433 "EHLO
        latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239916AbhKHN03 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 08:26:29 -0500
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Nov 2021 08:26:29 EST
Received: from mx3.investici.org (unknown [127.0.0.1])
        by latitanza.investici.org (Postfix) with ESMTP id 4Hns9P19hWzGpGQ
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Nov 2021 13:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=boum.org;
        s=stigmate; t=1636377465;
        bh=TADdmBM245ANm6/2PQJ9hOMX/M4lhLDmvo/TNgSS95k=;
        h=Subject:From:To:Date:From;
        b=NOVUrBvh9vOdEJsUQf4MtRm97ivYhkKhSyqwt3igeqV+2FS7ZPxrM5yi1GBLDs7EE
         wLMtCeH+1KNDkhZU+GdVbRhYiPwx1RBe74Xq6HsfksCuHdj87JT8/ZF2xGeOptCrS8
         8qrn41TmiSlIIF/setBfKRSz9SY0iI8fpdVSZvi0=
Received: from [82.94.249.234] (mx3.investici.org [82.94.249.234]) (Authenticated sender: lafleur@boum.org) by localhost (Postfix) with ESMTPSA id 4Hns9P0PM0zGp59
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Nov 2021 13:17:45 +0000 (UTC)
Message-ID: <5c9dd5052404e0edd6bf418939bacbe26a3d27d6.camel@boum.org>
Subject: libnftnl: guarantee a stable interface between minor updates ?
From:   la Fleur <lafleur@boum.org>
To:     netfilter-devel@vger.kernel.org
Date:   Mon, 08 Nov 2021 14:17:44 +0100
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello !

We have been working on a rust library linked to libnftnl, called
rustables. We derived our work from the libnftnl-rs crate, and
automated the linking process in a build script. We now happily support
versions from 1.1.6 to 1.2.0 .

Is there a semantic versioning strategy inside libnftnl ? That would
really simplify maintenance on our side if we knew the public interface
won't change between minor versions, for example.

Perhaps this information is already somewhere on the netfilter site. I
couldn't find it though ; I scrolled through documentation, FAQs, and
some Stack Overflow questions. Did I miss something ?


Thanks for the long time great work anyway !

