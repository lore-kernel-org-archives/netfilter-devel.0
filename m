From: Varsha Rao <rvarsha016@gmail.com>
Subject: Re: [PATCH nft] tests: shell: Add test for IPv4 Mapped IPv6 address.
Date: Sun, 26 Nov 2017 08:07:50 +0530
Message-ID: <CAAFX7JT-qxq8tckDb2UxO5xCGB0ySYhUS6GXK6NHPWLeUS0Kwg@mail.gmail.com>
References: <20171119123432.8894-1-rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:42491 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751923AbdKZCic (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Nov 2017 21:38:32 -0500
Received: by mail-it0-f47.google.com with SMTP id n134so17180038itg.1
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Nov 2017 18:38:31 -0800 (PST)
In-Reply-To: <20171119123432.8894-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Pablo,

On Sun, Nov 19, 2017 at 6:04 PM, Varsha Rao <rvarsha016@gmail.com> wrote:
> This patch adds test case for IPv4 Mapped IPv6 address and renames
> file 0025named_limit_0 to 0026named_limit_0.
>
> Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
> ---
> rename to tests/shell/testcases/sets/0026named_limit_0
> diff --git a/tests/shell/testcases/sets/0027ipv6_maps_ipv4_0 b/tests/shell/testcases/sets/0027ipv6_maps_ipv4_0
> new file mode 100755

There seems to be a small problem with applied patch. It has file mode as 100644
instead of 100755. Should I send a patch for it?

Thanks,
Varsha
