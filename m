Return-Path: <SRS0=n5XH=7O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11349C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jun 2020 16:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB83E206C3
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jun 2020 16:10:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="iNo2+TLX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgFAQK5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Jun 2020 12:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgFAQK5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Jun 2020 12:10:57 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54C4C05BD43
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Jun 2020 09:10:56 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id k8so7701306edq.4
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Jun 2020 09:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dn6K/A6SOW5qp++Ne9R7n/L/wKzu+p7tdfVTCOgRLg4=;
        b=iNo2+TLXyLsLzohYb3nteIZEsBmslYy8Tgfy9sQGufapm+7lMl6IQHn7zi2eX7jFFP
         3atAkaOij5BbhRzszhtinK1eHQW1UXJnx7jhZnTqUNU54G8d59XWqCpaNur8V/mCK74D
         FgQZSebaIbeeFLiZwYuX447C1dcMP4LHq9l+Nak5up99YdGJPNG7KWwbspMiqrl+xBgE
         P5dCBQNHz38zhQVGkjoptQoLfx+u+1n9nbzOjBCGk49g3LiWO4wAO1xFHG5AzFCekpvy
         vQwWD8x7Dtsln1k263K2kZ15qLNFLSYvyApvp88XrwctuU2h/nAVmhqOi6gZfJqC8e7f
         2AMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dn6K/A6SOW5qp++Ne9R7n/L/wKzu+p7tdfVTCOgRLg4=;
        b=NbQDSF08yamIwhL/6+fdsjz5CQNkJVkiP2uj7lxhZFTCjur4jB8JISRQQxn4Z92EaK
         AEdOt5E8cCjuNSM/2f+25fe7JetACX4lCvSbwXaA/xs4akZhk6SEFkES/FnLs8k1eNeQ
         9ivjQ4axaDIws1J4SDrPzPGIpJHcwh05sUxQdt6lDDXFkcphyR/zR5cKo24VcwBoHa6C
         5Zi4RHxaA1aCRBx5owD3vFvkyR5PE9ZItLKlHubCSagAN4xcMndklWaX+GUB4CKKbliS
         3i3eGec8mMkVGtltUfBDOkl61JqKOAeUorWjxaLpaz+pok1jyc8eQ4rmjTw6lJj7GbFP
         p7Tg==
X-Gm-Message-State: AOAM531MFr0GBFUH0Kmd7Rvx0pK9hl60NxCVMEtG8sAub8xzvAldq4vL
        XUDUOWckKcC7751MdSvctP7iglb1IbhgbsrofhWS
X-Google-Smtp-Source: ABdhPJw0YGU7YpCPl4+mz0a5HpLGEK8yte+ZULn6acU99QRLVVFth/COQs0HMh94/jcRdM+Bwg0d73vVeRaenEekmkU=
X-Received: by 2002:aa7:de08:: with SMTP id h8mr21832614edv.164.1591027855515;
 Mon, 01 Jun 2020 09:10:55 -0700 (PDT)
MIME-Version: 1.0
References: <d45d23ba6d58b1513c641dfb24f009cbc1b7aad6.1590716354.git.rgb@redhat.com>
In-Reply-To: <d45d23ba6d58b1513c641dfb24f009cbc1b7aad6.1590716354.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 1 Jun 2020 12:10:44 -0400
Message-ID: <CAHC9VhTuUdc565fPU=P1sXEM8hFm5P+ESm3Bv=kyebb19EsQuQ@mail.gmail.com>
Subject: Re: [PATCH ghak124 v2] audit: log nftables configuration change events
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, sgrubb@redhat.com,
        Ondrej Mosnacek <omosnace@redhat.com>, fw@strlen.de,
        twoerner@redhat.com, Eric Paris <eparis@parisplace.org>,
        tgraf@infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 28, 2020 at 9:44 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> iptables, ip6tables, arptables and ebtables table registration,
