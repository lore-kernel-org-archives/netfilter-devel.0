Return-Path: <SRS0=6h+B=ZP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E10DC432C0
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Nov 2019 20:01:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCECC204FD
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Nov 2019 20:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfKWUBO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Nov 2019 15:01:14 -0500
Received: from correo.us.es ([193.147.175.20]:46890 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbfKWUBO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Nov 2019 15:01:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 36C89A1A33E
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Nov 2019 21:01:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 28687CA0F3
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Nov 2019 21:01:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1CD2FD1DBB; Sat, 23 Nov 2019 21:01:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D3028DA8E8;
        Sat, 23 Nov 2019 21:01:06 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 23 Nov 2019 21:01:06 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A041B4301DE1;
        Sat, 23 Nov 2019 21:01:06 +0100 (CET)
Date:   Sat, 23 Nov 2019 21:01:08 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?iso-8859-1?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf-next v2 1/8] netfilter: nf_tables: Support for
 subkeys, set with multiple ranged fields
Message-ID: <20191123200108.j75hl4sm4zur33jt@salvia>
References: <cover.1574428269.git.sbrivio@redhat.com>
 <90493a6feae0ae64db378fbfc8e9f351d4b7b05d.1574428269.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="h6lnwf35f73iw7eb"
Content-Disposition: inline
In-Reply-To: <90493a6feae0ae64db378fbfc8e9f351d4b7b05d.1574428269.git.sbrivio@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--h6lnwf35f73iw7eb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Stefano,

