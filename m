Return-Path: <SRS0=o6T4=AF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F743C433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 10:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 108FD2088E
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 10:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388481AbgFXKD5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Jun 2020 06:03:57 -0400
Received: from correo.us.es ([193.147.175.20]:35340 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387647AbgFXKD5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jun 2020 06:03:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5A4C61C0234
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2020 12:03:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4ACFBDA796
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2020 12:03:53 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 49475DA791; Wed, 24 Jun 2020 12:03:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 13876DA850;
        Wed, 24 Jun 2020 12:03:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 24 Jun 2020 12:03:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CE5A742EF42D;
        Wed, 24 Jun 2020 12:03:46 +0200 (CEST)
Date:   Wed, 24 Jun 2020 12:03:46 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        sgrubb@redhat.com, omosnace@redhat.com, fw@strlen.de,
        twoerner@redhat.com, eparis@parisplace.org, tgraf@infradead.org
Subject: Re: [PATCH ghak124 v3] audit: log nftables configuration change
 events
Message-ID: <20200624100346.GA11986@salvia>
References: <f9da8b5dbf2396b621c77c17b5b1123be5aa484e.1591275439.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9da8b5dbf2396b621c77c17b5b1123be5aa484e.1591275439.git.rgb@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 04, 2020 at 09:20:49AM -0400, Richard Guy Briggs wrote:
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
> v3:
> - inline message type rather than table
> 
> v2:
> - differentiate between xtables and nftables
> - add set, setelem, obj, flowtable, gen
> - use nentries field as appropriate per type
> - overload the "tables" field with table handle and chain/set/flowtable
> 
>  include/linux/audit.h         |  18 ++++++++
>  kernel/auditsc.c              |  24 ++++++++--
>  net/netfilter/nf_tables_api.c | 103 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 142 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 3fcd9ee49734..604ede630580 100644
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
> @@ -98,6 +99,23 @@ enum audit_nfcfgop {
>  	AUDIT_XT_OP_REGISTER,
>  	AUDIT_XT_OP_REPLACE,
>  	AUDIT_XT_OP_UNREGISTER,
> +	AUDIT_NFT_OP_TABLE_REGISTER,
> +	AUDIT_NFT_OP_TABLE_UNREGISTER,
> +	AUDIT_NFT_OP_CHAIN_REGISTER,
> +	AUDIT_NFT_OP_CHAIN_UNREGISTER,
> +	AUDIT_NFT_OP_RULE_REGISTER,
> +	AUDIT_NFT_OP_RULE_UNREGISTER,
> +	AUDIT_NFT_OP_SET_REGISTER,
> +	AUDIT_NFT_OP_SET_UNREGISTER,
> +	AUDIT_NFT_OP_SETELEM_REGISTER,
> +	AUDIT_NFT_OP_SETELEM_UNREGISTER,
> +	AUDIT_NFT_OP_GEN_REGISTER,
> +	AUDIT_NFT_OP_OBJ_REGISTER,
> +	AUDIT_NFT_OP_OBJ_UNREGISTER,
> +	AUDIT_NFT_OP_OBJ_RESET,
> +	AUDIT_NFT_OP_FLOWTABLE_REGISTER,
> +	AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
> +	AUDIT_NFT_OP_INVALID,
>  };
>  
>  extern int is_audit_feature_set(int which);
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 468a23390457..3a9100e95fda 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -75,6 +75,7 @@
>  #include <linux/uaccess.h>
>  #include <linux/fsnotify_backend.h>
>  #include <uapi/linux/limits.h>
> +#include <uapi/linux/netfilter/nf_tables.h>
>  
>  #include "audit.h"
>  
> @@ -136,9 +137,26 @@ struct audit_nfcfgop_tab {
>  };
>  
>  static const struct audit_nfcfgop_tab audit_nfcfgs[] = {
> -	{ AUDIT_XT_OP_REGISTER,		"register"	},
> -	{ AUDIT_XT_OP_REPLACE,		"replace"	},
> -	{ AUDIT_XT_OP_UNREGISTER,	"unregister"	},
> +	{ AUDIT_XT_OP_REGISTER,			"xt_register"		   },
> +	{ AUDIT_XT_OP_REPLACE,			"xt_replace"		   },
> +	{ AUDIT_XT_OP_UNREGISTER,		"xt_unregister"		   },
> +	{ AUDIT_NFT_OP_TABLE_REGISTER,		"nft_register_table"	   },
> +	{ AUDIT_NFT_OP_TABLE_UNREGISTER,	"nft_unregister_table"	   },
> +	{ AUDIT_NFT_OP_CHAIN_REGISTER,		"nft_register_chain"	   },
> +	{ AUDIT_NFT_OP_CHAIN_UNREGISTER,	"nft_unregister_chain"	   },
> +	{ AUDIT_NFT_OP_RULE_REGISTER,		"nft_register_rule"	   },
> +	{ AUDIT_NFT_OP_RULE_UNREGISTER,		"nft_unregister_rule"	   },
> +	{ AUDIT_NFT_OP_SET_REGISTER,		"nft_register_set"	   },
> +	{ AUDIT_NFT_OP_SET_UNREGISTER,		"nft_unregister_set"	   },
> +	{ AUDIT_NFT_OP_SETELEM_REGISTER,	"nft_register_setelem"	   },
> +	{ AUDIT_NFT_OP_SETELEM_UNREGISTER,	"nft_unregister_setelem"   },
> +	{ AUDIT_NFT_OP_GEN_REGISTER,		"nft_register_gen"	   },
> +	{ AUDIT_NFT_OP_OBJ_REGISTER,		"nft_register_obj"	   },
> +	{ AUDIT_NFT_OP_OBJ_UNREGISTER,		"nft_unregister_obj"	   },
> +	{ AUDIT_NFT_OP_OBJ_RESET,		"nft_reset_obj"		   },
> +	{ AUDIT_NFT_OP_FLOWTABLE_REGISTER,	"nft_register_flowtable"   },
> +	{ AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,	"nft_unregister_flowtable" },
> +	{ AUDIT_NFT_OP_INVALID,			"nft_invalid"		   },
>  };
>  
>  static int audit_match_perm(struct audit_context *ctx, int mask)
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 3558e76e2733..b9e7440cc87d 100644
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
> @@ -693,6 +694,16 @@ static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
>  {
>  	struct sk_buff *skb;
>  	int err;
> +	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;?:0",
> +			      ctx->table->name, ctx->table->handle);
> +
> +	audit_log_nfcfg(buf,
> +			ctx->family,
> +			ctx->table->use,
> +			event == NFT_MSG_NEWTABLE ?
> +				AUDIT_NFT_OP_TABLE_REGISTER :
> +				AUDIT_NFT_OP_TABLE_UNREGISTER);
> +	kfree(buf);

As a follow up: Would you wrap this code into a function?

        nft_table_audit()

Same thing for other pieces of code below.

Thanks.
