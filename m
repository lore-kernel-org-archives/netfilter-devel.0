Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83EC23C512
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Nov 2025 12:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763125182; cv=none; b=bu6xwxm0kBD1Yu68H+rxMMEc13u2XsC7kDG6wEqUmq/mclJ7WkFagNTf2N3xOfcNeMYLZ8WAiExlETWWBGbhRwTQt4HGuBh0TvFQZDt7Sh3zup0FzsKJh937gr1MIGR0D9v7uFQExktgePbN1GF3HaA8/j9b+TIOeoV2+v1/Go0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763125182; c=relaxed/simple;
	bh=/1ErY5BwsfXYJaiU5rDkyE1Kc24p8JBK2cM3lWYld6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AFHGkSMzp506Zz5prZu2dybs+2gIFlpuvv71//exTZsQEszQhtD5n1jlyLHGEmvzhQv4MVlOUFfja/YpUjcRtWeqqMbe6U3Xl6j5o/lX2DJbAAVy6yfbgYlz4JVLlPVUNO5elHqBDDdPHfv9Ic9vMkfnsu856LPNzKcNxytelXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=S4QFOTfZ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="S4QFOTfZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PHpHFqTw5Szjk43JxwWyXRHof+xEx6G2jv4tZGOqykM=; b=S4QFOTfZU39faKbt8smRn+F92T
	9QUVFpfkhUiXio7Zk53XtOUdhJDtH3lqXBAfK3vnsVkTFBQOeHGP81HRQISqK/EBfMtvXAmmVj1g0
	DoDPdM40epqoT794BpwseaLmCVc9D/O5DWRFKQJpFmR7Q0yURP2foIRLeWEX766g5DK50GXjk/JO9
	pWldLvMsBv0LxOi/3hU+FMmeHW5RnXJ4jGPxn1WzUS+UrHskcezADiVHogCvGf4Li9EEx1oUeYPRw
	p/YCcwiIH6PI1p8hRqJAgDZ+AMraoPLg5DadLJ2TdMo/Rov5moWIfp3hBSjAsPO0vX1SnRGUlD+kU
	C9AB5MZA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vJtOp-000000002TM-2FDx;
	Fri, 14 Nov 2025 13:59:35 +0100
Date: Fri, 14 Nov 2025 13:59:35 +0100
From: Phil Sutter <phil@nwl.cc>
To: Alexandre Knecht <knecht.alexandre@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf-next v4] parser_json: support handle for rule
 positioning without breaking other objects
Message-ID: <aRcnt9F7N5WiV-zi@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Alexandre Knecht <knecht.alexandre@gmail.com>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20251113203041.419595-1-knecht.alexandre@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113203041.419595-1-knecht.alexandre@gmail.com>

Hi Alexandre,

