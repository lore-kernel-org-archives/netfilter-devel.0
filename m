From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf v4 1/1] netfilter: snmp: Fix one possible panic when
 snmp_trap_helper fail to register
Date: Sat, 25 Mar 2017 16:16:34 +0800
Message-ID: <CAML_gOfz33nvrG0fu1KLeMQbYsVSPP6CdoNLUFUiMh8YG7Hs0A@mail.gmail.com>
References: <1490408646-26051-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, Gao Feng <fgao@ikuai8.com>
To: gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:35719 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbdCYIQg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Mar 2017 04:16:36 -0400
Received: by mail-vk0-f46.google.com with SMTP id r69so10441575vke.2
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Mar 2017 01:16:35 -0700 (PDT)
In-Reply-To: <1490408646-26051-1-git-send-email-gfree.wind@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Feng,

2017-03-25 10:24 GMT+08:00  <gfree.wind@foxmail.com>:
[...]
> @@ -1293,12 +1283,7 @@ static int __init nf_nat_snmp_basic_init(void)
>         BUG_ON(nf_nat_snmp_hook != NULL);
>         RCU_INIT_POINTER(nf_nat_snmp_hook, help);
>
> -       ret = nf_conntrack_helper_register(&snmp_trap_helper);
> -       if (ret < 0) {
> -               nf_conntrack_helper_unregister(&snmp_helper);
> -               return ret;
> -       }
> -       return ret;
> +       return nf_conntrack_helper_register(&snmp_trap_helper);

I think you should also remove the "int ret = 0;" statement,

static int __init nf_nat_snmp_basic_init(void)
{
     int ret = 0;  <--- Here

Otherwise, GCC will warn "unused variable".
