Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24565C77B61
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Apr 2023 21:14:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjDMVOS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Apr 2023 17:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjDMVOR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2023 17:14:17 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B876E172C
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2023 14:14:15 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-94eb6ad1aecso48488366b.2
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2023 14:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent.com; s=google; t=1681420454; x=1684012454;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Iw9rlpg8ozshQQ9GL1xtg2Yqf9pvDF0Kqb2ww8Y5MjU=;
        b=LSdIrSmUvrxApHW7CEhBgi/WqK60CVNyh/D3Ay9cG51sVnKkbeOxvrJr55iF8aqmWX
         WFVB7g9UU0Osim/aWPNBhegknN0BeFRhs0BRhnSk9Pt02Lx6i+KmLsi3lAttzws1LNhB
         DXQqiY/n2KqcN15qqxGYtddnD5M94VO68CNGt3EdJ8cFt7wm9JmySTXLx5pAnN4w2NHc
         hDSkzHkVuf1EC3gFMv0iFG8tqNCmcwLUH7QTwCcYtjxcn7kstrPO+wdFkxo2OTKfjcrC
         LMBf/zznusZES28EaQj0gNcopi5bjwg7Xj7AxULrbpbBZ4nS9oVOU/lsZRkJn3Mqc1Dr
         5//A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681420454; x=1684012454;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Iw9rlpg8ozshQQ9GL1xtg2Yqf9pvDF0Kqb2ww8Y5MjU=;
        b=OIFkvYP6RvdkkHpnndlHr+9CdiIaOUDCZMcFTz1Py0FIMkEk5R5XB6JAUlmYPvjH9G
         9Ibiu8ncGuKpAv7QaUCs6cr/C7I/PBgyYmVtURHpcdfPWnPSlpvko8PsMNAw1GcVDBc9
         1rs9rIC/A5BgfVNRV0H80ib6ekI15RPoPnSl8N0Qe/np0XzjYK0SjrL5OjJdA5Mig+b0
         wnl6QfUJzB7Nvk9w7D9Ce++40oG+7aV4Zv0djwxDJBed+QH9pUOCe6dYdY4dITxQqlB5
         Y8q8FVYWv9elxPZE3TAKCGOO19OdQbWnzJjPHb/S+/uzbV3DU6iS706LXaykZHi/F7AO
         goCQ==
X-Gm-Message-State: AAQBX9e/YkrcI5BoixWSvYvawjNWuwKXQbkU9lA+Sp191SJ4Hvr0fdqt
        XDqHfGcE2IEprxOgj5i/Zk/fa8mqsNJIokanvEdfzQ==
X-Google-Smtp-Source: AKy350b8WcrGf580mAFJ58BQiyNxUgjDL0y9ljpqarouqS6LOdRNth0G4IdY3nFrcWw6LS/UlDmayM6ZpL1sAifoCHU=
X-Received: by 2002:a50:9ee9:0:b0:504:ed04:5d3d with SMTP id
 a96-20020a509ee9000000b00504ed045d3dmr1957703edf.7.1681420454183; Thu, 13 Apr
 2023 14:14:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230413133228.20790-1-fw@strlen.de> <20230413133228.20790-6-fw@strlen.de>
In-Reply-To: <20230413133228.20790-6-fw@strlen.de>
From:   Quentin Monnet <quentin@isovalent.com>
Date:   Thu, 13 Apr 2023 22:14:03 +0100
Message-ID: <CACdoK4LRjNsDY6m2fvUGY_C9gMvUdX9QpEetr9RtGuR8xb8pmg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 5/6] tools: bpftool: print netfilter link info
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        bpf@vger.kernel.org, dxu@dxuuu.xyz, qde@naccy.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On Thu, 13 Apr 2023 at 14:36, Florian Westphal <fw@strlen.de> wrote:
>
> Dump protocol family, hook and priority value:
> $ bpftool link
> 2: type 10  prog 20

Could you please update link_type_name in libbpf (libbpf.c) so that we
display "netfilter" here instead of "type 10"?

>         pf: 2, hook 1, prio -128
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  tools/bpf/bpftool/link.c       | 24 ++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h | 15 +++++++++++++++
>  tools/lib/bpf/libbpf.c         |  1 +
>  3 files changed, 40 insertions(+)
>
> diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
> index f985b79cca27..a2ea85d1ebbf 100644
> --- a/tools/bpf/bpftool/link.c
> +++ b/tools/bpf/bpftool/link.c
> @@ -135,6 +135,18 @@ static void show_iter_json(struct bpf_link_info *info, json_writer_t *wtr)
>         }
>  }
>
> +static void show_netfilter_json(const struct bpf_link_info *info, json_writer_t *wtr)
> +{
> +       jsonw_uint_field(json_wtr, "pf",
> +                        info->netfilter.pf);
> +       jsonw_uint_field(json_wtr, "hook",
> +                        info->netfilter.hooknum);
> +       jsonw_int_field(json_wtr, "prio",
> +                        info->netfilter.priority);
> +       jsonw_uint_field(json_wtr, "flags",
> +                        info->netfilter.flags);
> +}
> +
>  static int get_prog_info(int prog_id, struct bpf_prog_info *info)
>  {
>         __u32 len = sizeof(*info);
> @@ -195,6 +207,10 @@ static int show_link_close_json(int fd, struct bpf_link_info *info)
>                                  info->netns.netns_ino);
>                 show_link_attach_type_json(info->netns.attach_type, json_wtr);
>                 break;
> +       case BPF_LINK_TYPE_NETFILTER:
> +               show_netfilter_json(info, json_wtr);
> +               break;
> +
>         default:
>                 break;
>         }
> @@ -301,6 +317,14 @@ static int show_link_close_plain(int fd, struct bpf_link_info *info)
>                 printf("\n\tnetns_ino %u  ", info->netns.netns_ino);
>                 show_link_attach_type_plain(info->netns.attach_type);
>                 break;
> +       case BPF_LINK_TYPE_NETFILTER:
> +               printf("\n\tpf: %d, hook %u, prio %d",
> +                      info->netfilter.pf,
> +                      info->netfilter.hooknum,
> +                      info->netfilter.priority);
> +               if (info->netfilter.flags)
> +                       printf(" flags 0x%x", info->netfilter.flags);
> +               break;
>         default:
>                 break;
>         }
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 3823100b7934..c93febc4c75f 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -986,6 +986,7 @@ enum bpf_prog_type {
>         BPF_PROG_TYPE_LSM,
>         BPF_PROG_TYPE_SK_LOOKUP,
>         BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
> +       BPF_PROG_TYPE_NETFILTER,

If netfilter programs could be loaded with bpftool, we'd need to
update bpftool's docs. But I don't think this is the case, right? We
don't currently have a way to pass the pf, hooknum, priority and flags
necessary to load the program with "bpftool prog load" so it would
fail?

Have you considered listing netfilter programs in the output of
"bpftool net" as well? Given that they're related to networking, it
would maybe make sense to have them listed alongside XDP, TC, and flow
dissector programs?

The patch looks good to me otherwise.

Thanks,
Quentin