On Thu, Nov 13, 2025 at 09:30:41PM +0100, Alexandre Knecht wrote:
> This patch enables handle-based rule positioning for JSON add/insert
> commands by using a context flag to distinguish between explicit and
> implicit command formats.
> 
> When processing JSON:
> - Explicit commands like {"add": {"rule": ...}} set no flag, allowing
>   handle fields to be converted to position for rule placement
> - Implicit format (bare objects like {"rule": ...}, used in export/import)
>   sets CTX_F_IMPLICIT flag, causing handles to be ignored for portability
> 
> This approach ensures that:
> - Explicit rule adds with handles work for positioning
> - Non-rule objects (tables, chains, sets, etc.) are unaffected
> - Export/import remains compatible (handles ignored)
> 
> The semantics for explicit rule commands are:
>   ADD with handle:    inserts rule AFTER the specified handle
>   INSERT with handle: inserts rule BEFORE the specified handle
> 
> Includes two comprehensive tests:
> - Test 0007: Verifies all object types work with add/insert/delete/replace
> - Test 0008: Verifies handle-based positioning and implicit format behavior
> 
> Link: https://patchwork.ozlabs.org/project/netfilter-devel/patch/20251029224530.1962783-2-knecht.alexandre@gmail.com/
> Suggested-by: Phil Sutter <phil@nwl.cc>
> Suggested-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Alexandre Knecht <knecht.alexandre@gmail.com>
> ---
>  src/parser_json.c                             |  41 ++++-
>  .../json/0007add_insert_delete_objects_0      | 159 ++++++++++++++++++
>  .../testcases/json/0008rule_position_handle_0 |  83 +++++++++
>  3 files changed, 280 insertions(+), 3 deletions(-)
>  create mode 100755 tests/shell/testcases/json/0007add_insert_delete_objects_0
>  create mode 100755 tests/shell/testcases/json/0008rule_position_handle_0
> 
> diff --git a/src/parser_json.c b/src/parser_json.c
> index 7b4f3384..ae052e7e 100644
> --- a/src/parser_json.c
> +++ b/src/parser_json.c
> @@ -51,6 +51,12 @@
>  #define CTX_F_MAP	(1 << 7)	/* LHS of map_expr */
>  #define CTX_F_CONCAT	(1 << 8)	/* inside concat_expr */
>  #define CTX_F_COLLAPSED	(1 << 9)
> +#define CTX_F_IMPLICIT	(1 << 10)	/* implicit add (export/import format) */
> +
> +/* Mask for flags that affect expression parsing context */
> +#define CTX_F_EXPR_MASK	(CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_DTYPE | \
> +			 CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP | \
> +			 CTX_F_CONCAT)

Maybe define as 'UINT32_MAX & ~(CTX_F_COLLAPSED | CTX_F_IMPLICIT)'
instead?

