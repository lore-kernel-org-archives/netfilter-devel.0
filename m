Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70DD6C43334
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Jul 2022 09:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbiGVJCW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Jul 2022 05:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbiGVJCW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Jul 2022 05:02:22 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 341E37D1F1;
        Fri, 22 Jul 2022 02:02:21 -0700 (PDT)
Date:   Fri, 22 Jul 2022 11:02:16 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH bpf-next v7 07/13] net: netfilter: Add kfuncs to allocate
 and insert CT
Message-ID: <YtpnmI1oPOQRv3j3@salvia>
References: <20220721134245.2450-1-memxor@gmail.com>
 <20220721134245.2450-8-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220721134245.2450-8-memxor@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Jul 21, 2022 at 03:42:39PM +0200, Kumar Kartikeya Dwivedi wrote:
> diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
> index 37866c8386e2..83a60c684e6c 100644
> --- a/include/net/netfilter/nf_conntrack_core.h
> +++ b/include/net/netfilter/nf_conntrack_core.h
> @@ -84,4 +84,19 @@ void nf_conntrack_lock(spinlock_t *lock);
>  
>  extern spinlock_t nf_conntrack_expect_lock;
>  
> +/* ctnetlink code shared by both ctnetlink and nf_conntrack_bpf */
> +
> +#if (IS_BUILTIN(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
> +    (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES) || \
> +    IS_ENABLED(CONFIG_NF_CT_NETLINK))

There must be a better way to do this without ifdef pollution?

Could you fix this?