> replacement and unregistration configuration events are logged for the
> native (legacy) iptables setsockopt api, but not for the
> nftables netlink api which is used by the nft-variant of iptables in
> addition to nftables itself.
>
> Add calls to log the configuration actions in the nftables netlink api.
>
> This uses the same NETFILTER_CFG record format but overloads the table
> field.
>
>   type=NETFILTER_CFG msg=audit(2020-05-28 17:46:41.878:162) : table=?:0;?:0 family=unspecified entries=2 op=nft_register_gen pid=396 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
>   ...
>   type=NETFILTER_CFG msg=audit(2020-05-28 17:46:41.878:162) : table=firewalld:1;?:0 family=inet entries=0 op=nft_register_table pid=396 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
>   ...
>   type=NETFILTER_CFG msg=audit(2020-05-28 17:46:41.911:163) : table=firewalld:1;filter_FORWARD:85 family=inet entries=8 op=nft_register_chain pid=396 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
>   ...
>   type=NETFILTER_CFG msg=audit(2020-05-28 17:46:41.911:163) : table=firewalld:1;filter_FORWARD:85 family=inet entries=101 op=nft_register_rule pid=396 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
>   ...
>   type=NETFILTER_CFG msg=audit(2020-05-28 17:46:41.911:163) : table=firewalld:1;__set0:87 family=inet entries=87 op=nft_register_setelem pid=396 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
>   ...
>   type=NETFILTER_CFG msg=audit(2020-05-28 17:46:41.911:163) : table=firewalld:1;__set0:87 family=inet entries=0 op=nft_register_set pid=396 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
>
> For further information please see issue
> https://github.com/linux-audit/audit-kernel/issues/124
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
> Changelog:
> v2:
> - differentiate between xtables and nftables
> - add set, setelem, obj, flowtable, gen
> - use nentries field as appropriate per type
> - overload the "tables" field with table handle and chain/set/flowtable
>
>  include/linux/audit.h         | 52 +++++++++++++++++++++++++
>  kernel/auditsc.c              | 24 ++++++++++--
>  net/netfilter/nf_tables_api.c | 89 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 162 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 3fcd9ee49734..d79866a38505 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -12,6 +12,7 @@
>  #include <linux/sched.h>
>  #include <linux/ptrace.h>
>  #include <uapi/linux/audit.h>
> +#include <uapi/linux/netfilter/nf_tables.h>
>
>  #define AUDIT_INO_UNSET ((unsigned long)-1)
>  #define AUDIT_DEV_UNSET ((dev_t)-1)
> @@ -98,6 +99,57 @@ enum audit_nfcfgop {
>         AUDIT_XT_OP_REGISTER,
>         AUDIT_XT_OP_REPLACE,
>         AUDIT_XT_OP_UNREGISTER,
> +       AUDIT_NFT_OP_TABLE_REGISTER,
> +       AUDIT_NFT_OP_TABLE_UNREGISTER,
> +       AUDIT_NFT_OP_CHAIN_REGISTER,
> +       AUDIT_NFT_OP_CHAIN_UNREGISTER,
> +       AUDIT_NFT_OP_RULE_REGISTER,
> +       AUDIT_NFT_OP_RULE_UNREGISTER,
> +       AUDIT_NFT_OP_SET_REGISTER,
> +       AUDIT_NFT_OP_SET_UNREGISTER,
> +       AUDIT_NFT_OP_SETELEM_REGISTER,
> +       AUDIT_NFT_OP_SETELEM_UNREGISTER,
> +       AUDIT_NFT_OP_GEN_REGISTER,
> +       AUDIT_NFT_OP_OBJ_REGISTER,
> +       AUDIT_NFT_OP_OBJ_UNREGISTER,
> +       AUDIT_NFT_OP_OBJ_RESET,
> +       AUDIT_NFT_OP_FLOWTABLE_REGISTER,
> +       AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
> +       AUDIT_NFT_OP_INVALID,
> +};
> +
> +struct audit_nftcfgop_tab {
> +       enum nf_tables_msg_types        nftop;
> +       enum audit_nfcfgop              op;
> +};
> +
> +static const struct audit_nftcfgop_tab audit_nftcfgs[] = {
> +       { NFT_MSG_NEWTABLE,     AUDIT_NFT_OP_TABLE_REGISTER             },
> +       { NFT_MSG_GETTABLE,     AUDIT_NFT_OP_INVALID                    },
> +       { NFT_MSG_DELTABLE,     AUDIT_NFT_OP_TABLE_UNREGISTER           },
> +       { NFT_MSG_NEWCHAIN,     AUDIT_NFT_OP_CHAIN_REGISTER             },
> +       { NFT_MSG_GETCHAIN,     AUDIT_NFT_OP_INVALID                    },
> +       { NFT_MSG_DELCHAIN,     AUDIT_NFT_OP_CHAIN_UNREGISTER           },
> +       { NFT_MSG_NEWRULE,      AUDIT_NFT_OP_RULE_REGISTER              },
> +       { NFT_MSG_GETRULE,      AUDIT_NFT_OP_INVALID                    },
> +       { NFT_MSG_DELRULE,      AUDIT_NFT_OP_RULE_UNREGISTER            },
> +       { NFT_MSG_NEWSET,       AUDIT_NFT_OP_SET_REGISTER               },
> +       { NFT_MSG_GETSET,       AUDIT_NFT_OP_INVALID                    },
> +       { NFT_MSG_DELSET,       AUDIT_NFT_OP_SET_UNREGISTER             },
> +       { NFT_MSG_NEWSETELEM,   AUDIT_NFT_OP_SETELEM_REGISTER           },
> +       { NFT_MSG_GETSETELEM,   AUDIT_NFT_OP_INVALID                    },
> +       { NFT_MSG_DELSETELEM,   AUDIT_NFT_OP_SETELEM_UNREGISTER         },
> +       { NFT_MSG_NEWGEN,       AUDIT_NFT_OP_GEN_REGISTER               },
> +       { NFT_MSG_GETGEN,       AUDIT_NFT_OP_INVALID                    },
> +       { NFT_MSG_TRACE,        AUDIT_NFT_OP_INVALID                    },
> +       { NFT_MSG_NEWOBJ,       AUDIT_NFT_OP_OBJ_REGISTER               },
> +       { NFT_MSG_GETOBJ,       AUDIT_NFT_OP_INVALID                    },
> +       { NFT_MSG_DELOBJ,       AUDIT_NFT_OP_OBJ_UNREGISTER             },
> +       { NFT_MSG_GETOBJ_RESET, AUDIT_NFT_OP_OBJ_RESET                  },
> +       { NFT_MSG_NEWFLOWTABLE, AUDIT_NFT_OP_FLOWTABLE_REGISTER         },
> +       { NFT_MSG_GETFLOWTABLE, AUDIT_NFT_OP_INVALID                    },
> +       { NFT_MSG_DELFLOWTABLE, AUDIT_NFT_OP_FLOWTABLE_UNREGISTER       },
> +       { NFT_MSG_MAX,          AUDIT_NFT_OP_INVALID                    },
>  };