>  struct json_ctx {
>  	struct nft_ctx *nft;
> @@ -1725,10 +1731,14 @@ static struct expr *json_parse_expr(struct json_ctx *ctx, json_t *root)
>  		return NULL;
>  
>  	for (i = 0; i < array_size(cb_tbl); i++) {
> +		uint32_t expr_flags;
> +
>  		if (strcmp(type, cb_tbl[i].name))
>  			continue;
>  
> -		if ((cb_tbl[i].flags & ctx->flags) != ctx->flags) {
> +		/* Only check expression context flags, not command-level flags */
> +		expr_flags = ctx->flags & CTX_F_EXPR_MASK;
> +		if ((cb_tbl[i].flags & expr_flags) != expr_flags) {
>  			json_error(ctx, "Expression type %s not allowed in context (%s).",
>  				   type, ctx_flags_to_string(ctx));
>  			return NULL;
> @@ -3201,6 +3211,18 @@ static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
>  		h.index.id++;
>  	}
>  
> +	/* For explicit add/insert/create commands, handle is used for positioning.
> +	 * Convert handle to position for proper rule placement.
> +	 * Skip this for implicit adds (export/import format).
> +	 */
> +	if (!(ctx->flags & CTX_F_IMPLICIT) &&
> +	    !json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
> +		if (op == CMD_INSERT || op == CMD_ADD || op == CMD_CREATE) {
> +			h.position.id = h.handle.id;
> +			h.handle.id = 0;
> +		}
> +	}
> +
>  	rule = rule_alloc(int_loc, NULL);
>  
>  	json_unpack(root, "{s:s}", "comment", &comment);
> @@ -4352,8 +4374,21 @@ static struct cmd *json_parse_cmd(struct json_ctx *ctx, json_t *root)
>  
>  		return parse_cb_table[i].cb(ctx, tmp, parse_cb_table[i].op);
>  	}
> -	/* to accept 'list ruleset' output 1:1, try add command */
> -	return json_parse_cmd_add(ctx, root, CMD_ADD);
> +	/* to accept 'list ruleset' output 1:1, try add command
> +	 * Mark as implicit to distinguish from explicit add commands.
> +	 * This allows explicit {"add": {"rule": ...}} to use handle for positioning
> +	 * while implicit {"rule": ...} (export format) ignores handles.
> +	 */
> +	{
> +		uint32_t old_flags = ctx->flags;
> +		struct cmd *cmd;
> +
> +		ctx->flags |= CTX_F_IMPLICIT;
> +		cmd = json_parse_cmd_add(ctx, root, CMD_ADD);
> +		ctx->flags = old_flags;
> +
> +		return cmd;
> +	}

This use of nested blocks is uncommon in this project. I suggest to
either introduce a wrapper function or declare the two variables at the
start of the function's body.

>  }
>  
>  static int json_verify_metainfo(struct json_ctx *ctx, json_t *root)
> diff --git a/tests/shell/testcases/json/0007add_insert_delete_objects_0 b/tests/shell/testcases/json/0007add_insert_delete_objects_0
> new file mode 100755
> index 00000000..08f0eebe
> --- /dev/null
> +++ b/tests/shell/testcases/json/0007add_insert_delete_objects_0
> @@ -0,0 +1,159 @@
> +#!/bin/bash
> +
> +# NFT_TEST_REQUIRES(NFT_TEST_HAVE_json)
> +
> +# Comprehensive test for JSON add/insert/delete/replace operations
> +# Tests that all object types work correctly with JSON commands
> +
> +set -e
> +
> +$NFT flush ruleset
> +
> +# ===== ADD operations =====
> +
> +echo "Test 1: Add table"
> +$NFT -j -f - << 'EOF'
> +{"nftables": [{"add": {"table": {"family": "inet", "name": "test"}}}]}
> +EOF
> +
> +echo "Test 2: Add chain"
> +$NFT -j -f - << 'EOF'
> +{"nftables": [{"add": {"chain": {"family": "inet", "table": "test", "name": "input_chain", "type": "filter", "hook": "input", "prio": 0, "policy": "accept"}}}]}
> +EOF
> +
> +echo "Test 3: Add rule"
> +$NFT -j -f - << 'EOF'
> +{"nftables": [{"add": {"rule": {"family": "inet", "table": "test", "chain": "input_chain", "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": 22}}, {"accept": null}]}}}]}
> +EOF
> +
> +echo "Test 4: Add set"
> +$NFT -j -f - << 'EOF'
> +{"nftables": [{"add": {"set": {"family": "inet", "table": "test", "name": "test_set", "type": "ipv4_addr"}}}]}
> +EOF
> +
> +echo "Test 5: Add counter"
> +$NFT -j -f - << 'EOF'
> +{"nftables": [{"add": {"counter": {"family": "inet", "table": "test", "name": "test_counter"}}}]}
> +EOF
> +
> +echo "Test 6: Add quota"
> +$NFT -j -f - << 'EOF'
> +{"nftables": [{"add": {"quota": {"family": "inet", "table": "test", "name": "test_quota", "bytes": 1000000}}}]}
> +EOF
> +
> +# Verify all objects were created
> +$NFT list ruleset > /dev/null || { echo "Failed to list ruleset after add operations"; exit 1; }

This command does not do what the comment says. To verify object
creation, either use a series of 'nft list table/chain/set/...' commands
or compare against a stored ruleset dump. See
tests/shell/testcases/cache/0010_implicit_chain_0 for a simple example.

> +
> +# ===== INSERT operations =====
> +
> +echo "Test 7: Insert rule at beginning"
> +$NFT -j -f - << 'EOF'
> +{"nftables": [{"insert": {"rule": {"family": "inet", "table": "test", "chain": "input_chain", "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": 80}}, {"accept": null}]}}}]}
> +EOF
> +
> +# Verify rule was inserted at beginning
> +RULE_COUNT=$($NFT -a list chain inet test input_chain | grep -c "tcp dport")
> +if [ "$RULE_COUNT" != "2" ]; then
> +	echo "Test 7 failed: expected 2 rules, got $RULE_COUNT"
> +	exit 1
> +fi

This also does not check resulting position but merely asserts a second
rule was added. Since you introduce a second test dedicated to rule
insert/add (at position), maybe drop this here entirely?

