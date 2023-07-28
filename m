Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D594EC001DC
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jul 2023 03:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbjG1D2S (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jul 2023 23:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjG1D2R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2023 23:28:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A1926B2
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2023 20:28:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B56D561FB1
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jul 2023 03:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF17DC433C9;
        Fri, 28 Jul 2023 03:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690514893;
        bh=NBjgBAVBACpOkwUBa3F+YOvXdcNdxUwGJPkJgXMPyZQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aF79OitFL1etcnggv1KW3Zhz8mOvyiQRlTLEgK/Ykr9ZQqAVCo2LmNLMKQNddQ6AC
         bND8eA7FyPtRmJ0t7wcRcbP9XWECPsYqMj39t8k7cCcu6P20vxI46GoH901NHkq+8/
         VkMBfWH/hOvt6JUzJSU6oSC3m/b/cPzVR+A5UEqQUTsxYcj8Pxfk/UPvA77Z9JRsDJ
         jKP5UQBcdtY8XxfZP6EpCZV3W9OfHPwVCK9/VSefIvRRMIINgTgEhVOnWTjY8lwXWa
         MZjAfzfGgqTAWX551sLG7CzyFv49/eZd0HCzYg+TyYSUNq0n7ErHkK8U32MyRNU8HB
         44s4f8eAgxseg==
Date:   Thu, 27 Jul 2023 20:28:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        <netfilter-devel@vger.kernel.org>, Zhu Wang <wangzhu9@huawei.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next 1/5] nf_conntrack: fix -Wunused-const-variable=
Message-ID: <20230727202811.7b892de5@kernel.org>
In-Reply-To: <20230727133604.8275-2-fw@strlen.de>
References: <20230727133604.8275-1-fw@strlen.de>
        <20230727133604.8275-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 27 Jul 2023 15:35:56 +0200 Florian Westphal wrote:
> When building with W=3D1, the following warning occurs.
>=20
> net/netfilter/nf_conntrack_proto_dccp.c:72:27: warning: =E2=80=98dccp_sta=
te_names=E2=80=99 defined but not used [-Wunused-const-variable=3D]
>  static const char * const dccp_state_names[] =3D {
>=20
> We include dccp_state_names in the macro
> CONFIG_NF_CONNTRACK_PROCFS, since it is only used in the place
> which is included in the macro CONFIG_NF_CONNTRACK_PROCFS.

FTR I can't say I see this with the versions of gcc / clang I have :S

> Fixes: 2bc780499aa3 ("[NETFILTER]: nf_conntrack: add DCCP protocol suppor=
t")

Nor that it's worth a Fixes tag?