I didn't check every "op" defined above to match with the changes in
nf_tables_api.c, but is there a reason why we can't simply hardcode
the AUDIT_NFT_OP_* values in the audit_log_nfcfg() calls in
nf_tables_api.c?  If we can, let's do that.

If we can't do that, we need to add some build-time protection to
catch if NFT_MSG_MAX increases without this table being updated.

>  static int audit_match_perm(struct audit_context *ctx, int mask)
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 4471393da6d8..7a386eca6e04 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -12,6 +12,7 @@
>  #include <linux/netlink.h>
>  #include <linux/vmalloc.h>
>  #include <linux/rhashtable.h>
> +#include <linux/audit.h>
>  #include <linux/netfilter.h>
>  #include <linux/netfilter/nfnetlink.h>
>  #include <linux/netfilter/nf_tables.h>
> @@ -693,6 +694,14 @@ static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
>  {
>         struct sk_buff *skb;
>         int err;
> +       char *buf = kasprintf(GFP_KERNEL, "%s:%llu;?:0",
> +                             ctx->table->name, ctx->table->handle);
> +
> +       audit_log_nfcfg(buf,
> +                       ctx->family,
> +                       ctx->table->use,
> +                       audit_nftcfgs[event].op);

As an example, the below would work, yes?

audit_log_nfcfg(...,
 (event == NFT_MSG_NEWTABLE ?
  AUDIT_NFT_OP_TABLE_REGISTER :
  AUDIT_NFT_OP_TABLE_UNREGISTER)

> +       kfree(buf);
>
>         if (!ctx->report &&
>             !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))

-- 
paul moore
www.paul-moore.com