On Fri, Nov 22, 2019 at 02:40:00PM +0100, Stefano Brivio wrote:
[...]
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index bb9b049310df..f8dbeac14898 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -48,6 +48,7 @@ enum nft_registers {
>  
>  #define NFT_REG_SIZE	16
>  #define NFT_REG32_SIZE	4
> +#define NFT_REG32_COUNT	(NFT_REG32_15 - NFT_REG32_00 + 1)
>  
>  /**
>   * enum nft_verdicts - nf_tables internal verdicts
> @@ -275,6 +276,7 @@ enum nft_rule_compat_attributes {
>   * @NFT_SET_TIMEOUT: set uses timeouts
>   * @NFT_SET_EVAL: set can be updated from the evaluation path
>   * @NFT_SET_OBJECT: set contains stateful objects
> + * @NFT_SET_SUBKEY: set uses subkeys to map intervals for multiple fields
>   */
>  enum nft_set_flags {
>  	NFT_SET_ANONYMOUS		= 0x1,
> @@ -284,6 +286,7 @@ enum nft_set_flags {
>  	NFT_SET_TIMEOUT			= 0x10,
>  	NFT_SET_EVAL			= 0x20,
>  	NFT_SET_OBJECT			= 0x40,
> +	NFT_SET_SUBKEY			= 0x80,
>  };
>  
>  /**
> @@ -309,6 +312,17 @@ enum nft_set_desc_attributes {
>  };
>  #define NFTA_SET_DESC_MAX	(__NFTA_SET_DESC_MAX - 1)
>  
> +/**
> + * enum nft_set_subkey_attributes - subkeys for multiple ranged fields
> + *
> + * @NFTA_SET_SUBKEY_LEN: length of single field, in bits (NLA_U32)
> + */
> +enum nft_set_subkey_attributes {

Missing NFTA_SET_SUBKEY_UNSPEC here.

Not a problem if nla_parse_nested*() is not used as in your case,
probably good for consistency, in case there is a need for using such
function in the future.

> +	NFTA_SET_SUBKEY_LEN,
> +	__NFTA_SET_SUBKEY_MAX
> +};
> +#define NFTA_SET_SUBKEY_MAX	(__NFTA_SET_SUBKEY_MAX - 1)
> +
>  /**
>   * enum nft_set_attributes - nf_tables set netlink attributes
>   *
> @@ -327,6 +341,7 @@ enum nft_set_desc_attributes {
>   * @NFTA_SET_USERDATA: user data (NLA_BINARY)
>   * @NFTA_SET_OBJ_TYPE: stateful object type (NLA_U32: NFT_OBJECT_*)
>   * @NFTA_SET_HANDLE: set handle (NLA_U64)
> + * @NFTA_SET_SUBKEY: subkeys for multiple ranged fields (NLA_NESTED)
>   */
>  enum nft_set_attributes {
>  	NFTA_SET_UNSPEC,
> @@ -346,6 +361,7 @@ enum nft_set_attributes {
>  	NFTA_SET_PAD,
>  	NFTA_SET_OBJ_TYPE,
>  	NFTA_SET_HANDLE,
> +	NFTA_SET_SUBKEY,

Could you use NFTA_SET_DESC instead for this? The idea is to add the
missing front-end code to parse this new attribute and store the
subkeys length in set->desc.klen[], hence nft_pipapo_init() can just
use the already parsed data. I think this will simplify the code that
I'm seeing in nft_pipapo_init() a bit since not netlink parsing will
be required.

I'm attaching a sketch patch, including also the use of NFTA_LIST_ELEM:

NFTA_SET_DESC
  NFTA_SET_DESC_SIZE
  NFTA_SET_DESC_SUBKEY
     NFTA_LIST_ELEM
       NFTA_SET_SUBKEY_LEN
     NFTA_LIST_ELEM
       NFTA_SET_SUBKEY_LEN
     ...

Just in there's a need for more fields to describe the subkey in the
future, it's just more boilerplate code for the future extensibility.

Another suggestion is to rename NFT_SET_SUBKEY to NFT_SET_CONCAT, to
signal the kernel that userspace wants a datastructure that knows how
to deal with concatenations. Although concatenations can be done by
hashtable already, this flags is just interpreted by the kernel as a
hint on what kind of datastructure would fit better for what is
needed. The combination of the NFT_SET_INTERVAL and the NFT_SET_CONCAT
(if you're fine with the rename, of course) is what will kick in
pipapo to be used.

Attaching sketch for the netlink control plane with the changes I've
been describing above, compile-tested only.

Thanks.

--h6lnwf35f73iw7eb
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="subkeys.patch"

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2b3e6a2309aa..0b105264cc4f 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -259,11 +259,15 @@ struct nft_set_iter {
  *	@klen: key length
  *	@dlen: data length
  *	@size: number of set elements
+ *	@subkeylen: element subkey lengths
+ *	@num_subkeys: number of subkeys in element
  */
 struct nft_set_desc {
 	unsigned int		klen;
 	unsigned int		dlen;
 	unsigned int		size;
+	u8			subkey_len[NFT_REG32_COUNT];
+	u8			num_subkeys;
 };
 
 /**
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 79ab18b218be..d8ea2e72c960 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -48,6 +48,7 @@ enum nft_registers {
 
 #define NFT_REG_SIZE	16
 #define NFT_REG32_SIZE	4
+#define NFT_REG32_COUNT	(NFT_REG32_15 - NFT_REG32_00 + 1)
 
 /**
  * enum nft_verdicts - nf_tables internal verdicts
@@ -298,13 +299,27 @@ enum nft_set_policies {
 };
 
 /**
+ * enum nft_set_subkey_attributes - subkeys for multiple ranged fields
+ *
+ * @NFTA_SET_SUBKEY_LEN: length of single field, in bits (NLA_U32)
+ */
+enum nft_set_subkey_attributes {
+	NFTA_SET_SUBKEY_UNSPEC,
+	NFTA_SET_SUBKEY_LEN,
+	__NFTA_SET_SUBKEY_MAX
+};
+#define NFTA_SET_SUBKEY_MAX	(__NFTA_SET_SUBKEY_MAX - 1)
+
+/**
  * enum nft_set_desc_attributes - set element description
  *
  * @NFTA_SET_DESC_SIZE: number of elements in set (NLA_U32)
+ * @NFTA_SET_DESC_SUBKEYS: element subkeys in set (NLA_NESTED)
  */
 enum nft_set_desc_attributes {
 	NFTA_SET_DESC_UNSPEC,
 	NFTA_SET_DESC_SIZE,
+	NFTA_SET_DESC_SUBKEYS,
 	__NFTA_SET_DESC_MAX
 };
 #define NFTA_SET_DESC_MAX	(__NFTA_SET_DESC_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b5051f4dbb26..1de97ec8d73d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3357,6 +3357,7 @@ static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
 
 static const struct nla_policy nft_set_desc_policy[NFTA_SET_DESC_MAX + 1] = {
 	[NFTA_SET_DESC_SIZE]		= { .type = NLA_U32 },
+	[NFTA_SET_DESC_SUBKEYS]		= { .type = NLA_NESTED },
 };
 
 static int nft_ctx_init_from_setattr(struct nft_ctx *ctx, struct net *net,
@@ -3763,6 +3764,51 @@ static int nf_tables_getset(struct net *net, struct sock *nlsk,
 	return err;
 }
 
+static const struct nla_policy nft_subkey_policy[NFTA_SET_SUBKEY_MAX + 1] = {
+	[NFTA_SET_SUBKEY_LEN]	= { .type = NLA_U32 },
+};
+
+static int nft_set_desc_subkey_parse(const struct nlattr *attr,
+				     struct nft_set_desc *desc)
+{
+	struct nlattr *tb[NFTA_SET_SUBKEY_MAX + 1];
+	int err;
+
+	err = nla_parse_nested_deprecated(tb, NFTA_SET_SUBKEY_MAX, attr,
+					  nft_subkey_policy, NULL);
+	if (err < 0)
+		return err;
+
+	if (!tb[NFTA_SET_SUBKEY_LEN])
+		return -EINVAL;
+
+	desc->subkey_len[desc->num_subkeys++] =
+		ntohl(nla_get_be32(tb[NFTA_SET_SUBKEY_LEN]));
+
+	return 0;
+}
+
+static int nft_set_desc_subkeys(struct nft_set_desc *desc,
+				const struct nlattr *nla)
+{
+	struct nlattr *attr;
+	int rem, err;
+
+	nla_for_each_nested(attr, nla, rem) {
+		if (nla_type(attr) != NFTA_LIST_ELEM)
+			return -EINVAL;
+
+		if (desc->num_subkeys >= NFT_REG32_COUNT)
+			return -E2BIG;
+
+		err = nft_set_desc_subkey_parse(attr, desc);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
 static int nf_tables_set_desc_parse(struct nft_set_desc *desc,
 				    const struct nlattr *nla)
 {
@@ -3776,8 +3822,10 @@ static int nf_tables_set_desc_parse(struct nft_set_desc *desc,
 
 	if (da[NFTA_SET_DESC_SIZE] != NULL)
 		desc->size = ntohl(nla_get_be32(da[NFTA_SET_DESC_SIZE]));
+	if (da[NFTA_SET_DESC_SUBKEYS])
+		err = nft_set_desc_subkeys(desc, da[NFTA_SET_DESC_SUBKEYS]);
 
-	return 0;
+	return err;
 }
 
 static int nf_tables_newset(struct net *net, struct sock *nlsk,

--h6lnwf35f73iw7eb--
