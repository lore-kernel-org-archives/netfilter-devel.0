Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66F6FC19F21
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Jul 2022 13:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiG1NYl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Jul 2022 09:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235195AbiG1NYl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Jul 2022 09:24:41 -0400
Received: from smtp-190d.mail.infomaniak.ch (smtp-190d.mail.infomaniak.ch [IPv6:2001:1600:3:17::190d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CBAE53D32
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Jul 2022 06:24:40 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4LtrwN52BQzMqNMF;
        Thu, 28 Jul 2022 15:24:36 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4LtrwN1XcBzlqwwk;
        Thu, 28 Jul 2022 15:24:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1659014676;
        bh=RAweEF+huCI4AjPNTonqz95NxOvYJYl24mF2cUDIipo=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=OPgJqbWri/qJZotQKZQvql1WiQZIiEksauuDKbSxuFE1Qrhe5ONPLebh/8ehusQr2
         815uADrpa9sH6gaMVEJZnO346PhC4t4ApLtI1G1L9ko7tLXmrVKEjSd87A7dICogOz
         RB7yab6zG7n2UHkuhJim4rHAo7jfUyvIzPpXjajE=
Message-ID: <16ce6dc2-6b9c-da02-5737-eb9d26865590@digikod.net>
Date:   Thu, 28 Jul 2022 15:24:35 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        anton.sirazetdinov@huawei.com
References: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
 <20220621082313.3330667-12-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v6 11/17] seltests/landlock: adds tests for bind() hooks
In-Reply-To: <20220621082313.3330667-12-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 21/06/2022 10:23, Konstantin Meskhidze wrote:
> Adds selftests for bind() socket action.
> The first is with no landlock restrictions:
>      - bind without restrictions for ip4;
>      - bind without restrictions for ip6;
> The second ones is with mixed landlock rules:
>      - bind with restrictions for ip4;
>      - bind with restrictions for ip6;
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v5:
> * Splits commit.
> * Adds local address 127.0.0.1.
> * Adds FIXTURE_VARIANT and FIXTURE_VARIANT_ADD
> helpers to support both ip4 and ip6 family tests and
> shorten the code.
> * Adds create_socket_variant() and bind_variant() helpers.
> * Gets rid of reuse_addr variable in create_socket_variant.
> * Formats code with clang-format-14.

It seems that a formatting pass is missing for FIXTURE_VARIANT().