> +
> +# ===== REPLACE operations =====
> +
> +echo "Test 8: Replace rule"
> +# Get handle of first rule
> +HANDLE=$($NFT -a list chain inet test input_chain | grep "tcp dport 80" | grep -o "handle [0-9]*" | awk '{print $2}')
> +if [ -z "$HANDLE" ]; then
> +	echo "Test 8 failed: could not find rule handle"
> +	exit 1
> +fi
> +
> +$NFT -j -f - << EOF
> +{"nftables": [{"replace": {"rule": {"family": "inet", "table": "test", "chain": "input_chain", "handle": $HANDLE, "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": 443}}, {"accept": null}]}}}]}
> +EOF
> +
> +# Verify rule was replaced
> +if ! $NFT list chain inet test input_chain | grep -q "tcp dport 443"; then
> +	echo "Test 8 failed: rule not replaced correctly"
> +	exit 1
> +fi
> +if $NFT list chain inet test input_chain | grep -q "tcp dport 80"; then
> +	echo "Test 8 failed: old rule still exists"
> +	exit 1
> +fi
> +
> +# ===== CREATE operations =====
> +
> +echo "Test 9: Create table (should work like add)"
> +$NFT -j -f - << 'EOF'
> +{"nftables": [{"create": {"table": {"family": "ip", "name": "created_table"}}}]}
> +EOF
> +
> +if ! $NFT list tables | grep -q "created_table"; then
> +	echo "Test 9 failed: table not created"
> +	exit 1
> +fi
> +
> +echo "Test 10: Create table that exists (should fail)"
> +if $NFT -j -f - 2>/dev/null << 'EOF'
> +{"nftables": [{"create": {"table": {"family": "ip", "name": "created_table"}}}]}
> +EOF
> +then
> +	echo "Test 10 failed: create should have failed for existing table"
> +	exit 1
> +fi
> +
> +# ===== DELETE operations =====
> +
> +echo "Test 11: Delete rule"
> +HANDLE=$($NFT -a list chain inet test input_chain | grep "tcp dport 22" | grep -o "handle [0-9]*" | awk '{print $2}')

HANDLE=$($NFT -a list chain inet test input_chain | sed -n 's/.*tcp dport 22 .* handle \([0-9]\+\)/\1/p')

(Single sed call instead of grep | grep | awk.)

> +$NFT -j -f - << EOF
> +{"nftables": [{"delete": {"rule": {"family": "inet", "table": "test", "chain": "input_chain", "handle": $HANDLE}}}]}
> +EOF
> +
> +if $NFT list chain inet test input_chain | grep -q "tcp dport 22"; then
> +	echo "Test 11 failed: rule not deleted"
> +	exit 1
> +fi
> +
> +echo "Test 12: Delete counter"
> +$NFT -j -f - << 'EOF'
> +{"nftables": [{"delete": {"counter": {"family": "inet", "table": "test", "name": "test_counter"}}}]}
> +EOF
> +
> +if $NFT list counters | grep -q "test_counter"; then
> +	echo "Test 12 failed: counter not deleted"
> +	exit 1
> +fi
> +
> +echo "Test 13: Delete set"
> +$NFT -j -f - << 'EOF'
> +{"nftables": [{"delete": {"set": {"family": "inet", "table": "test", "name": "test_set"}}}]}
> +EOF
> +
> +if $NFT list sets | grep -q "test_set"; then
> +	echo "Test 13 failed: set not deleted"
> +	exit 1
> +fi
> +
> +echo "Test 14: Delete chain"
> +$NFT -j -f - << 'EOF'
> +{"nftables": [{"delete": {"chain": {"family": "inet", "table": "test", "name": "input_chain"}}}]}
> +EOF
> +
> +if $NFT list chains | grep -q "input_chain"; then
> +	echo "Test 14 failed: chain not deleted"
> +	exit 1
> +fi
> +
> +echo "Test 15: Delete table"
> +$NFT -j -f - << 'EOF'
> +{"nftables": [{"delete": {"table": {"family": "inet", "name": "test"}}}]}
> +EOF
> +
> +if $NFT list tables | grep -q "table inet test"; then
> +	echo "Test 15 failed: table not deleted"
> +	exit 1
> +fi
> +
> +echo "All tests passed!"
> diff --git a/tests/shell/testcases/json/0008rule_position_handle_0 b/tests/shell/testcases/json/0008rule_position_handle_0
> new file mode 100755
> index 00000000..ea60690d
> --- /dev/null
> +++ b/tests/shell/testcases/json/0008rule_position_handle_0
> @@ -0,0 +1,83 @@
> +#!/bin/bash
> +
> +# NFT_TEST_REQUIRES(NFT_TEST_HAVE_json)
> +
> +# Test JSON handle-based rule positioning
> +# Verifies explicit format uses handle for positioning while implicit format ignores it
> +
> +set -e
> +
> +$NFT flush ruleset
> +
> +echo "Test 1: ADD with handle positions AFTER"
> +$NFT add table inet test
> +$NFT add chain inet test c
> +$NFT add rule inet test c tcp dport 22 accept
> +$NFT add rule inet test c tcp dport 80 accept

