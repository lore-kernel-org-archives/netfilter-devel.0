Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 162A4CDB47E
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Oct 2023 12:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbjJRMdu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Oct 2023 08:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbjJRMdu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Oct 2023 08:33:50 -0400
Received: from smtp-42af.mail.infomaniak.ch (smtp-42af.mail.infomaniak.ch [84.16.66.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46935A3
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Oct 2023 05:33:48 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4S9VdQ4dmTzMqDh9;
        Wed, 18 Oct 2023 12:33:46 +0000 (UTC)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4S9VdQ1gKtzMppBS;
        Wed, 18 Oct 2023 14:33:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1697632426;
        bh=0vFTHivt8roguCC4mdmTk28ppnSwxwS/6gjbg//7wJo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EtUVbrp+wKXDA6KiFthGUFPjom2SDHlrgQuhNE5bLRN6UkQY4ulR3EhmgRA4ClDxs
         pvqaHZmTquADRNVCrryFEvSm1M/+TKHprHOgFj9u3JpUDGsjYXUN0na7hQOb6LcErV
         i+NPSoBvK75zaAUcXnIFSyYPsW17+WhbtjEIbcbw=
Date:   Wed, 18 Oct 2023 14:33:44 +0200
From:   =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
Subject: Re: [PATCH v13 11/12] samples/landlock: Add network demo
Message-ID: <20231018.ShoMiep0ixei@digikod.net>
References: <20231016015030.1684504-1-konstantin.meskhidze@huawei.com>
 <20231016015030.1684504-12-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231016015030.1684504-12-konstantin.meskhidze@huawei.com>
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Please update the subject to "samples/landlock: Support TCP restrictions"

On Mon, Oct 16, 2023 at 09:50:29AM +0800, Konstantin Meskhidze wrote:
> This commit adds network demo. It's possible to allow a sandboxer to
> bind/connect to a list of particular ports restricting network
> actions to the rest of ports.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> Link: https://lore.kernel.org/r/20230920092641.832134-12-konstantin.meskhidze@huawei.com
> [mic: Define __SANE_USERSPACE_TYPES__ to select int-ll64.h and avoid
> format warnings for PowerPC]

You can remove all this kind of "[mic: ]" comments, I add them when I
merge a patch with additional changes.

> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> ---
> 
> Changes since v12:
> * Defines __SANE_USERSPACE_TYPES__ to avoid warnings for PowerPC.
