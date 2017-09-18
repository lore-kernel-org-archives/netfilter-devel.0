From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH v2 2/2] extensions: xt_bpf: get the pinned ebpf object
 when match is initialized
Date: Mon, 18 Sep 2017 12:22:25 -0400
Message-ID: <CA+FuTSf9SFcgJm7iOCcLUCHMGOwD=-CgFourPt8krCnweWLq7g@mail.gmail.com>
References: <20170917112031.8644-1-shmulik@nsof.io> <20170917112031.8644-3-shmulik@nsof.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>, rbk@nsof.io,
        Rafael Buchbinder <rafi@rbk.ms>
To: Shmulik Ladkani <shmulik@nsof.io>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36410 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752555AbdIRQXA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2017 12:23:00 -0400
Received: by mail-wm0-f67.google.com with SMTP id r136so1398022wmf.3
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2017 09:22:59 -0700 (PDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com. [74.125.82.46])
        by smtp.gmail.com with ESMTPSA id l32sm4093399ede.13.2017.09.18.09.22.57
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Sep 2017 09:22:57 -0700 (PDT)
Received: by mail-wm0-f46.google.com with SMTP id v142so4209715wmv.5
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2017 09:22:57 -0700 (PDT)
In-Reply-To: <20170917112031.8644-3-shmulik@nsof.io>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 17, 2017 at 7:20 AM, Shmulik Ladkani <shmulik@nsof.io> wrote:
> From: Rafael Buchbinder <rafi@rbk.ms>
>
> From: Rafael Buchbinder <rafi@rbk.ms>
>
> xt_bpf_info_v1 structure requires an open file descriptor to create an
> eBPF match. This file descriptor is checked on every replace. However,
> as this file descriptor is valid only for the iptables invocation which
> loads the eBPF for the first time, all subsequent iptables invocations
> fail in bpf_mt_check (kernel) function.
>
> This commit fixes handling of pinned ebpf objects.
>
> The file descriptor saved in xt_bpf_info_v1 structure is being re-open
> in tc_init_fixup which is invoked immediately after tc_init.
>
> Signed-off-by: Rafael Buchbinder <rafi@rbk.ms>
> Signed-off-by: Shmulik Ladkani <shmulik@nsof.io>

Thanks a lot for fixing this.

Acked-by: Willem de Bruijn <willemb@google.com>

The pinned object at that filepath can change between iptables invocations.
This is not very obvious when inserting a new unrelated rule, but an
unavoidable effect of iptables reading and re-inserting the entire table on
each operation. Even switching to the bpf identifier would not help, as those
ids can be recycled, too. Admins just have to be diligent and not rely on
objects pinned by unprivileged users.
