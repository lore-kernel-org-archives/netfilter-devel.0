Received: from fhigh7-smtp.messagingengine.com (fhigh7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BA77F7CD
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Mar 2024 13:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711373640; cv=none; b=mWATvQ1MVvFNsgXRFPZSWtKUqnrHzkzVqaLc+KioC77msoPuRiTZ1YRRSc5OQnfrTo3/Z6JQ3E4sJowp1dZarSOkI4kXtRX3d9jq/pNTPw1ldm4NnkBQLQP11FiAf56Qj2+Br1ENDTAFMolJf2RrxizFuWHf9nLwjXlf1P8VBgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711373640; c=relaxed/simple;
	bh=Hc/9oWRbY2tgX0waCoU2si7JQOIaOvbzGd5zDNiN8Lo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i3ErOQeMEbA5v6XzfAuciJf+9ZLkLc4WrabUF9N/R9KpOl+f2J1V9cI+XGPKvP87cHXYAgnBDBupMCz/Ani5fZIt9KdjZv3r0GgEHjM6U9AXhLW0uST39N6jm/OMxfuCLjPOJE9QBQTURVXooabuYkcAit01t1fE/slvZP2DM5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naccy.de; spf=pass smtp.mailfrom=naccy.de; dkim=pass (2048-bit key) header.d=naccy.de header.i=@naccy.de header.b=YL83lPiQ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=cjjNe64W; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naccy.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naccy.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naccy.de header.i=@naccy.de header.b="YL83lPiQ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="cjjNe64W"
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id 74E181140095;
	Mon, 25 Mar 2024 09:33:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 25 Mar 2024 09:33:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=naccy.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1711373632;
	 x=1711460032; bh=dDs64iFuXUsoPj7QNqttP5VZDqKhsr2W52KyTEXONcM=; b=
	YL83lPiQbfS6nGa8YOJ01mNZlHJweWZ8TAkGVMxthp5zC/Md5FpStBVbYM4ofkJA
	K82gPDV+BfPaYDpQrPh9MddXflJnDBP94VJfVxvsbz6QUILT8Df/8VLXNRmR3HSz
	uYsqCoWrf/xpElAYINcQ0x5S8LWE8EQl+yNIiDON9abkfymTZthFSPejdku3cy7t
	3SlASn8kAqZ0igy6uIcdXQdTKc4avg8WrN5w0eLedM0NftGbaxVl+DVq4uZzjFR0
	Bc7oiuiquXaVJ6/uzzFdcRfkUjd9r7h3bxTM5S2U9P4Tnt/m7sCbbz+EOey2i4R1
	k/LuBXU/n83kcVnSwHnR+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1711373632; x=
	1711460032; bh=dDs64iFuXUsoPj7QNqttP5VZDqKhsr2W52KyTEXONcM=; b=c
	jjNe64WMnptuElIyzTGBx09g9rgwhVJM6nepqyI3KkLZGuVbpR6nEZXnZlDH/E9f
	M0dgcjT/XBUhWyBqZMQdiuMj1lga5sM+5vZYawJnSpOJwjxmqIqEA3LL6+xm7Ihp
	PehemWscLfnorGNEqRQVBP8xyISkB5aQdGui9nQHr50FB2WieMOTqeVnywETz1vt
	GoGADGA65VIHmKdycEvqLJzoz1Ftb2ezOZfuJkfvfVczvsVeD/st/sNKo4z4N/cg
	9PZRjIQab7n21fJhLfGStVGfHQN3UIKd93yoQfhk88Rjoo52r41pVqf9DVkT5wL6
	+m9ETKoCLc+iE08fMlMsA==
X-ME-Sender: <xms:QH0BZpXgRj8OrsgsHz8CwqD7yuqrFVNod1ATG_BZngtECicas21R3Q>
    <xme:QH0BZpmZRSZFwP6XsM1iqcLXgPZky5tyrLqO-owdrzmMmOi8qu04S5a7l-fL1SoAL
    Vwt8QtesbYE-6i8XZA>
X-ME-Received: <xmr:QH0BZlY0DhIdIXoZC0oCBT7xs1qIlzUWjeCnsKbOS-WF6IsSvf2r0KPz6wK-9re76UPFiZ0GjQlF5S-7PQNqcz6KFKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledruddutddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdludehmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredt
    tddvjeenucfhrhhomhepsfhuvghnthhinhcuffgvshhlrghnuggvshcuoehquggvsehnrg
    gttgihrdguvgeqnecuggftrfgrthhtvghrnhepfffgudeuveelfeeijeejfedtuedvtdeh
    gfdtiedtfeeuhfeugfejteeiheevheehnecuffhomhgrihhnpehtrggslhgvrdhnrghmvg
    dphhgrnhgulhgvrdhiugenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehquggvsehnrggttgihrdguvg
X-ME-Proxy: <xmx:QH0BZsX4PItifL_-nMv0DK8NdiWd4JVJdx15uqvmR6rX9lCYNt5PtQ>
    <xmx:QH0BZjmuVngB2YBMnv8upxCJlC6VcjlcCHlweBiAACa7ygHRRWGg-w>
    <xmx:QH0BZpcA4qjj5LZeGP6UQkIaYjva9lGqZGMlsgme8NM6Q737svMGSw>
    <xmx:QH0BZtF7k-QX_GN2AWIYy8sgfH2-hw24qU6elPGq0LGfhk74BebIVQ>
    <xmx:QH0BZsBTEBreyJNxzXLCHorZ2dKP11Ra03JI_sHUzrhAs9n9R3xCmA>
Feedback-ID: i14194934:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 Mar 2024 09:33:51 -0400 (EDT)
Message-ID: <f3f6acf4-1f20-4571-b452-85c5d0299a21@naccy.de>
Date: Mon, 25 Mar 2024 14:33:48 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [nft PATCH 2/2] Add support for table's persist flag
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
References: <20240322154855.13857-1-phil@nwl.cc>
 <20240322154855.13857-3-phil@nwl.cc>
Content-Language: en-US
From: Quentin Deslandes <qde@naccy.de>
In-Reply-To: <20240322154855.13857-3-phil@nwl.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-03-22 16:48, Phil Sutter wrote:
> Bison parser lacked support for passing multiple flags, JSON parser
> did not support table flags at all.
> 
> Document also 'owner' flag (and describe their relationship in nft.8.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  doc/libnftables-json.adoc                   | 11 +++-
>  doc/nft.txt                                 |  9 +++
>  include/rule.h                              |  3 +-
>  src/parser_bison.y                          | 42 +++++++++----
>  src/parser_json.c                           | 68 ++++++++++++++++++++-
>  src/rule.c                                  |  1 +
>  tests/shell/features/table_flag_persist.nft |  3 +
>  tests/shell/testcases/owner/0002-persist    | 36 +++++++++++
>  8 files changed, 156 insertions(+), 17 deletions(-)
>  create mode 100644 tests/shell/features/table_flag_persist.nft
>  create mode 100755 tests/shell/testcases/owner/0002-persist
> 
> diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
> index 3948a0bad47c1..a4adcde2a66a9 100644
> --- a/doc/libnftables-json.adoc
> +++ b/doc/libnftables-json.adoc
> @@ -202,12 +202,19 @@ Rename a chain. The new name is expected in a dedicated property named
>  
>  === TABLE
>  [verse]
> +____
>  *{ "table": {
>  	"family":* 'STRING'*,
>  	"name":* 'STRING'*,
> -	"handle":* 'NUMBER'
> +	"handle":* 'NUMBER'*,
> +	"flags":* 'TABLE_FLAGS'
>  *}}*
>  
> +'TABLE_FLAGS' := 'TABLE_FLAG' | *[* 'TABLE_FLAG_LIST' *]*
> +'TABLE_FLAG_LIST' := 'TABLE_FLAG' [*,* 'TABLE_FLAG_LIST' ]
> +'TABLE_FLAG' := *"dormant"* | *"owner"* | *"persist"*
> +____
> +
>  This object describes a table.
>  
>  *family*::
> @@ -217,6 +224,8 @@ This object describes a table.
>  *handle*::
>  	The table's handle. In input, it is used only in *delete* command as
>  	alternative to *name*.
> +*flags*::
> +	The table's flags.
>  
>  === CHAIN
>  [verse]
> diff --git a/doc/nft.txt b/doc/nft.txt
> index 248b29af369ad..2080c07350f6d 100644
> --- a/doc/nft.txt
> +++ b/doc/nft.txt
> @@ -343,8 +343,17 @@ return an error.
>  |Flag | Description
>  |dormant |
>  table is not evaluated any more (base chains are unregistered).
> +|owner |
> +table is owned by the creating process.
> +|persist |
> +table shall outlive the owning process.
>  |=================
>  
> +Creating a table with flag *owner* excludes other processes from manipulating
> +it or its contents. By default, it will be removed when the process exits.
> +Setting flag *persist* will prevent this and the resulting orphaned table will
> +accept a new owner, e.g. a restarting daemon maintaining the table.
> +
>  .*Add, change, delete a table*
>  ---------------------------------------
>  # start nft in interactive mode
> diff --git a/include/rule.h b/include/rule.h
> index 3a833cf3a4588..2f8292ee9dc32 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -130,8 +130,9 @@ struct symbol *symbol_get(const struct scope *scope, const char *identifier);
>  enum table_flags {
>  	TABLE_F_DORMANT		= (1 << 0),
>  	TABLE_F_OWNER		= (1 << 1),
> +	TABLE_F_PERSIST		= (1 << 2),
>  };
> -#define TABLE_FLAGS_MAX		2
> +#define TABLE_FLAGS_MAX		3
>  
>  const char *table_flag_name(uint32_t flag);
>  
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index bdb73911759c8..1ade7417f8d6a 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -742,6 +742,8 @@ int nft_lex(void *, void *, void *);
>  %type <rule>			rule rule_alloc
>  %destructor { rule_free($$); }	rule
>  
> +%type <val>			table_flags table_flag
> +
>  %type <val>			set_flag_list	set_flag
>  
>  %type <val>			set_policy_spec
> @@ -1905,20 +1907,9 @@ table_block_alloc	:	/* empty */
>  			}
>  			;
>  
> -table_options		:	FLAGS		STRING
> +table_options		:	FLAGS		table_flags
>  			{
> -				if (strcmp($2, "dormant") == 0) {
> -					$<table>0->flags |= TABLE_F_DORMANT;
> -					free_const($2);
> -				} else if (strcmp($2, "owner") == 0) {
> -					$<table>0->flags |= TABLE_F_OWNER;
> -					free_const($2);
> -				} else {
> -					erec_queue(error(&@2, "unknown table option %s", $2),
> -						   state->msgs);
> -					free_const($2);
> -					YYERROR;
> -				}
> +				$<table>0->flags |= $2;
>  			}
>  			|	comment_spec
>  			{
> @@ -1930,6 +1921,31 @@ table_options		:	FLAGS		STRING
>  			}
>  			;
>  
> +table_flags		:	table_flag
> +			|	table_flags	COMMA	table_flag
> +			{
> +				$$ = $1 | $3;
> +			}
> +			;
> +table_flag		:	STRING
> +			{
> +				if (strcmp($1, "dormant") == 0) {
> +					$$ = TABLE_F_DORMANT;
> +					free_const($1);
> +				} else if (strcmp($1, "owner") == 0) {
> +					$$ = TABLE_F_OWNER;

Don't you need to free_const($1) here too?

> +				} else if (strcmp($1, "persist") == 0) {
> +					$$ = TABLE_F_PERSIST;
> +					free_const($1);
> +				} else {
> +					erec_queue(error(&@1, "unknown table option %s", $1),
> +						   state->msgs);
> +					free_const($1);
> +					YYERROR;
> +				}
> +			}
> +			;
> +
>  table_block		:	/* empty */	{ $$ = $<table>-1; }
>  			|	table_block	common_block
>  			|	table_block	stmt_separator
> diff --git a/src/parser_json.c b/src/parser_json.c
> index 4fc0479cf4972..04255688ca04c 100644
> --- a/src/parser_json.c
> +++ b/src/parser_json.c
> @@ -2954,6 +2954,64 @@ static struct stmt *json_parse_stmt(struct json_ctx *ctx, json_t *root)
>  	return NULL;
>  }
>  
> +static int string_to_table_flag(const char *str)
> +{
> +	const struct {
> +		enum table_flags val;
> +		const char *name;
> +	} flag_tbl[] = {
> +		{ TABLE_F_DORMANT, "dormant" },
> +		{ TABLE_F_OWNER,   "owner" },
> +		{ TABLE_F_PERSIST, "persist" },
> +	};
> +	unsigned int i;
> +
> +	for (i = 0; i < array_size(flag_tbl); i++) {
> +		if (!strcmp(str, flag_tbl[i].name))
> +			return flag_tbl[i].val;
> +	}
> +	return 0;
> +}
> +
> +static int json_parse_table_flags(struct json_ctx *ctx, json_t *root,
> +				  enum table_flags *flags)
> +{
> +	json_t *tmp, *tmp2;
> +	size_t index;
> +	int flag;
> +
> +	if (json_unpack(root, "{s:o}", "flags", &tmp))
> +		return 0;
> +
> +	if (json_is_string(tmp)) {
> +		flag = string_to_table_flag(json_string_value(tmp));
> +		if (flag) {
> +			*flags = flag;
> +			return 0;
> +		}
> +		json_error(ctx, "Invalid table flag '%s'.",
> +			   json_string_value(tmp));
> +		return 1;
> +	}
> +	if (!json_is_array(tmp)) {
> +		json_error(ctx, "Unexpected table flags value.");
> +		return 1;
> +	}
> +	json_array_foreach(tmp, index, tmp2) {
> +		if (json_is_string(tmp2)) {
> +			flag = string_to_table_flag(json_string_value(tmp2));
> +
> +			if (flag) {
> +				*flags |= flag;
> +				continue;
> +			}
> +		}
> +		json_error(ctx, "Invalid table flag at index %zu.", index);
> +		return 1;
> +	}
> +	return 0;
> +}
> +
>  static struct cmd *json_parse_cmd_add_table(struct json_ctx *ctx, json_t *root,
>  					    enum cmd_ops op, enum cmd_obj obj)
>  {
> @@ -2962,6 +3020,7 @@ static struct cmd *json_parse_cmd_add_table(struct json_ctx *ctx, json_t *root,
>  		.table.location = *int_loc,
>  	};
>  	struct table *table = NULL;
> +	enum table_flags flags = 0;
>  
>  	if (json_unpack_err(ctx, root, "{s:s}",
>  			    "family", &family))
> @@ -2972,6 +3031,9 @@ static struct cmd *json_parse_cmd_add_table(struct json_ctx *ctx, json_t *root,
>  			return NULL;
>  
>  		json_unpack(root, "{s:s}", "comment", &comment);
> +		if (json_parse_table_flags(ctx, root, &flags))
> +			return NULL;
> +
>  	} else if (op == CMD_DELETE &&
>  		   json_unpack(root, "{s:s}", "name", &h.table.name) &&
>  		   json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
> @@ -2985,10 +3047,12 @@ static struct cmd *json_parse_cmd_add_table(struct json_ctx *ctx, json_t *root,
>  	if (h.table.name)
>  		h.table.name = xstrdup(h.table.name);
>  
> -	if (comment) {
> +	if (comment || flags) {
>  		table = table_alloc();
>  		handle_merge(&table->handle, &h);
> -		table->comment = xstrdup(comment);
> +		if (comment)
> +			table->comment = xstrdup(comment);
> +		table->flags = flags;
>  	}
>  
>  	if (op == CMD_ADD)
> diff --git a/src/rule.c b/src/rule.c
> index 45289cc01dce8..6e56a129c81d1 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -1215,6 +1215,7 @@ struct table *table_lookup_fuzzy(const struct handle *h,
>  static const char *table_flags_name[TABLE_FLAGS_MAX] = {
>  	"dormant",
>  	"owner",
> +	"persist",
>  };
>  
>  const char *table_flag_name(uint32_t flag)
> diff --git a/tests/shell/features/table_flag_persist.nft b/tests/shell/features/table_flag_persist.nft
> new file mode 100644
> index 0000000000000..0da3e6d4f03ff
> --- /dev/null
> +++ b/tests/shell/features/table_flag_persist.nft
> @@ -0,0 +1,3 @@
> +table t {
> +	flags persist;
> +}
> diff --git a/tests/shell/testcases/owner/0002-persist b/tests/shell/testcases/owner/0002-persist
> new file mode 100755
> index 0000000000000..cf4b8f1327ec1
> --- /dev/null
> +++ b/tests/shell/testcases/owner/0002-persist
> @@ -0,0 +1,36 @@
> +#!/bin/bash
> +
> +# NFT_TEST_REQUIRES(NFT_TEST_HAVE_table_flag_owner)
> +# NFT_TEST_REQUIRES(NFT_TEST_HAVE_table_flag_persist)
> +
> +die() {
> +	echo "$@"
> +	exit 1
> +}
> +
> +$NFT -f - <<EOF
> +table ip t {
> +	flags owner, persist
> +}
> +EOF
> +[[ $? -eq 0 ]] || {
> +	die "table add failed"
> +}
> +
> +$NFT list ruleset | grep -q 'table ip t' || {
> +	die "table does not persist"
> +}
> +$NFT list ruleset | grep -q 'flags persist$' || {
> +	die "unexpected flags in orphaned table"
> +}
> +
> +$NFT -f - <<EOF
> +table ip t {
> +	flags owner, persist
> +}
> +EOF
> +[[ $? -eq 0 ]] || {
> +	die "retake ownership failed"
> +}
> +
> +exit 0
