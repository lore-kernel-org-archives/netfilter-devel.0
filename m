Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A81A8C43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 15:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7705E206E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 15:04:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AP8jW5Fm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfDZPEG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 11:04:06 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34106 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbfDZPEF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 11:04:05 -0400
Received: by mail-pl1-f194.google.com with SMTP id d5so1128613plr.1;
        Fri, 26 Apr 2019 08:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fb/xBqIG7b3xmw7+ysl/9XCImagWzKQtx156l6S5SYg=;
        b=AP8jW5FmLfDgm7UcdcSI+8lNkxR4pzA9/AtIxYl5vYBwIhLmIsWar1eH/LgsEAP3R2
         Dxw80XeDlIQFxbDJfEQa4XGeO3mYNWd35fAjvrjcWnNV4aYtUlQmkmfnAXHwuEIoOFpq
         4l39U0oixhC1jWO+8ZlJeVTv3+0TiKKv7CKxyxRELphdLm0Ztg+jxMUBBaWf/PRtpt3q
         /Bf3dqfOJpan708jC8L0TvnlgSiCea8WGaHhp56zwfmFNOjYkUVZ7i/Vfi09qpT9K04C
         FTyQGUDqX9pHi+AO/7D2rS+ILUKHWySN5bz6mQ9HW7f/27vKe+xtquVSNDaPmqjhD72M
         aHDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fb/xBqIG7b3xmw7+ysl/9XCImagWzKQtx156l6S5SYg=;
        b=nl/jzzrXGfwbPBQWpO4gK9WMDqH858fa0f0u14A8tvNH/RczTY0MAMKK1vCfzXyHnb
         zoCiax+L9ABDhx6dDJlg4i/GKjLRid2SbviYiAY+auY5kcvVGk86HORE/fuag3dT2RPr
         RC77+WBJBMx8VmPTJ/vqIkdRJv6TthpMewUpHHonINAMDsjk/PN8qj9MzDlTy26sqlim
         dKZkGChpF0+q7MzMAGsoEijZ35PwcgpwYZTJhAfMO3t6PupE2wPN6dzZAFjlFg/wg6e8
         +al7Y6NVC5gCD/6CVySiGs8xF6v8HJ9n9pXa74D1toqeDYQ031BTBb2JZ32Ixaiz7p3Q
         KD4A==
X-Gm-Message-State: APjAAAXyEpsmtUT+wC17T9+9j92dBHBoRrwxxMeUDNV4LFT3cPJx4zwZ
        2KfgCPzp5QA/zIQOiZXkEamuqC5v
X-Google-Smtp-Source: APXvYqywhygjVlJ5536G2sYrAtsETj76mRLhLOKmGp6WSJCCwtmfwDI7ZLQpH1wj1gED1MiEN1wakg==
X-Received: by 2002:a17:902:5a3:: with SMTP id f32mr43702487plf.82.1556291043233;
        Fri, 26 Apr 2019 08:04:03 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:c824:60cf:2bea:8fbc? ([2601:282:800:fd80:c824:60cf:2bea:8fbc])
        by smtp.googlemail.com with ESMTPSA id x66sm61093803pfb.78.2019.04.26.08.04.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Apr 2019 08:04:01 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] netlink: make nla_nest_start() add
 NLA_F_NESTED flag
To:     Michal Kubecek <mkubecek@suse.cz>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1556269635.git.mkubecek@suse.cz>
 <5278b013a953d4fb2e7944fc810f783d70ea52a5.1556269635.git.mkubecek@suse.cz>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <33d772e5-a2f4-c9a1-11df-27fa7baf8625@gmail.com>
Date:   Fri, 26 Apr 2019 09:03:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <5278b013a953d4fb2e7944fc810f783d70ea52a5.1556269635.git.mkubecek@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 4/26/19 3:13 AM, Michal Kubecek wrote:
> Even if the NLA_F_NESTED flag was introduced more than 11 years ago, most
> netlink based interfaces (including recently added ones) are still not
> setting it in kernel generated messages. Without the flag, message parsers
> not aware of attribute semantics (e.g. wireshark dissector or libmnl's
> mnl_nlmsg_fprintf()) cannot recognize nested attributes and won't display
> the structure of their contents.
> 
> Unfortunately we cannot just add the flag everywhere as there may be
> userspace applications which check nlattr::nla_type directly rather than
> through a helper masking out the flags. Therefore the patch renames
> nla_nest_start() to nla_nest_start_noflag() and introduces nla_nest_start()
> as a wrapper adding NLA_F_NESTED. The calls which add NLA_F_NESTED manually
> are rewritten to use nla_nest_start().
> 
> Except for changes in include/net/netlink.h, the patch was generated using
> this semantic patch:
> 
> @@ expression E1, E2; @@
> -nla_nest_start(E1, E2)
> +nla_nest_start_noflag(E1, E2)
> 
> @@ expression E1, E2; @@
> -nla_nest_start_noflag(E1, E2 | NLA_F_NESTED)
> +nla_nest_start(E1, E2)
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> ---


Acked-by: David Ahern <dsahern@gmail.com>
