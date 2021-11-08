Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA060C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 13:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83D4F6124D
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 13:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234552AbhKHNf7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 08:35:59 -0500
Received: from devianza.investici.org ([198.167.222.108]:42703 "EHLO
        devianza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235700AbhKHNf7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 08:35:59 -0500
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Nov 2021 08:35:58 EST
Received: from mx2.investici.org (unknown [127.0.0.1])
        by devianza.investici.org (Postfix) with ESMTP id 4HnsHj1Fynz6vGv
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Nov 2021 13:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=boum.org;
        s=stigmate; t=1636377793;
        bh=TADdmBM245ANm6/2PQJ9hOMX/M4lhLDmvo/TNgSS95k=;
        h=Subject:From:To:Date:From;
        b=otyL+ULWRWeDQExRUUji4FvvLY6k9BJ9eSAf0s+oaOjrIkedi8ateTOUbl/AxDBfU
         Z9gRcAXjUp+Bch8iS1kYow5OhrFRnpBYe+SFYE4DhmQjBNcp6KWsq9p2Hki895IpKZ
         PSKC1OQPKucQRLZQMg5/bTspKINdLOMoxGvbKJus=
Received: from [198.167.222.108] (mx2.investici.org [198.167.222.108]) (Authenticated sender: lafleur@boum.org) by localhost (Postfix) with ESMTPSA id 4HnsHj08pKz6vGS
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Nov 2021 13:23:12 +0000 (UTC)
Message-ID: <2b295b8fbb7a176d54536ef8efb08b5ceca1aef5.camel@boum.org>
Subject: libnftnl: guarantee a stable interface between minor updates ?
From:   la Fleur <lafleur@boum.org>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Date:   Mon, 08 Nov 2021 14:23:12 +0100
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

