Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7ABFC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Feb 2022 16:13:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243966AbiBJQN1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Feb 2022 11:13:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239586AbiBJQN0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Feb 2022 11:13:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F3BEB;
        Thu, 10 Feb 2022 08:13:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D909CB82502;
        Thu, 10 Feb 2022 16:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2B2C004E1;
        Thu, 10 Feb 2022 16:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644509604;
        bh=yFSefZtuKQy+rRIhxF1xA6U/rPoybWM9PhFAUBbHG4I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=omKDqNLOK28NXXBpI8y/0QKJdODpuPMxSBXgJitMG6FMucQbGqWziba50lf04oWmO
         NZupU4/tQ5M6BE+zCe13cWEvGoPCHXLlROWv9dbL0YhHb1ScBhKi9GoF5ZAQ8kJBZE
         o4/2JuEIFiq61S/7ttd9ZQj9elCt38NhyCPSYUADGDHJoMlN0tO/ooXJKk2+Lr77pc
         JaFyKR+ZgZuvnM4xEnIjsLsEqtW381pogJQM42X21sosnJ3OoHoz3abs2lq/6Aoznw
         L7l3hRa3GIikd2DIe8CzEO2rywLlJv5slLdehwZDFDCy/TOVBf+iov9aWUaVIrxqaV
         2OzALRYnYl+Aw==
Date:   Thu, 10 Feb 2022 08:13:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        pablo@netfilter.org, kadlec@netfilter.org,
        Florian Westphal <fw@strlen.de>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, alobakin@pm.me,
        paulb@nvidia.com, Kees Cook <keescook@chromium.org>,
        talalahmad@google.com, haokexin@gmail.com, memxor@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH v3 net-next 1/7] net: skb_drop_reason: add document for
 drop reasons
Message-ID: <20220210081322.566488f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CADxym3ZajjCV2EHF6+2xa5ewZuVqxwk6bSqF0KuA+J6sGnShbQ@mail.gmail.com>
References: <20220128073319.1017084-1-imagedong@tencent.com>
        <20220128073319.1017084-2-imagedong@tencent.com>
        <0029e650-3f38-989b-74a3-58c512d63f6b@gmail.com>
        <CADxym3akuxC_Cr07Vzvv+BD55XgMEx7nqU4qW8WHowGR0jeoOQ@mail.gmail.com>
        <20220209211202.7cddd337@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CADxym3ZajjCV2EHF6+2xa5ewZuVqxwk6bSqF0KuA+J6sGnShbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 10 Feb 2022 21:42:14 +0800 Menglong Dong wrote:
> How about introducing a field to 'struct sock' for drop reasons? As sk is
> locked during the packet process in tcp_v4_do_rcv(), this seems to work.

I find adding temporary storage to persistent data structures awkward.
You can put a structure on the stack and pass it thru the call chain,
that's just my subjective preference, tho, others may have better ideas.