$NFT -f - <<EOF
table inet test {
	chain c {
		tcp dport 22 accept
		tcp dport 80 accept
	}
}
EOF

(More comprehensible, less process spawning.)

> +
> +# Get handle of first rule
> +HANDLE=$($NFT -a list chain inet test c | grep "tcp dport 22" | grep -o "handle [0-9]*" | awk '{print $2}')

Same as above, single sed call is possible.

> +
> +# Add after handle (should be between 22 and 80)
> +$NFT -j -f - <<EOF
> +{"nftables": [{"add": {"rule": {"family": "inet", "table": "test", "chain": "c", "handle": $HANDLE, "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": 443}}, {"accept": null}]}}}]}
> +EOF
> +
> +# Verify order: 22, 443, 80
> +RULES=$($NFT list chain inet test c | grep "tcp dport" | grep -o "tcp dport [0-9]*")

Drop the first grep call here? It is redundant wrt. the second one, no?

> +EXPECTED="tcp dport 22
> +tcp dport 443
> +tcp dport 80"
> +
> +if [ "$RULES" = "$EXPECTED" ]; then
> +	echo "PASS: Rule added after handle"
> +else
> +	echo "FAIL: Expected order 22,443,80, got:"
> +	echo "$RULES"
> +	exit 1
> +fi
> +
> +echo "Test 2: INSERT with handle positions BEFORE"
> +$NFT flush ruleset
> +$NFT add table inet test
> +$NFT add chain inet test c
> +$NFT add rule inet test c tcp dport 22 accept
> +$NFT add rule inet test c tcp dport 80 accept
> +
> +# Get handle of second rule
> +HANDLE=$($NFT -a list chain inet test c | grep "tcp dport 80" | grep -o "handle [0-9]*" | awk '{print $2}')
> +
> +# Insert before handle
> +$NFT -j -f - <<EOF
> +{"nftables": [{"insert": {"rule": {"family": "inet", "table": "test", "chain": "c", "handle": $HANDLE, "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": 443}}, {"accept": null}]}}}]}
> +EOF
> +
> +# Verify order: 22, 443, 80
> +RULES=$($NFT list chain inet test c | grep "tcp dport" | grep -o "tcp dport [0-9]*")
> +if [ "$RULES" = "$EXPECTED" ]; then
> +	echo "PASS: Rule inserted before handle"
> +else
> +	echo "FAIL: Expected order 22,443,80, got:"
> +	echo "$RULES"
> +	exit 1
> +fi

Please add insert without handle here to verify insert at first position
(covering up for the first test's part I suggested to drop).

Also please keep in mind that:

| $NFT insert rule t c handle N
| $NFT insert rule t c handle N

is different to:

| $NFT -f - <<EOF
| insert rule t c handle N
| insert rule t c handle N
| EOF

since the latter adds both rules in a single transaction. As Florian
pointed out, we should make sure multiple commands in single transaction
behave as expected (i.e., like separate commands) as well.

Thanks, Phil
