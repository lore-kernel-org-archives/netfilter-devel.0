Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 52D9B1B2
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Nov 2023 03:00:34 -0800 (PST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] json: deal appropriately with multidevice in chain
Date: Thu, 23 Nov 2023 12:00:28 +0100
Message-Id: <20231123110028.146580-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Chain device support is broken in JSON: listing does not include devices
and parser only deals with one single device.

Use existing json_parse_flowtable_devs() function, rename it to
json_parse_devs() to parse the device array.

Use the dev_array that contains the device names (as string) for the
listing.

Update incorrect .json-nft files in tests/shell.

Fixes: 3fdc7541fba0 ("src: add multidevice support for netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Uncovered while running tests for 5.10.

 src/json.c                                    | 25 ++---
 src/parser_json.c                             | 91 +++++++++----------
 .../chains/dumps/0021prio_0.json-nft          |  2 +-
 .../dumps/0042chain_variable_0.json-nft       |  2 +-
 .../chains/dumps/0043chain_ingress_0.json-nft |  2 +-
 5 files changed, 61 insertions(+), 61 deletions(-)

diff --git a/src/json.c b/src/json.c
index 81328ab3a4e4..6809cd50f0a8 100644
--- a/src/json.c
+++ b/src/json.c
@@ -257,9 +257,8 @@ static json_t *rule_print_json(struct output_ctx *octx,
=20
 static json_t *chain_print_json(const struct chain *chain)
 {
-	int priority, policy, n =3D 0;
-	struct expr *dev, *expr;
-	json_t *root, *tmp;
+	json_t *root, *tmp, *devs =3D NULL;
+	int priority, policy, i;
=20
 	root =3D json_pack("{s:s, s:s, s:s, s:I}",
 			 "family", family2str(chain->handle.family),
@@ -281,17 +280,19 @@ static json_t *chain_print_json(const struct chain *c=
hain)
 						    chain->hook.num),
 				"prio", priority,
 				"policy", chain_policy2str(policy));
-		if (chain->dev_expr) {
-			list_for_each_entry(expr, &chain->dev_expr->expressions, list) {
-				dev =3D expr;
-				n++;
-			}
-		}
=20
-		if (n =3D=3D 1) {
-			json_object_set_new(tmp, "dev",
-					    json_string(dev->identifier));
+		for (i =3D 0; i < chain->dev_array_len; i++) {
+			const char *dev =3D chain->dev_array[i];
+			if (!devs)
+				devs =3D json_string(dev);
+			else if (json_is_string(devs))
+				devs =3D json_pack("[o, s]", devs, dev);
+			else
+				json_array_append_new(devs, json_string(dev));
 		}
+		if (devs)
+			json_object_set_new(root, "dev", devs);
+
 		json_object_update(root, tmp);
 		json_decref(tmp);
 	}
diff --git a/src/parser_json.c b/src/parser_json.c
index 199241a97cdb..9e02bc344097 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3000,14 +3000,49 @@ static struct expr *parse_policy(const char *policy)
 				   sizeof(int) * BITS_PER_BYTE, &policy_num);
 }
=20
+static struct expr *json_parse_devs(struct json_ctx *ctx, json_t *root)
+{
+	struct expr *tmp, *expr =3D compound_expr_alloc(int_loc, EXPR_LIST);
+	const char *dev;
+	json_t *value;
+	size_t index;
+
+	if (!json_unpack(root, "s", &dev)) {
+		tmp =3D constant_expr_alloc(int_loc, &string_type,
+					  BYTEORDER_HOST_ENDIAN,
+					  strlen(dev) * BITS_PER_BYTE, dev);
+		compound_expr_add(expr, tmp);
+		return expr;
+	}
+	if (!json_is_array(root)) {
+		expr_free(expr);
+		return NULL;
+	}
+
+	json_array_foreach(root, index, value) {
+		if (json_unpack(value, "s", &dev)) {
+			json_error(ctx, "Invalid device at index %zu.",
+				   index);
+			expr_free(expr);
+			return NULL;
+		}
+		tmp =3D constant_expr_alloc(int_loc, &string_type,
+					  BYTEORDER_HOST_ENDIAN,
+					  strlen(dev) * BITS_PER_BYTE, dev);
+		compound_expr_add(expr, tmp);
+	}
+	return expr;
+}
+
 static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *=
root,
 					    enum cmd_ops op, enum cmd_obj obj)
 {
 	struct handle h =3D {
 		.table.location =3D *int_loc,
 	};
-	const char *family =3D "", *policy =3D "", *type, *hookstr, *name, *comme=
nt =3D NULL;
+	const char *family =3D "", *policy =3D "", *type, *hookstr, *comment =3D =
NULL;
 	struct chain *chain =3D NULL;
+	json_t *devs =3D NULL;
 	int prio;
=20
 	if (json_unpack_err(ctx, root, "{s:s, s:s}",
@@ -3062,16 +3097,15 @@ static struct cmd *json_parse_cmd_add_chain(struct =
json_ctx *ctx, json_t *root,
 		return NULL;
 	}
=20
-	if (!json_unpack(root, "{s:s}", "dev", &name)) {
-		struct expr *dev_expr, *expr;
+	json_unpack(root, "{s:o}", "dev", &devs);
=20
-		dev_expr =3D compound_expr_alloc(int_loc, EXPR_LIST);
-		expr =3D constant_expr_alloc(int_loc, &integer_type,
-					   BYTEORDER_HOST_ENDIAN,
-					   strlen(name) * BITS_PER_BYTE,
-					   name);
-		compound_expr_add(dev_expr, expr);
-		chain->dev_expr =3D dev_expr;
+	if (devs) {
+		chain->dev_expr =3D json_parse_devs(ctx, devs);
+		if (!chain->dev_expr) {
+			json_error(ctx, "Invalid chain dev.");
+			chain_free(chain);
+			return NULL;
+		}
 	}
=20
 	if (!json_unpack(root, "{s:s}", "policy", &policy)) {
@@ -3366,41 +3400,6 @@ static struct cmd *json_parse_cmd_add_element(struct=
 json_ctx *ctx,
 	return cmd_alloc(op, cmd_obj, &h, int_loc, expr);
 }
=20
-static struct expr *json_parse_flowtable_devs(struct json_ctx *ctx,
-					      json_t *root)
-{
-	struct expr *tmp, *expr =3D compound_expr_alloc(int_loc, EXPR_LIST);
-	const char *dev;
-	json_t *value;
-	size_t index;
-
-	if (!json_unpack(root, "s", &dev)) {
-		tmp =3D constant_expr_alloc(int_loc, &string_type,
-					  BYTEORDER_HOST_ENDIAN,
-					  strlen(dev) * BITS_PER_BYTE, dev);
-		compound_expr_add(expr, tmp);
-		return expr;
-	}
-	if (!json_is_array(root)) {
-		expr_free(expr);
-		return NULL;
-	}
-
-	json_array_foreach(root, index, value) {
-		if (json_unpack(value, "s", &dev)) {
-			json_error(ctx, "Invalid flowtable dev at index %zu.",
-				   index);
-			expr_free(expr);
-			return NULL;
-		}
-		tmp =3D constant_expr_alloc(int_loc, &string_type,
-					  BYTEORDER_HOST_ENDIAN,
-					  strlen(dev) * BITS_PER_BYTE, dev);
-		compound_expr_add(expr, tmp);
-	}
-	return expr;
-}
-
 static struct cmd *json_parse_cmd_add_flowtable(struct json_ctx *ctx,
 						json_t *root, enum cmd_ops op,
 						enum cmd_obj cmd_obj)
@@ -3461,7 +3460,7 @@ static struct cmd *json_parse_cmd_add_flowtable(struc=
t json_ctx *ctx,
 				    sizeof(int) * BITS_PER_BYTE, &prio);
=20
 	if (devs) {
-		flowtable->dev_expr =3D json_parse_flowtable_devs(ctx, devs);
+		flowtable->dev_expr =3D json_parse_devs(ctx, devs);
 		if (!flowtable->dev_expr) {
 			json_error(ctx, "Invalid flowtable dev.");
 			flowtable_free(flowtable);
diff --git a/tests/shell/testcases/chains/dumps/0021prio_0.json-nft b/tests=
/shell/testcases/chains/dumps/0021prio_0.json-nft
index 4ea8c52e1f65..d55bc213f6ba 100644
--- a/tests/shell/testcases/chains/dumps/0021prio_0.json-nft
+++ b/tests/shell/testcases/chains/dumps/0021prio_0.json-nft
@@ -1 +1 @@
-{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "x",=
 "handle": 0}}, {"chain": {"family": "ip", "table": "x", "name": "preroutin=
grawm11", "handle": 0, "type": "filter", "hook": "prerouting", "prio": -311=
, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "p=
reroutingrawm10", "handle": 0, "type": "filter", "hook": "prerouting", "pri=
o": -310, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "n=
ame": "preroutingraw", "handle": 0, "type": "filter", "hook": "prerouting",=
 "prio": -300, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x=
", "name": "preroutingrawp10", "handle": 0, "type": "filter", "hook": "prer=
outing", "prio": -290, "policy": "accept"}}, {"chain": {"family": "ip", "ta=
ble": "x", "name": "preroutingrawp11", "handle": 0, "type": "filter", "hook=
": "prerouting", "prio": -289, "policy": "accept"}}, {"chain": {"family": "=
ip", "table": "x", "name": "preroutingmanglem11", "handle": 0, "type": "fil=
ter", "hook": "prerouting", "prio": -161, "policy": "accept"}}, {"chain": {=
"family": "ip", "table": "x", "name": "preroutingmanglem10", "handle": 0, "=
type": "filter", "hook": "prerouting", "prio": -160, "policy": "accept"}}, =
{"chain": {"family": "ip", "table": "x", "name": "preroutingmangle", "handl=
e": 0, "type": "filter", "hook": "prerouting", "prio": -150, "policy": "acc=
ept"}}, {"chain": {"family": "ip", "table": "x", "name": "preroutingmanglep=
10", "handle": 0, "type": "filter", "hook": "prerouting", "prio": -140, "po=
licy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "prerou=
tingmanglep11", "handle": 0, "type": "filter", "hook": "prerouting", "prio"=
: -139, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "nam=
e": "preroutingfilterm11", "handle": 0, "type": "filter", "hook": "prerouti=
ng", "prio": -11, "policy": "accept"}}, {"chain": {"family": "ip", "table":=
 "x", "name": "preroutingfilterm10", "handle": 0, "type": "filter", "hook":=
 "prerouting", "prio": -10, "policy": "accept"}}, {"chain": {"family": "ip"=
, "table": "x", "name": "preroutingfilter", "handle": 0, "type": "filter", =
"hook": "prerouting", "prio": 0, "policy": "accept"}}, {"chain": {"family":=
 "ip", "table": "x", "name": "preroutingfilterp10", "handle": 0, "type": "f=
ilter", "hook": "prerouting", "prio": 10, "policy": "accept"}}, {"chain": {=
"family": "ip", "table": "x", "name": "preroutingfilterp11", "handle": 0, "=
type": "filter", "hook": "prerouting", "prio": 11, "policy": "accept"}}, {"=
chain": {"family": "ip", "table": "x", "name": "preroutingsecuritym11", "ha=
ndle": 0, "type": "filter", "hook": "prerouting", "prio": 39, "policy": "ac=
cept"}}, {"chain": {"family": "ip", "table": "x", "name": "preroutingsecuri=
tym10", "handle": 0, "type": "filter", "hook": "prerouting", "prio": 40, "p=
olicy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "prero=
utingsecurity", "handle": 0, "type": "filter", "hook": "prerouting", "prio"=
: 50, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name"=
: "preroutingsecurityp10", "handle": 0, "type": "filter", "hook": "prerouti=
ng", "prio": 60, "policy": "accept"}}, {"chain": {"family": "ip", "table": =
"x", "name": "preroutingsecurityp11", "handle": 0, "type": "filter", "hook"=
: "prerouting", "prio": 61, "policy": "accept"}}, {"chain": {"family": "ip"=
, "table": "x", "name": "inputrawm11", "handle": 0, "type": "filter", "hook=
": "input", "prio": -311, "policy": "accept"}}, {"chain": {"family": "ip", =
"table": "x", "name": "inputrawm10", "handle": 0, "type": "filter", "hook":=
 "input", "prio": -310, "policy": "accept"}}, {"chain": {"family": "ip", "t=
able": "x", "name": "inputraw", "handle": 0, "type": "filter", "hook": "inp=
ut", "prio": -300, "policy": "accept"}}, {"chain": {"family": "ip", "table"=
: "x", "name": "inputrawp10", "handle": 0, "type": "filter", "hook": "input=
", "prio": -290, "policy": "accept"}}, {"chain": {"family": "ip", "table": =
"x", "name": "inputrawp11", "handle": 0, "type": "filter", "hook": "input",=
 "prio": -289, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x=
", "name": "inputmanglem11", "handle": 0, "type": "filter", "hook": "input"=
, "prio": -161, "policy": "accept"}}, {"chain": {"family": "ip", "table": "=
x", "name": "inputmanglem10", "handle": 0, "type": "filter", "hook": "input=
", "prio": -160, "policy": "accept"}}, {"chain": {"family": "ip", "table": =
"x", "name": "inputmangle", "handle": 0, "type": "filter", "hook": "input",=
 "prio": -150, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x=
", "name": "inputmanglep10", "handle": 0, "type": "filter", "hook": "input"=
, "prio": -140, "policy": "accept"}}, {"chain": {"family": "ip", "table": "=
x", "name": "inputmanglep11", "handle": 0, "type": "filter", "hook": "input=
", "prio": -139, "policy": "accept"}}, {"chain": {"family": "ip", "table": =
"x", "name": "inputfilterm11", "handle": 0, "type": "filter", "hook": "inpu=
t", "prio": -11, "policy": "accept"}}, {"chain": {"family": "ip", "table": =
"x", "name": "inputfilterm10", "handle": 0, "type": "filter", "hook": "inpu=
t", "prio": -10, "policy": "accept"}}, {"chain": {"family": "ip", "table": =
"x", "name": "inputfilter", "handle": 0, "type": "filter", "hook": "input",=
 "prio": 0, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", =
"name": "inputfilterp10", "handle": 0, "type": "filter", "hook": "input", "=
prio": 10, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "=
name": "inputfilterp11", "handle": 0, "type": "filter", "hook": "input", "p=
rio": 11, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "n=
ame": "inputsecuritym11", "handle": 0, "type": "filter", "hook": "input", "=
prio": 39, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "=
name": "inputsecuritym10", "handle": 0, "type": "filter", "hook": "input", =
"prio": 40, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", =
"name": "inputsecurity", "handle": 0, "type": "filter", "hook": "input", "p=
rio": 50, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "n=
ame": "inputsecurityp10", "handle": 0, "type": "filter", "hook": "input", "=
prio": 60, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "=
name": "inputsecurityp11", "handle": 0, "type": "filter", "hook": "input", =
"prio": 61, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", =
"name": "forwardrawm11", "handle": 0, "type": "filter", "hook": "forward", =
"prio": -311, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x"=
, "name": "forwardrawm10", "handle": 0, "type": "filter", "hook": "forward"=
, "prio": -310, "policy": "accept"}}, {"chain": {"family": "ip", "table": "=
x", "name": "forwardraw", "handle": 0, "type": "filter", "hook": "forward",=
 "prio": -300, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x=
", "name": "forwardrawp10", "handle": 0, "type": "filter", "hook": "forward=
", "prio": -290, "policy": "accept"}}, {"chain": {"family": "ip", "table": =
"x", "name": "forwardrawp11", "handle": 0, "type": "filter", "hook": "forwa=
rd", "prio": -289, "policy": "accept"}}, {"chain": {"family": "ip", "table"=
: "x", "name": "forwardmanglem11", "handle": 0, "type": "filter", "hook": "=
forward", "prio": -161, "policy": "accept"}}, {"chain": {"family": "ip", "t=
able": "x", "name": "forwardmanglem10", "handle": 0, "type": "filter", "hoo=
k": "forward", "prio": -160, "policy": "accept"}}, {"chain": {"family": "ip=
", "table": "x", "name": "forwardmangle", "handle": 0, "type": "filter", "h=
ook": "forward", "prio": -150, "policy": "accept"}}, {"chain": {"family": "=
ip", "table": "x", "name": "forwardmanglep10", "handle": 0, "type": "filter=
", "hook": "forward", "prio": -140, "policy": "accept"}}, {"chain": {"famil=
y": "ip", "table": "x", "name": "forwardmanglep11", "handle": 0, "type": "f=
ilter", "hook": "forward", "prio": -139, "policy": "accept"}}, {"chain": {"=
family": "ip", "table": "x", "name": "forwardfilterm11", "handle": 0, "type=
": "filter", "hook": "forward", "prio": -11, "policy": "accept"}}, {"chain"=
: {"family": "ip", "table": "x", "name": "forwardfilterm10", "handle": 0, "=
type": "filter", "hook": "forward", "prio": -10, "policy": "accept"}}, {"ch=
ain": {"family": "ip", "table": "x", "name": "forwardfilter", "handle": 0, =
"type": "filter", "hook": "forward", "prio": 0, "policy": "accept"}}, {"cha=
in": {"family": "ip", "table": "x", "name": "forwardfilterp10", "handle": 0=
, "type": "filter", "hook": "forward", "prio": 10, "policy": "accept"}}, {"=
chain": {"family": "ip", "table": "x", "name": "forwardfilterp11", "handle"=
: 0, "type": "filter", "hook": "forward", "prio": 11, "policy": "accept"}},=
 {"chain": {"family": "ip", "table": "x", "name": "forwardsecuritym11", "ha=
ndle": 0, "type": "filter", "hook": "forward", "prio": 39, "policy": "accep=
t"}}, {"chain": {"family": "ip", "table": "x", "name": "forwardsecuritym10"=
, "handle": 0, "type": "filter", "hook": "forward", "prio": 40, "policy": "=
accept"}}, {"chain": {"family": "ip", "table": "x", "name": "forwardsecurit=
y", "handle": 0, "type": "filter", "hook": "forward", "prio": 50, "policy":=
 "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "forwardsecur=
ityp10", "handle": 0, "type": "filter", "hook": "forward", "prio": 60, "pol=
icy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "forward=
securityp11", "handle": 0, "type": "filter", "hook": "forward", "prio": 61,=
 "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "ou=
tputrawm11", "handle": 0, "type": "filter", "hook": "output", "prio": -311,=
 "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "ou=
tputrawm10", "handle": 0, "type": "filter", "hook": "output", "prio": -310,=
 "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "ou=
tputraw", "handle": 0, "type": "filter", "hook": "output", "prio": -300, "p=
olicy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "outpu=
trawp10", "handle": 0, "type": "filter", "hook": "output", "prio": -290, "p=
olicy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "outpu=
trawp11", "handle": 0, "type": "filter", "hook": "output", "prio": -289, "p=
olicy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "outpu=
tmanglem11", "handle": 0, "type": "filter", "hook": "output", "prio": -161,=
 "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "ou=
tputmanglem10", "handle": 0, "type": "filter", "hook": "output", "prio": -1=
60, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": =
"outputmangle", "handle": 0, "type": "filter", "hook": "output", "prio": -1=
50, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": =
"outputmanglep10", "handle": 0, "type": "filter", "hook": "output", "prio":=
 -140, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name=
": "outputmanglep11", "handle": 0, "type": "filter", "hook": "output", "pri=
o": -139, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "n=
ame": "outputfilterm11", "handle": 0, "type": "filter", "hook": "output", "=
prio": -11, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", =
"name": "outputfilterm10", "handle": 0, "type": "filter", "hook": "output",=
 "prio": -10, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x"=
, "name": "outputfilter", "handle": 0, "type": "filter", "hook": "output", =
"prio": 0, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "=
name": "outputfilterp10", "handle": 0, "type": "filter", "hook": "output", =
"prio": 10, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", =
"name": "outputfilterp11", "handle": 0, "type": "filter", "hook": "output",=
 "prio": 11, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x",=
 "name": "outputsecuritym11", "handle": 0, "type": "filter", "hook": "outpu=
t", "prio": 39, "policy": "accept"}}, {"chain": {"family": "ip", "table": "=
x", "name": "outputsecuritym10", "handle": 0, "type": "filter", "hook": "ou=
tput", "prio": 40, "policy": "accept"}}, {"chain": {"family": "ip", "table"=
: "x", "name": "outputsecurity", "handle": 0, "type": "filter", "hook": "ou=
tput", "prio": 50, "policy": "accept"}}, {"chain": {"family": "ip", "table"=
: "x", "name": "outputsecurityp10", "handle": 0, "type": "filter", "hook": =
"output", "prio": 60, "policy": "accept"}}, {"chain": {"family": "ip", "tab=
le": "x", "name": "outputsecurityp11", "handle": 0, "type": "filter", "hook=
": "output", "prio": 61, "policy": "accept"}}, {"chain": {"family": "ip", "=
table": "x", "name": "postroutingrawm11", "handle": 0, "type": "filter", "h=
ook": "postrouting", "prio": -311, "policy": "accept"}}, {"chain": {"family=
": "ip", "table": "x", "name": "postroutingrawm10", "handle": 0, "type": "f=
ilter", "hook": "postrouting", "prio": -310, "policy": "accept"}}, {"chain"=
: {"family": "ip", "table": "x", "name": "postroutingraw", "handle": 0, "ty=
pe": "filter", "hook": "postrouting", "prio": -300, "policy": "accept"}}, {=
"chain": {"family": "ip", "table": "x", "name": "postroutingrawp10", "handl=
e": 0, "type": "filter", "hook": "postrouting", "prio": -290, "policy": "ac=
cept"}}, {"chain": {"family": "ip", "table": "x", "name": "postroutingrawp1=
1", "handle": 0, "type": "filter", "hook": "postrouting", "prio": -289, "po=
licy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "postro=
utingmanglem11", "handle": 0, "type": "filter", "hook": "postrouting", "pri=
o": -161, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "n=
ame": "postroutingmanglem10", "handle": 0, "type": "filter", "hook": "postr=
outing", "prio": -160, "policy": "accept"}}, {"chain": {"family": "ip", "ta=
ble": "x", "name": "postroutingmangle", "handle": 0, "type": "filter", "hoo=
k": "postrouting", "prio": -150, "policy": "accept"}}, {"chain": {"family":=
 "ip", "table": "x", "name": "postroutingmanglep10", "handle": 0, "type": "=
filter", "hook": "postrouting", "prio": -140, "policy": "accept"}}, {"chain=
": {"family": "ip", "table": "x", "name": "postroutingmanglep11", "handle":=
 0, "type": "filter", "hook": "postrouting", "prio": -139, "policy": "accep=
t"}}, {"chain": {"family": "ip", "table": "x", "name": "postroutingfilterm1=
1", "handle": 0, "type": "filter", "hook": "postrouting", "prio": -11, "pol=
icy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "postrou=
tingfilterm10", "handle": 0, "type": "filter", "hook": "postrouting", "prio=
": -10, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "nam=
e": "postroutingfilter", "handle": 0, "type": "filter", "hook": "postroutin=
g", "prio": 0, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x=
", "name": "postroutingfilterp10", "handle": 0, "type": "filter", "hook": "=
postrouting", "prio": 10, "policy": "accept"}}, {"chain": {"family": "ip", =
"table": "x", "name": "postroutingfilterp11", "handle": 0, "type": "filter"=
, "hook": "postrouting", "prio": 11, "policy": "accept"}}, {"chain": {"fami=
ly": "ip", "table": "x", "name": "postroutingsecuritym11", "handle": 0, "ty=
pe": "filter", "hook": "postrouting", "prio": 39, "policy": "accept"}}, {"c=
hain": {"family": "ip", "table": "x", "name": "postroutingsecuritym10", "ha=
ndle": 0, "type": "filter", "hook": "postrouting", "prio": 40, "policy": "a=
ccept"}}, {"chain": {"family": "ip", "table": "x", "name": "postroutingsecu=
rity", "handle": 0, "type": "filter", "hook": "postrouting", "prio": 50, "p=
olicy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "postr=
outingsecurityp10", "handle": 0, "type": "filter", "hook": "postrouting", "=
prio": 60, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "=
name": "postroutingsecurityp11", "handle": 0, "type": "filter", "hook": "po=
strouting", "prio": 61, "policy": "accept"}}, {"chain": {"family": "ip", "t=
able": "x", "name": "preroutingdstnatm11", "handle": 0, "type": "filter", "=
hook": "prerouting", "prio": -111, "policy": "accept"}}, {"chain": {"family=
": "ip", "table": "x", "name": "preroutingdstnatm10", "handle": 0, "type": =
"filter", "hook": "prerouting", "prio": -110, "policy": "accept"}}, {"chain=
": {"family": "ip", "table": "x", "name": "preroutingdstnat", "handle": 0, =
"type": "filter", "hook": "prerouting", "prio": -100, "policy": "accept"}},=
 {"chain": {"family": "ip", "table": "x", "name": "preroutingdstnatp10", "h=
andle": 0, "type": "filter", "hook": "prerouting", "prio": -90, "policy": "=
accept"}}, {"chain": {"family": "ip", "table": "x", "name": "preroutingdstn=
atp11", "handle": 0, "type": "filter", "hook": "prerouting", "prio": -89, "=
policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "post=
routingsrcnatm11", "handle": 0, "type": "filter", "hook": "postrouting", "p=
rio": 89, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "n=
ame": "postroutingsrcnatm10", "handle": 0, "type": "filter", "hook": "postr=
outing", "prio": 90, "policy": "accept"}}, {"chain": {"family": "ip", "tabl=
e": "x", "name": "postroutingsrcnat", "handle": 0, "type": "filter", "hook"=
: "postrouting", "prio": 100, "policy": "accept"}}, {"chain": {"family": "i=
p", "table": "x", "name": "postroutingsrcnatp10", "handle": 0, "type": "fil=
ter", "hook": "postrouting", "prio": 110, "policy": "accept"}}, {"chain": {=
"family": "ip", "table": "x", "name": "postroutingsrcnatp11", "handle": 0, =
"type": "filter", "hook": "postrouting", "prio": 111, "policy": "accept"}},=
 {"table": {"family": "ip6", "name": "x", "handle": 0}}, {"chain": {"family=
": "ip6", "table": "x", "name": "preroutingrawm11", "handle": 0, "type": "f=
ilter", "hook": "prerouting", "prio": -311, "policy": "accept"}}, {"chain":=
 {"family": "ip6", "table": "x", "name": "preroutingrawm10", "handle": 0, "=
type": "filter", "hook": "prerouting", "prio": -310, "policy": "accept"}}, =
{"chain": {"family": "ip6", "table": "x", "name": "preroutingraw", "handle"=
: 0, "type": "filter", "hook": "prerouting", "prio": -300, "policy": "accep=
t"}}, {"chain": {"family": "ip6", "table": "x", "name": "preroutingrawp10",=
 "handle": 0, "type": "filter", "hook": "prerouting", "prio": -290, "policy=
": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "preroutin=
grawp11", "handle": 0, "type": "filter", "hook": "prerouting", "prio": -289=
, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "=
preroutingmanglem11", "handle": 0, "type": "filter", "hook": "prerouting", =
"prio": -161, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x=
", "name": "preroutingmanglem10", "handle": 0, "type": "filter", "hook": "p=
rerouting", "prio": -160, "policy": "accept"}}, {"chain": {"family": "ip6",=
 "table": "x", "name": "preroutingmangle", "handle": 0, "type": "filter", "=
hook": "prerouting", "prio": -150, "policy": "accept"}}, {"chain": {"family=
": "ip6", "table": "x", "name": "preroutingmanglep10", "handle": 0, "type":=
 "filter", "hook": "prerouting", "prio": -140, "policy": "accept"}}, {"chai=
n": {"family": "ip6", "table": "x", "name": "preroutingmanglep11", "handle"=
: 0, "type": "filter", "hook": "prerouting", "prio": -139, "policy": "accep=
t"}}, {"chain": {"family": "ip6", "table": "x", "name": "preroutingfilterm1=
1", "handle": 0, "type": "filter", "hook": "prerouting", "prio": -11, "poli=
cy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "prerout=
ingfilterm10", "handle": 0, "type": "filter", "hook": "prerouting", "prio":=
 -10, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name=
": "preroutingfilter", "handle": 0, "type": "filter", "hook": "prerouting",=
 "prio": 0, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x",=
 "name": "preroutingfilterp10", "handle": 0, "type": "filter", "hook": "pre=
routing", "prio": 10, "policy": "accept"}}, {"chain": {"family": "ip6", "ta=
ble": "x", "name": "preroutingfilterp11", "handle": 0, "type": "filter", "h=
ook": "prerouting", "prio": 11, "policy": "accept"}}, {"chain": {"family": =
"ip6", "table": "x", "name": "preroutingsecuritym11", "handle": 0, "type": =
"filter", "hook": "prerouting", "prio": 39, "policy": "accept"}}, {"chain":=
 {"family": "ip6", "table": "x", "name": "preroutingsecuritym10", "handle":=
 0, "type": "filter", "hook": "prerouting", "prio": 40, "policy": "accept"}=
}, {"chain": {"family": "ip6", "table": "x", "name": "preroutingsecurity", =
"handle": 0, "type": "filter", "hook": "prerouting", "prio": 50, "policy": =
"accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "preroutingse=
curityp10", "handle": 0, "type": "filter", "hook": "prerouting", "prio": 60=
, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "=
preroutingsecurityp11", "handle": 0, "type": "filter", "hook": "prerouting"=
, "prio": 61, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x=
", "name": "inputrawm11", "handle": 0, "type": "filter", "hook": "input", "=
prio": -311, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x"=
, "name": "inputrawm10", "handle": 0, "type": "filter", "hook": "input", "p=
rio": -310, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x",=
 "name": "inputraw", "handle": 0, "type": "filter", "hook": "input", "prio"=
: -300, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "na=
me": "inputrawp10", "handle": 0, "type": "filter", "hook": "input", "prio":=
 -290, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "nam=
e": "inputrawp11", "handle": 0, "type": "filter", "hook": "input", "prio": =
-289, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name=
": "inputmanglem11", "handle": 0, "type": "filter", "hook": "input", "prio"=
: -161, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "na=
me": "inputmanglem10", "handle": 0, "type": "filter", "hook": "input", "pri=
o": -160, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "=
name": "inputmangle", "handle": 0, "type": "filter", "hook": "input", "prio=
": -150, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "n=
ame": "inputmanglep10", "handle": 0, "type": "filter", "hook": "input", "pr=
io": -140, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", =
"name": "inputmanglep11", "handle": 0, "type": "filter", "hook": "input", "=
prio": -139, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x"=
, "name": "inputfilterm11", "handle": 0, "type": "filter", "hook": "input",=
 "prio": -11, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x=
", "name": "inputfilterm10", "handle": 0, "type": "filter", "hook": "input"=
, "prio": -10, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "=
x", "name": "inputfilter", "handle": 0, "type": "filter", "hook": "input", =
"prio": 0, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", =
"name": "inputfilterp10", "handle": 0, "type": "filter", "hook": "input", "=
prio": 10, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", =
"name": "inputfilterp11", "handle": 0, "type": "filter", "hook": "input", "=
prio": 11, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", =
"name": "inputsecuritym11", "handle": 0, "type": "filter", "hook": "input",=
 "prio": 39, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x"=
, "name": "inputsecuritym10", "handle": 0, "type": "filter", "hook": "input=
", "prio": 40, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "=
x", "name": "inputsecurity", "handle": 0, "type": "filter", "hook": "input"=
, "prio": 50, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x=
", "name": "inputsecurityp10", "handle": 0, "type": "filter", "hook": "inpu=
t", "prio": 60, "policy": "accept"}}, {"chain": {"family": "ip6", "table": =
"x", "name": "inputsecurityp11", "handle": 0, "type": "filter", "hook": "in=
put", "prio": 61, "policy": "accept"}}, {"chain": {"family": "ip6", "table"=
: "x", "name": "forwardrawm11", "handle": 0, "type": "filter", "hook": "for=
ward", "prio": -311, "policy": "accept"}}, {"chain": {"family": "ip6", "tab=
le": "x", "name": "forwardrawm10", "handle": 0, "type": "filter", "hook": "=
forward", "prio": -310, "policy": "accept"}}, {"chain": {"family": "ip6", "=
table": "x", "name": "forwardraw", "handle": 0, "type": "filter", "hook": "=
forward", "prio": -300, "policy": "accept"}}, {"chain": {"family": "ip6", "=
table": "x", "name": "forwardrawp10", "handle": 0, "type": "filter", "hook"=
: "forward", "prio": -290, "policy": "accept"}}, {"chain": {"family": "ip6"=
, "table": "x", "name": "forwardrawp11", "handle": 0, "type": "filter", "ho=
ok": "forward", "prio": -289, "policy": "accept"}}, {"chain": {"family": "i=
p6", "table": "x", "name": "forwardmanglem11", "handle": 0, "type": "filter=
", "hook": "forward", "prio": -161, "policy": "accept"}}, {"chain": {"famil=
y": "ip6", "table": "x", "name": "forwardmanglem10", "handle": 0, "type": "=
filter", "hook": "forward", "prio": -160, "policy": "accept"}}, {"chain": {=
"family": "ip6", "table": "x", "name": "forwardmangle", "handle": 0, "type"=
: "filter", "hook": "forward", "prio": -150, "policy": "accept"}}, {"chain"=
: {"family": "ip6", "table": "x", "name": "forwardmanglep10", "handle": 0, =
"type": "filter", "hook": "forward", "prio": -140, "policy": "accept"}}, {"=
chain": {"family": "ip6", "table": "x", "name": "forwardmanglep11", "handle=
": 0, "type": "filter", "hook": "forward", "prio": -139, "policy": "accept"=
}}, {"chain": {"family": "ip6", "table": "x", "name": "forwardfilterm11", "=
handle": 0, "type": "filter", "hook": "forward", "prio": -11, "policy": "ac=
cept"}}, {"chain": {"family": "ip6", "table": "x", "name": "forwardfilterm1=
0", "handle": 0, "type": "filter", "hook": "forward", "prio": -10, "policy"=
: "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "forwardfil=
ter", "handle": 0, "type": "filter", "hook": "forward", "prio": 0, "policy"=
: "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "forwardfil=
terp10", "handle": 0, "type": "filter", "hook": "forward", "prio": 10, "pol=
icy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "forwar=
dfilterp11", "handle": 0, "type": "filter", "hook": "forward", "prio": 11, =
"policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "fo=
rwardsecuritym11", "handle": 0, "type": "filter", "hook": "forward", "prio"=
: 39, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name=
": "forwardsecuritym10", "handle": 0, "type": "filter", "hook": "forward", =
"prio": 40, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x",=
 "name": "forwardsecurity", "handle": 0, "type": "filter", "hook": "forward=
", "prio": 50, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "=
x", "name": "forwardsecurityp10", "handle": 0, "type": "filter", "hook": "f=
orward", "prio": 60, "policy": "accept"}}, {"chain": {"family": "ip6", "tab=
le": "x", "name": "forwardsecurityp11", "handle": 0, "type": "filter", "hoo=
k": "forward", "prio": 61, "policy": "accept"}}, {"chain": {"family": "ip6"=
, "table": "x", "name": "outputrawm11", "handle": 0, "type": "filter", "hoo=
k": "output", "prio": -311, "policy": "accept"}}, {"chain": {"family": "ip6=
", "table": "x", "name": "outputrawm10", "handle": 0, "type": "filter", "ho=
ok": "output", "prio": -310, "policy": "accept"}}, {"chain": {"family": "ip=
6", "table": "x", "name": "outputraw", "handle": 0, "type": "filter", "hook=
": "output", "prio": -300, "policy": "accept"}}, {"chain": {"family": "ip6"=
, "table": "x", "name": "outputrawp10", "handle": 0, "type": "filter", "hoo=
k": "output", "prio": -290, "policy": "accept"}}, {"chain": {"family": "ip6=
", "table": "x", "name": "outputrawp11", "handle": 0, "type": "filter", "ho=
ok": "output", "prio": -289, "policy": "accept"}}, {"chain": {"family": "ip=
6", "table": "x", "name": "outputmanglem11", "handle": 0, "type": "filter",=
 "hook": "output", "prio": -161, "policy": "accept"}}, {"chain": {"family":=
 "ip6", "table": "x", "name": "outputmanglem10", "handle": 0, "type": "filt=
er", "hook": "output", "prio": -160, "policy": "accept"}}, {"chain": {"fami=
ly": "ip6", "table": "x", "name": "outputmangle", "handle": 0, "type": "fil=
ter", "hook": "output", "prio": -150, "policy": "accept"}}, {"chain": {"fam=
ily": "ip6", "table": "x", "name": "outputmanglep10", "handle": 0, "type": =
"filter", "hook": "output", "prio": -140, "policy": "accept"}}, {"chain": {=
"family": "ip6", "table": "x", "name": "outputmanglep11", "handle": 0, "typ=
e": "filter", "hook": "output", "prio": -139, "policy": "accept"}}, {"chain=
": {"family": "ip6", "table": "x", "name": "outputfilterm11", "handle": 0, =
"type": "filter", "hook": "output", "prio": -11, "policy": "accept"}}, {"ch=
ain": {"family": "ip6", "table": "x", "name": "outputfilterm10", "handle": =
0, "type": "filter", "hook": "output", "prio": -10, "policy": "accept"}}, {=
"chain": {"family": "ip6", "table": "x", "name": "outputfilter", "handle": =
0, "type": "filter", "hook": "output", "prio": 0, "policy": "accept"}}, {"c=
hain": {"family": "ip6", "table": "x", "name": "outputfilterp10", "handle":=
 0, "type": "filter", "hook": "output", "prio": 10, "policy": "accept"}}, {=
"chain": {"family": "ip6", "table": "x", "name": "outputfilterp11", "handle=
": 0, "type": "filter", "hook": "output", "prio": 11, "policy": "accept"}},=
 {"chain": {"family": "ip6", "table": "x", "name": "outputsecuritym11", "ha=
ndle": 0, "type": "filter", "hook": "output", "prio": 39, "policy": "accept=
"}}, {"chain": {"family": "ip6", "table": "x", "name": "outputsecuritym10",=
 "handle": 0, "type": "filter", "hook": "output", "prio": 40, "policy": "ac=
cept"}}, {"chain": {"family": "ip6", "table": "x", "name": "outputsecurity"=
, "handle": 0, "type": "filter", "hook": "output", "prio": 50, "policy": "a=
ccept"}}, {"chain": {"family": "ip6", "table": "x", "name": "outputsecurity=
p10", "handle": 0, "type": "filter", "hook": "output", "prio": 60, "policy"=
: "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "outputsecu=
rityp11", "handle": 0, "type": "filter", "hook": "output", "prio": 61, "pol=
icy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "postro=
utingrawm11", "handle": 0, "type": "filter", "hook": "postrouting", "prio":=
 -311, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "nam=
e": "postroutingrawm10", "handle": 0, "type": "filter", "hook": "postroutin=
g", "prio": -310, "policy": "accept"}}, {"chain": {"family": "ip6", "table"=
: "x", "name": "postroutingraw", "handle": 0, "type": "filter", "hook": "po=
strouting", "prio": -300, "policy": "accept"}}, {"chain": {"family": "ip6",=
 "table": "x", "name": "postroutingrawp10", "handle": 0, "type": "filter", =
"hook": "postrouting", "prio": -290, "policy": "accept"}}, {"chain": {"fami=
ly": "ip6", "table": "x", "name": "postroutingrawp11", "handle": 0, "type":=
 "filter", "hook": "postrouting", "prio": -289, "policy": "accept"}}, {"cha=
in": {"family": "ip6", "table": "x", "name": "postroutingmanglem11", "handl=
e": 0, "type": "filter", "hook": "postrouting", "prio": -161, "policy": "ac=
cept"}}, {"chain": {"family": "ip6", "table": "x", "name": "postroutingmang=
lem10", "handle": 0, "type": "filter", "hook": "postrouting", "prio": -160,=
 "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "p=
ostroutingmangle", "handle": 0, "type": "filter", "hook": "postrouting", "p=
rio": -150, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x",=
 "name": "postroutingmanglep10", "handle": 0, "type": "filter", "hook": "po=
strouting", "prio": -140, "policy": "accept"}}, {"chain": {"family": "ip6",=
 "table": "x", "name": "postroutingmanglep11", "handle": 0, "type": "filter=
", "hook": "postrouting", "prio": -139, "policy": "accept"}}, {"chain": {"f=
amily": "ip6", "table": "x", "name": "postroutingfilterm11", "handle": 0, "=
type": "filter", "hook": "postrouting", "prio": -11, "policy": "accept"}}, =
{"chain": {"family": "ip6", "table": "x", "name": "postroutingfilterm10", "=
handle": 0, "type": "filter", "hook": "postrouting", "prio": -10, "policy":=
 "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "postrouting=
filter", "handle": 0, "type": "filter", "hook": "postrouting", "prio": 0, "=
policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "pos=
troutingfilterp10", "handle": 0, "type": "filter", "hook": "postrouting", "=
prio": 10, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", =
"name": "postroutingfilterp11", "handle": 0, "type": "filter", "hook": "pos=
trouting", "prio": 11, "policy": "accept"}}, {"chain": {"family": "ip6", "t=
able": "x", "name": "postroutingsecuritym11", "handle": 0, "type": "filter"=
, "hook": "postrouting", "prio": 39, "policy": "accept"}}, {"chain": {"fami=
ly": "ip6", "table": "x", "name": "postroutingsecuritym10", "handle": 0, "t=
ype": "filter", "hook": "postrouting", "prio": 40, "policy": "accept"}}, {"=
chain": {"family": "ip6", "table": "x", "name": "postroutingsecurity", "han=
dle": 0, "type": "filter", "hook": "postrouting", "prio": 50, "policy": "ac=
cept"}}, {"chain": {"family": "ip6", "table": "x", "name": "postroutingsecu=
rityp10", "handle": 0, "type": "filter", "hook": "postrouting", "prio": 60,=
 "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "p=
ostroutingsecurityp11", "handle": 0, "type": "filter", "hook": "postrouting=
", "prio": 61, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "=
x", "name": "preroutingdstnatm11", "handle": 0, "type": "filter", "hook": "=
prerouting", "prio": -111, "policy": "accept"}}, {"chain": {"family": "ip6"=
, "table": "x", "name": "preroutingdstnatm10", "handle": 0, "type": "filter=
", "hook": "prerouting", "prio": -110, "policy": "accept"}}, {"chain": {"fa=
mily": "ip6", "table": "x", "name": "preroutingdstnat", "handle": 0, "type"=
: "filter", "hook": "prerouting", "prio": -100, "policy": "accept"}}, {"cha=
in": {"family": "ip6", "table": "x", "name": "preroutingdstnatp10", "handle=
": 0, "type": "filter", "hook": "prerouting", "prio": -90, "policy": "accep=
t"}}, {"chain": {"family": "ip6", "table": "x", "name": "preroutingdstnatp1=
1", "handle": 0, "type": "filter", "hook": "prerouting", "prio": -89, "poli=
cy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "postrou=
tingsrcnatm11", "handle": 0, "type": "filter", "hook": "postrouting", "prio=
": 89, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "nam=
e": "postroutingsrcnatm10", "handle": 0, "type": "filter", "hook": "postrou=
ting", "prio": 90, "policy": "accept"}}, {"chain": {"family": "ip6", "table=
": "x", "name": "postroutingsrcnat", "handle": 0, "type": "filter", "hook":=
 "postrouting", "prio": 100, "policy": "accept"}}, {"chain": {"family": "ip=
6", "table": "x", "name": "postroutingsrcnatp10", "handle": 0, "type": "fil=
ter", "hook": "postrouting", "prio": 110, "policy": "accept"}}, {"chain": {=
"family": "ip6", "table": "x", "name": "postroutingsrcnatp11", "handle": 0,=
 "type": "filter", "hook": "postrouting", "prio": 111, "policy": "accept"}}=
, {"table": {"family": "inet", "name": "x", "handle": 0}}, {"chain": {"fami=
ly": "inet", "table": "x", "name": "preroutingrawm11", "handle": 0, "type":=
 "filter", "hook": "prerouting", "prio": -311, "policy": "accept"}}, {"chai=
n": {"family": "inet", "table": "x", "name": "preroutingrawm10", "handle": =
0, "type": "filter", "hook": "prerouting", "prio": -310, "policy": "accept"=
}}, {"chain": {"family": "inet", "table": "x", "name": "preroutingraw", "ha=
ndle": 0, "type": "filter", "hook": "prerouting", "prio": -300, "policy": "=
accept"}}, {"chain": {"family": "inet", "table": "x", "name": "preroutingra=
wp10", "handle": 0, "type": "filter", "hook": "prerouting", "prio": -290, "=
policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "pr=
eroutingrawp11", "handle": 0, "type": "filter", "hook": "prerouting", "prio=
": -289, "policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "=
name": "preroutingmanglem11", "handle": 0, "type": "filter", "hook": "prero=
uting", "prio": -161, "policy": "accept"}}, {"chain": {"family": "inet", "t=
able": "x", "name": "preroutingmanglem10", "handle": 0, "type": "filter", "=
hook": "prerouting", "prio": -160, "policy": "accept"}}, {"chain": {"family=
": "inet", "table": "x", "name": "preroutingmangle", "handle": 0, "type": "=
filter", "hook": "prerouting", "prio": -150, "policy": "accept"}}, {"chain"=
: {"family": "inet", "table": "x", "name": "preroutingmanglep10", "handle":=
 0, "type": "filter", "hook": "prerouting", "prio": -140, "policy": "accept=
"}}, {"chain": {"family": "inet", "table": "x", "name": "preroutingmanglep1=
1", "handle": 0, "type": "filter", "hook": "prerouting", "prio": -139, "pol=
icy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "prero=
utingfilterm11", "handle": 0, "type": "filter", "hook": "prerouting", "prio=
": -11, "policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "n=
ame": "preroutingfilterm10", "handle": 0, "type": "filter", "hook": "prerou=
ting", "prio": -10, "policy": "accept"}}, {"chain": {"family": "inet", "tab=
le": "x", "name": "preroutingfilter", "handle": 0, "type": "filter", "hook"=
: "prerouting", "prio": 0, "policy": "accept"}}, {"chain": {"family": "inet=
", "table": "x", "name": "preroutingfilterp10", "handle": 0, "type": "filte=
r", "hook": "prerouting", "prio": 10, "policy": "accept"}}, {"chain": {"fam=
ily": "inet", "table": "x", "name": "preroutingfilterp11", "handle": 0, "ty=
pe": "filter", "hook": "prerouting", "prio": 11, "policy": "accept"}}, {"ch=
ain": {"family": "inet", "table": "x", "name": "preroutingsecuritym11", "ha=
ndle": 0, "type": "filter", "hook": "prerouting", "prio": 39, "policy": "ac=
cept"}}, {"chain": {"family": "inet", "table": "x", "name": "preroutingsecu=
ritym10", "handle": 0, "type": "filter", "hook": "prerouting", "prio": 40, =
"policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "p=
reroutingsecurity", "handle": 0, "type": "filter", "hook": "prerouting", "p=
rio": 50, "policy": "accept"}}, {"chain": {"family": "inet", "table": "x", =
"name": "preroutingsecurityp10", "handle": 0, "type": "filter", "hook": "pr=
erouting", "prio": 60, "policy": "accept"}}, {"chain": {"family": "inet", "=
table": "x", "name": "preroutingsecurityp11", "handle": 0, "type": "filter"=
, "hook": "prerouting", "prio": 61, "policy": "accept"}}, {"chain": {"famil=
y": "inet", "table": "x", "name": "inputrawm11", "handle": 0, "type": "filt=
er", "hook": "input", "prio": -311, "policy": "accept"}}, {"chain": {"famil=
y": "inet", "table": "x", "name": "inputrawm10", "handle": 0, "type": "filt=
er", "hook": "input", "prio": -310, "policy": "accept"}}, {"chain": {"famil=
y": "inet", "table": "x", "name": "inputraw", "handle": 0, "type": "filter"=
, "hook": "input", "prio": -300, "policy": "accept"}}, {"chain": {"family":=
 "inet", "table": "x", "name": "inputrawp10", "handle": 0, "type": "filter"=
, "hook": "input", "prio": -290, "policy": "accept"}}, {"chain": {"family":=
 "inet", "table": "x", "name": "inputrawp11", "handle": 0, "type": "filter"=
, "hook": "input", "prio": -289, "policy": "accept"}}, {"chain": {"family":=
 "inet", "table": "x", "name": "inputmanglem11", "handle": 0, "type": "filt=
er", "hook": "input", "prio": -161, "policy": "accept"}}, {"chain": {"famil=
y": "inet", "table": "x", "name": "inputmanglem10", "handle": 0, "type": "f=
ilter", "hook": "input", "prio": -160, "policy": "accept"}}, {"chain": {"fa=
mily": "inet", "table": "x", "name": "inputmangle", "handle": 0, "type": "f=
ilter", "hook": "input", "prio": -150, "policy": "accept"}}, {"chain": {"fa=
mily": "inet", "table": "x", "name": "inputmanglep10", "handle": 0, "type":=
 "filter", "hook": "input", "prio": -140, "policy": "accept"}}, {"chain": {=
"family": "inet", "table": "x", "name": "inputmanglep11", "handle": 0, "typ=
e": "filter", "hook": "input", "prio": -139, "policy": "accept"}}, {"chain"=
: {"family": "inet", "table": "x", "name": "inputfilterm11", "handle": 0, "=
type": "filter", "hook": "input", "prio": -11, "policy": "accept"}}, {"chai=
n": {"family": "inet", "table": "x", "name": "inputfilterm10", "handle": 0,=
 "type": "filter", "hook": "input", "prio": -10, "policy": "accept"}}, {"ch=
ain": {"family": "inet", "table": "x", "name": "inputfilter", "handle": 0, =
"type": "filter", "hook": "input", "prio": 0, "policy": "accept"}}, {"chain=
": {"family": "inet", "table": "x", "name": "inputfilterp10", "handle": 0, =
"type": "filter", "hook": "input", "prio": 10, "policy": "accept"}}, {"chai=
n": {"family": "inet", "table": "x", "name": "inputfilterp11", "handle": 0,=
 "type": "filter", "hook": "input", "prio": 11, "policy": "accept"}}, {"cha=
in": {"family": "inet", "table": "x", "name": "inputsecuritym11", "handle":=
 0, "type": "filter", "hook": "input", "prio": 39, "policy": "accept"}}, {"=
chain": {"family": "inet", "table": "x", "name": "inputsecuritym10", "handl=
e": 0, "type": "filter", "hook": "input", "prio": 40, "policy": "accept"}},=
 {"chain": {"family": "inet", "table": "x", "name": "inputsecurity", "handl=
e": 0, "type": "filter", "hook": "input", "prio": 50, "policy": "accept"}},=
 {"chain": {"family": "inet", "table": "x", "name": "inputsecurityp10", "ha=
ndle": 0, "type": "filter", "hook": "input", "prio": 60, "policy": "accept"=
}}, {"chain": {"family": "inet", "table": "x", "name": "inputsecurityp11", =
"handle": 0, "type": "filter", "hook": "input", "prio": 61, "policy": "acce=
pt"}}, {"chain": {"family": "inet", "table": "x", "name": "forwardrawm11", =
"handle": 0, "type": "filter", "hook": "forward", "prio": -311, "policy": "=
accept"}}, {"chain": {"family": "inet", "table": "x", "name": "forwardrawm1=
0", "handle": 0, "type": "filter", "hook": "forward", "prio": -310, "policy=
": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "forwardr=
aw", "handle": 0, "type": "filter", "hook": "forward", "prio": -300, "polic=
y": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "forward=
rawp10", "handle": 0, "type": "filter", "hook": "forward", "prio": -290, "p=
olicy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "for=
wardrawp11", "handle": 0, "type": "filter", "hook": "forward", "prio": -289=
, "policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": =
"forwardmanglem11", "handle": 0, "type": "filter", "hook": "forward", "prio=
": -161, "policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "=
name": "forwardmanglem10", "handle": 0, "type": "filter", "hook": "forward"=
, "prio": -160, "policy": "accept"}}, {"chain": {"family": "inet", "table":=
 "x", "name": "forwardmangle", "handle": 0, "type": "filter", "hook": "forw=
ard", "prio": -150, "policy": "accept"}}, {"chain": {"family": "inet", "tab=
le": "x", "name": "forwardmanglep10", "handle": 0, "type": "filter", "hook"=
: "forward", "prio": -140, "policy": "accept"}}, {"chain": {"family": "inet=
", "table": "x", "name": "forwardmanglep11", "handle": 0, "type": "filter",=
 "hook": "forward", "prio": -139, "policy": "accept"}}, {"chain": {"family"=
: "inet", "table": "x", "name": "forwardfilterm11", "handle": 0, "type": "f=
ilter", "hook": "forward", "prio": -11, "policy": "accept"}}, {"chain": {"f=
amily": "inet", "table": "x", "name": "forwardfilterm10", "handle": 0, "typ=
e": "filter", "hook": "forward", "prio": -10, "policy": "accept"}}, {"chain=
": {"family": "inet", "table": "x", "name": "forwardfilter", "handle": 0, "=
type": "filter", "hook": "forward", "prio": 0, "policy": "accept"}}, {"chai=
n": {"family": "inet", "table": "x", "name": "forwardfilterp10", "handle": =
0, "type": "filter", "hook": "forward", "prio": 10, "policy": "accept"}}, {=
"chain": {"family": "inet", "table": "x", "name": "forwardfilterp11", "hand=
le": 0, "type": "filter", "hook": "forward", "prio": 11, "policy": "accept"=
}}, {"chain": {"family": "inet", "table": "x", "name": "forwardsecuritym11"=
, "handle": 0, "type": "filter", "hook": "forward", "prio": 39, "policy": "=
accept"}}, {"chain": {"family": "inet", "table": "x", "name": "forwardsecur=
itym10", "handle": 0, "type": "filter", "hook": "forward", "prio": 40, "pol=
icy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "forwa=
rdsecurity", "handle": 0, "type": "filter", "hook": "forward", "prio": 50, =
"policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "f=
orwardsecurityp10", "handle": 0, "type": "filter", "hook": "forward", "prio=
": 60, "policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "na=
me": "forwardsecurityp11", "handle": 0, "type": "filter", "hook": "forward"=
, "prio": 61, "policy": "accept"}}, {"chain": {"family": "inet", "table": "=
x", "name": "outputrawm11", "handle": 0, "type": "filter", "hook": "output"=
, "prio": -311, "policy": "accept"}}, {"chain": {"family": "inet", "table":=
 "x", "name": "outputrawm10", "handle": 0, "type": "filter", "hook": "outpu=
t", "prio": -310, "policy": "accept"}}, {"chain": {"family": "inet", "table=
": "x", "name": "outputraw", "handle": 0, "type": "filter", "hook": "output=
", "prio": -300, "policy": "accept"}}, {"chain": {"family": "inet", "table"=
: "x", "name": "outputrawp10", "handle": 0, "type": "filter", "hook": "outp=
ut", "prio": -290, "policy": "accept"}}, {"chain": {"family": "inet", "tabl=
e": "x", "name": "outputrawp11", "handle": 0, "type": "filter", "hook": "ou=
tput", "prio": -289, "policy": "accept"}}, {"chain": {"family": "inet", "ta=
ble": "x", "name": "outputmanglem11", "handle": 0, "type": "filter", "hook"=
: "output", "prio": -161, "policy": "accept"}}, {"chain": {"family": "inet"=
, "table": "x", "name": "outputmanglem10", "handle": 0, "type": "filter", "=
hook": "output", "prio": -160, "policy": "accept"}}, {"chain": {"family": "=
inet", "table": "x", "name": "outputmangle", "handle": 0, "type": "filter",=
 "hook": "output", "prio": -150, "policy": "accept"}}, {"chain": {"family":=
 "inet", "table": "x", "name": "outputmanglep10", "handle": 0, "type": "fil=
ter", "hook": "output", "prio": -140, "policy": "accept"}}, {"chain": {"fam=
ily": "inet", "table": "x", "name": "outputmanglep11", "handle": 0, "type":=
 "filter", "hook": "output", "prio": -139, "policy": "accept"}}, {"chain": =
{"family": "inet", "table": "x", "name": "outputfilterm11", "handle": 0, "t=
ype": "filter", "hook": "output", "prio": -11, "policy": "accept"}}, {"chai=
n": {"family": "inet", "table": "x", "name": "outputfilterm10", "handle": 0=
, "type": "filter", "hook": "output", "prio": -10, "policy": "accept"}}, {"=
chain": {"family": "inet", "table": "x", "name": "outputfilter", "handle": =
0, "type": "filter", "hook": "output", "prio": 0, "policy": "accept"}}, {"c=
hain": {"family": "inet", "table": "x", "name": "outputfilterp10", "handle"=
: 0, "type": "filter", "hook": "output", "prio": 10, "policy": "accept"}}, =
{"chain": {"family": "inet", "table": "x", "name": "outputfilterp11", "hand=
le": 0, "type": "filter", "hook": "output", "prio": 11, "policy": "accept"}=
}, {"chain": {"family": "inet", "table": "x", "name": "outputsecuritym11", =
"handle": 0, "type": "filter", "hook": "output", "prio": 39, "policy": "acc=
ept"}}, {"chain": {"family": "inet", "table": "x", "name": "outputsecuritym=
10", "handle": 0, "type": "filter", "hook": "output", "prio": 40, "policy":=
 "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "outputsecu=
rity", "handle": 0, "type": "filter", "hook": "output", "prio": 50, "policy=
": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "outputse=
curityp10", "handle": 0, "type": "filter", "hook": "output", "prio": 60, "p=
olicy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "out=
putsecurityp11", "handle": 0, "type": "filter", "hook": "output", "prio": 6=
1, "policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name":=
 "postroutingrawm11", "handle": 0, "type": "filter", "hook": "postrouting",=
 "prio": -311, "policy": "accept"}}, {"chain": {"family": "inet", "table": =
"x", "name": "postroutingrawm10", "handle": 0, "type": "filter", "hook": "p=
ostrouting", "prio": -310, "policy": "accept"}}, {"chain": {"family": "inet=
", "table": "x", "name": "postroutingraw", "handle": 0, "type": "filter", "=
hook": "postrouting", "prio": -300, "policy": "accept"}}, {"chain": {"famil=
y": "inet", "table": "x", "name": "postroutingrawp10", "handle": 0, "type":=
 "filter", "hook": "postrouting", "prio": -290, "policy": "accept"}}, {"cha=
in": {"family": "inet", "table": "x", "name": "postroutingrawp11", "handle"=
: 0, "type": "filter", "hook": "postrouting", "prio": -289, "policy": "acce=
pt"}}, {"chain": {"family": "inet", "table": "x", "name": "postroutingmangl=
em11", "handle": 0, "type": "filter", "hook": "postrouting", "prio": -161, =
"policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "p=
ostroutingmanglem10", "handle": 0, "type": "filter", "hook": "postrouting",=
 "prio": -160, "policy": "accept"}}, {"chain": {"family": "inet", "table": =
"x", "name": "postroutingmangle", "handle": 0, "type": "filter", "hook": "p=
ostrouting", "prio": -150, "policy": "accept"}}, {"chain": {"family": "inet=
", "table": "x", "name": "postroutingmanglep10", "handle": 0, "type": "filt=
er", "hook": "postrouting", "prio": -140, "policy": "accept"}}, {"chain": {=
"family": "inet", "table": "x", "name": "postroutingmanglep11", "handle": 0=
, "type": "filter", "hook": "postrouting", "prio": -139, "policy": "accept"=
}}, {"chain": {"family": "inet", "table": "x", "name": "postroutingfilterm1=
1", "handle": 0, "type": "filter", "hook": "postrouting", "prio": -11, "pol=
icy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "postr=
outingfilterm10", "handle": 0, "type": "filter", "hook": "postrouting", "pr=
io": -10, "policy": "accept"}}, {"chain": {"family": "inet", "table": "x", =
"name": "postroutingfilter", "handle": 0, "type": "filter", "hook": "postro=
uting", "prio": 0, "policy": "accept"}}, {"chain": {"family": "inet", "tabl=
e": "x", "name": "postroutingfilterp10", "handle": 0, "type": "filter", "ho=
ok": "postrouting", "prio": 10, "policy": "accept"}}, {"chain": {"family": =
"inet", "table": "x", "name": "postroutingfilterp11", "handle": 0, "type": =
"filter", "hook": "postrouting", "prio": 11, "policy": "accept"}}, {"chain"=
: {"family": "inet", "table": "x", "name": "postroutingsecuritym11", "handl=
e": 0, "type": "filter", "hook": "postrouting", "prio": 39, "policy": "acce=
pt"}}, {"chain": {"family": "inet", "table": "x", "name": "postroutingsecur=
itym10", "handle": 0, "type": "filter", "hook": "postrouting", "prio": 40, =
"policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "p=
ostroutingsecurity", "handle": 0, "type": "filter", "hook": "postrouting", =
"prio": 50, "policy": "accept"}}, {"chain": {"family": "inet", "table": "x"=
, "name": "postroutingsecurityp10", "handle": 0, "type": "filter", "hook": =
"postrouting", "prio": 60, "policy": "accept"}}, {"chain": {"family": "inet=
", "table": "x", "name": "postroutingsecurityp11", "handle": 0, "type": "fi=
lter", "hook": "postrouting", "prio": 61, "policy": "accept"}}, {"chain": {=
"family": "inet", "table": "x", "name": "preroutingdstnatm11", "handle": 0,=
 "type": "filter", "hook": "prerouting", "prio": -111, "policy": "accept"}}=
, {"chain": {"family": "inet", "table": "x", "name": "preroutingdstnatm10",=
 "handle": 0, "type": "filter", "hook": "prerouting", "prio": -110, "policy=
": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "prerouti=
ngdstnat", "handle": 0, "type": "filter", "hook": "prerouting", "prio": -10=
0, "policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name":=
 "preroutingdstnatp10", "handle": 0, "type": "filter", "hook": "prerouting"=
, "prio": -90, "policy": "accept"}}, {"chain": {"family": "inet", "table": =
"x", "name": "preroutingdstnatp11", "handle": 0, "type": "filter", "hook": =
"prerouting", "prio": -89, "policy": "accept"}}, {"chain": {"family": "inet=
", "table": "x", "name": "postroutingsrcnatm11", "handle": 0, "type": "filt=
er", "hook": "postrouting", "prio": 89, "policy": "accept"}}, {"chain": {"f=
amily": "inet", "table": "x", "name": "postroutingsrcnatm10", "handle": 0, =
"type": "filter", "hook": "postrouting", "prio": 90, "policy": "accept"}}, =
{"chain": {"family": "inet", "table": "x", "name": "postroutingsrcnat", "ha=
ndle": 0, "type": "filter", "hook": "postrouting", "prio": 100, "policy": "=
accept"}}, {"chain": {"family": "inet", "table": "x", "name": "postroutings=
rcnatp10", "handle": 0, "type": "filter", "hook": "postrouting", "prio": 11=
0, "policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name":=
 "postroutingsrcnatp11", "handle": 0, "type": "filter", "hook": "postroutin=
g", "prio": 111, "policy": "accept"}}, {"table": {"family": "arp", "name": =
"x", "handle": 0}}, {"chain": {"family": "arp", "table": "x", "name": "inpu=
tfilterm11", "handle": 0, "type": "filter", "hook": "input", "prio": -11, "=
policy": "accept"}}, {"chain": {"family": "arp", "table": "x", "name": "inp=
utfilterm10", "handle": 0, "type": "filter", "hook": "input", "prio": -10, =
"policy": "accept"}}, {"chain": {"family": "arp", "table": "x", "name": "in=
putfilter", "handle": 0, "type": "filter", "hook": "input", "prio": 0, "pol=
icy": "accept"}}, {"chain": {"family": "arp", "table": "x", "name": "inputf=
ilterp10", "handle": 0, "type": "filter", "hook": "input", "prio": 10, "pol=
icy": "accept"}}, {"chain": {"family": "arp", "table": "x", "name": "inputf=
ilterp11", "handle": 0, "type": "filter", "hook": "input", "prio": 11, "pol=
icy": "accept"}}, {"chain": {"family": "arp", "table": "x", "name": "output=
filterm11", "handle": 0, "type": "filter", "hook": "output", "prio": -11, "=
policy": "accept"}}, {"chain": {"family": "arp", "table": "x", "name": "out=
putfilterm10", "handle": 0, "type": "filter", "hook": "output", "prio": -10=
, "policy": "accept"}}, {"chain": {"family": "arp", "table": "x", "name": "=
outputfilter", "handle": 0, "type": "filter", "hook": "output", "prio": 0, =
"policy": "accept"}}, {"chain": {"family": "arp", "table": "x", "name": "ou=
tputfilterp10", "handle": 0, "type": "filter", "hook": "output", "prio": 10=
, "policy": "accept"}}, {"chain": {"family": "arp", "table": "x", "name": "=
outputfilterp11", "handle": 0, "type": "filter", "hook": "output", "prio": =
11, "policy": "accept"}}, {"table": {"family": "netdev", "name": "x", "hand=
le": 0}}, {"chain": {"family": "netdev", "table": "x", "name": "ingressfilt=
erm11", "handle": 0, "type": "filter", "hook": "ingress", "prio": -11, "pol=
icy": "accept"}}, {"chain": {"family": "netdev", "table": "x", "name": "ing=
ressfilterm10", "handle": 0, "type": "filter", "hook": "ingress", "prio": -=
10, "policy": "accept"}}, {"chain": {"family": "netdev", "table": "x", "nam=
e": "ingressfilter", "handle": 0, "type": "filter", "hook": "ingress", "pri=
o": 0, "policy": "accept"}}, {"chain": {"family": "netdev", "table": "x", "=
name": "ingressfilterp10", "handle": 0, "type": "filter", "hook": "ingress"=
, "prio": 10, "policy": "accept"}}, {"chain": {"family": "netdev", "table":=
 "x", "name": "ingressfilterp11", "handle": 0, "type": "filter", "hook": "i=
ngress", "prio": 11, "policy": "accept"}}, {"chain": {"family": "netdev", "=
table": "x", "name": "egressfilterm11", "handle": 0, "type": "filter", "hoo=
k": "egress", "prio": -11, "policy": "accept"}}, {"chain": {"family": "netd=
ev", "table": "x", "name": "egressfilterm10", "handle": 0, "type": "filter"=
, "hook": "egress", "prio": -10, "policy": "accept"}}, {"chain": {"family":=
 "netdev", "table": "x", "name": "egressfilter", "handle": 0, "type": "filt=
er", "hook": "egress", "prio": 0, "policy": "accept"}}, {"chain": {"family"=
: "netdev", "table": "x", "name": "egressfilterp10", "handle": 0, "type": "=
filter", "hook": "egress", "prio": 10, "policy": "accept"}}, {"chain": {"fa=
mily": "netdev", "table": "x", "name": "egressfilterp11", "handle": 0, "typ=
e": "filter", "hook": "egress", "prio": 11, "policy": "accept"}}, {"table":=
 {"family": "bridge", "name": "x", "handle": 0}}, {"chain": {"family": "bri=
dge", "table": "x", "name": "preroutingfilterm11", "handle": 0, "type": "fi=
lter", "hook": "prerouting", "prio": -211, "policy": "accept"}}, {"chain": =
{"family": "bridge", "table": "x", "name": "preroutingfilterm10", "handle":=
 0, "type": "filter", "hook": "prerouting", "prio": -210, "policy": "accept=
"}}, {"chain": {"family": "bridge", "table": "x", "name": "preroutingfilter=
", "handle": 0, "type": "filter", "hook": "prerouting", "prio": -200, "poli=
cy": "accept"}}, {"chain": {"family": "bridge", "table": "x", "name": "prer=
outingfilterp10", "handle": 0, "type": "filter", "hook": "prerouting", "pri=
o": -190, "policy": "accept"}}, {"chain": {"family": "bridge", "table": "x"=
, "name": "preroutingfilterp11", "handle": 0, "type": "filter", "hook": "pr=
erouting", "prio": -189, "policy": "accept"}}, {"chain": {"family": "bridge=
", "table": "x", "name": "inputfilterm11", "handle": 0, "type": "filter", "=
hook": "input", "prio": -211, "policy": "accept"}}, {"chain": {"family": "b=
ridge", "table": "x", "name": "inputfilterm10", "handle": 0, "type": "filte=
r", "hook": "input", "prio": -210, "policy": "accept"}}, {"chain": {"family=
": "bridge", "table": "x", "name": "inputfilter", "handle": 0, "type": "fil=
ter", "hook": "input", "prio": -200, "policy": "accept"}}, {"chain": {"fami=
ly": "bridge", "table": "x", "name": "inputfilterp10", "handle": 0, "type":=
 "filter", "hook": "input", "prio": -190, "policy": "accept"}}, {"chain": {=
"family": "bridge", "table": "x", "name": "inputfilterp11", "handle": 0, "t=
ype": "filter", "hook": "input", "prio": -189, "policy": "accept"}}, {"chai=
n": {"family": "bridge", "table": "x", "name": "forwardfilterm11", "handle"=
: 0, "type": "filter", "hook": "forward", "prio": -211, "policy": "accept"}=
}, {"chain": {"family": "bridge", "table": "x", "name": "forwardfilterm10",=
 "handle": 0, "type": "filter", "hook": "forward", "prio": -210, "policy": =
"accept"}}, {"chain": {"family": "bridge", "table": "x", "name": "forwardfi=
lter", "handle": 0, "type": "filter", "hook": "forward", "prio": -200, "pol=
icy": "accept"}}, {"chain": {"family": "bridge", "table": "x", "name": "for=
wardfilterp10", "handle": 0, "type": "filter", "hook": "forward", "prio": -=
190, "policy": "accept"}}, {"chain": {"family": "bridge", "table": "x", "na=
me": "forwardfilterp11", "handle": 0, "type": "filter", "hook": "forward", =
"prio": -189, "policy": "accept"}}, {"chain": {"family": "bridge", "table":=
 "x", "name": "outputfilterm11", "handle": 0, "type": "filter", "hook": "ou=
tput", "prio": -211, "policy": "accept"}}, {"chain": {"family": "bridge", "=
table": "x", "name": "outputfilterm10", "handle": 0, "type": "filter", "hoo=
k": "output", "prio": -210, "policy": "accept"}}, {"chain": {"family": "bri=
dge", "table": "x", "name": "outputfilter", "handle": 0, "type": "filter", =
"hook": "output", "prio": -200, "policy": "accept"}}, {"chain": {"family": =
"bridge", "table": "x", "name": "outputfilterp10", "handle": 0, "type": "fi=
lter", "hook": "output", "prio": -190, "policy": "accept"}}, {"chain": {"fa=
mily": "bridge", "table": "x", "name": "outputfilterp11", "handle": 0, "typ=
e": "filter", "hook": "output", "prio": -189, "policy": "accept"}}, {"chain=
": {"family": "bridge", "table": "x", "name": "postroutingfilterm11", "hand=
le": 0, "type": "filter", "hook": "postrouting", "prio": -211, "policy": "a=
ccept"}}, {"chain": {"family": "bridge", "table": "x", "name": "postrouting=
filterm10", "handle": 0, "type": "filter", "hook": "postrouting", "prio": -=
210, "policy": "accept"}}, {"chain": {"family": "bridge", "table": "x", "na=
me": "postroutingfilter", "handle": 0, "type": "filter", "hook": "postrouti=
ng", "prio": -200, "policy": "accept"}}, {"chain": {"family": "bridge", "ta=
ble": "x", "name": "postroutingfilterp10", "handle": 0, "type": "filter", "=
hook": "postrouting", "prio": -190, "policy": "accept"}}, {"chain": {"famil=
y": "bridge", "table": "x", "name": "postroutingfilterp11", "handle": 0, "t=
ype": "filter", "hook": "postrouting", "prio": -189, "policy": "accept"}}, =
{"chain": {"family": "bridge", "table": "x", "name": "preroutingdstnatm11",=
 "handle": 0, "type": "filter", "hook": "prerouting", "prio": -311, "policy=
": "accept"}}, {"chain": {"family": "bridge", "table": "x", "name": "prerou=
tingdstnatm10", "handle": 0, "type": "filter", "hook": "prerouting", "prio"=
: -310, "policy": "accept"}}, {"chain": {"family": "bridge", "table": "x", =
"name": "preroutingdstnat", "handle": 0, "type": "filter", "hook": "prerout=
ing", "prio": -300, "policy": "accept"}}, {"chain": {"family": "bridge", "t=
able": "x", "name": "preroutingdstnatp10", "handle": 0, "type": "filter", "=
hook": "prerouting", "prio": -290, "policy": "accept"}}, {"chain": {"family=
": "bridge", "table": "x", "name": "preroutingdstnatp11", "handle": 0, "typ=
e": "filter", "hook": "prerouting", "prio": -289, "policy": "accept"}}, {"c=
hain": {"family": "bridge", "table": "x", "name": "outputoutm11", "handle":=
 0, "type": "filter", "hook": "output", "prio": 89, "policy": "accept"}}, {=
"chain": {"family": "bridge", "table": "x", "name": "outputoutm10", "handle=
": 0, "type": "filter", "hook": "output", "prio": 90, "policy": "accept"}},=
 {"chain": {"family": "bridge", "table": "x", "name": "outputout", "handle"=
: 0, "type": "filter", "hook": "output", "prio": 100, "policy": "accept"}},=
 {"chain": {"family": "bridge", "table": "x", "name": "outputoutp10", "hand=
le": 0, "type": "filter", "hook": "output", "prio": 110, "policy": "accept"=
}}, {"chain": {"family": "bridge", "table": "x", "name": "outputoutp11", "h=
andle": 0, "type": "filter", "hook": "output", "prio": 111, "policy": "acce=
pt"}}, {"chain": {"family": "bridge", "table": "x", "name": "postroutingsrc=
natm11", "handle": 0, "type": "filter", "hook": "postrouting", "prio": 289,=
 "policy": "accept"}}, {"chain": {"family": "bridge", "table": "x", "name":=
 "postroutingsrcnatm10", "handle": 0, "type": "filter", "hook": "postroutin=
g", "prio": 290, "policy": "accept"}}, {"chain": {"family": "bridge", "tabl=
e": "x", "name": "postroutingsrcnat", "handle": 0, "type": "filter", "hook"=
: "postrouting", "prio": 300, "policy": "accept"}}, {"chain": {"family": "b=
ridge", "table": "x", "name": "postroutingsrcnatp10", "handle": 0, "type": =
"filter", "hook": "postrouting", "prio": 310, "policy": "accept"}}, {"chain=
": {"family": "bridge", "table": "x", "name": "postroutingsrcnatp11", "hand=
le": 0, "type": "filter", "hook": "postrouting", "prio": 311, "policy": "ac=
cept"}}]}
+{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "x",=
 "handle": 0}}, {"chain": {"family": "ip", "table": "x", "name": "preroutin=
grawm11", "handle": 0, "type": "filter", "hook": "prerouting", "prio": -311=
, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "p=
reroutingrawm10", "handle": 0, "type": "filter", "hook": "prerouting", "pri=
o": -310, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "n=
ame": "preroutingraw", "handle": 0, "type": "filter", "hook": "prerouting",=
 "prio": -300, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x=
", "name": "preroutingrawp10", "handle": 0, "type": "filter", "hook": "prer=
outing", "prio": -290, "policy": "accept"}}, {"chain": {"family": "ip", "ta=
ble": "x", "name": "preroutingrawp11", "handle": 0, "type": "filter", "hook=
": "prerouting", "prio": -289, "policy": "accept"}}, {"chain": {"family": "=
ip", "table": "x", "name": "preroutingmanglem11", "handle": 0, "type": "fil=
ter", "hook": "prerouting", "prio": -161, "policy": "accept"}}, {"chain": {=
"family": "ip", "table": "x", "name": "preroutingmanglem10", "handle": 0, "=
type": "filter", "hook": "prerouting", "prio": -160, "policy": "accept"}}, =
{"chain": {"family": "ip", "table": "x", "name": "preroutingmangle", "handl=
e": 0, "type": "filter", "hook": "prerouting", "prio": -150, "policy": "acc=
ept"}}, {"chain": {"family": "ip", "table": "x", "name": "preroutingmanglep=
10", "handle": 0, "type": "filter", "hook": "prerouting", "prio": -140, "po=
licy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "prerou=
tingmanglep11", "handle": 0, "type": "filter", "hook": "prerouting", "prio"=
: -139, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "nam=
e": "preroutingfilterm11", "handle": 0, "type": "filter", "hook": "prerouti=
ng", "prio": -11, "policy": "accept"}}, {"chain": {"family": "ip", "table":=
 "x", "name": "preroutingfilterm10", "handle": 0, "type": "filter", "hook":=
 "prerouting", "prio": -10, "policy": "accept"}}, {"chain": {"family": "ip"=
, "table": "x", "name": "preroutingfilter", "handle": 0, "type": "filter", =
"hook": "prerouting", "prio": 0, "policy": "accept"}}, {"chain": {"family":=
 "ip", "table": "x", "name": "preroutingfilterp10", "handle": 0, "type": "f=
ilter", "hook": "prerouting", "prio": 10, "policy": "accept"}}, {"chain": {=
"family": "ip", "table": "x", "name": "preroutingfilterp11", "handle": 0, "=
type": "filter", "hook": "prerouting", "prio": 11, "policy": "accept"}}, {"=
chain": {"family": "ip", "table": "x", "name": "preroutingsecuritym11", "ha=
ndle": 0, "type": "filter", "hook": "prerouting", "prio": 39, "policy": "ac=
cept"}}, {"chain": {"family": "ip", "table": "x", "name": "preroutingsecuri=
tym10", "handle": 0, "type": "filter", "hook": "prerouting", "prio": 40, "p=
olicy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "prero=
utingsecurity", "handle": 0, "type": "filter", "hook": "prerouting", "prio"=
: 50, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name"=
: "preroutingsecurityp10", "handle": 0, "type": "filter", "hook": "prerouti=
ng", "prio": 60, "policy": "accept"}}, {"chain": {"family": "ip", "table": =
"x", "name": "preroutingsecurityp11", "handle": 0, "type": "filter", "hook"=
: "prerouting", "prio": 61, "policy": "accept"}}, {"chain": {"family": "ip"=
, "table": "x", "name": "inputrawm11", "handle": 0, "type": "filter", "hook=
": "input", "prio": -311, "policy": "accept"}}, {"chain": {"family": "ip", =
"table": "x", "name": "inputrawm10", "handle": 0, "type": "filter", "hook":=
 "input", "prio": -310, "policy": "accept"}}, {"chain": {"family": "ip", "t=
able": "x", "name": "inputraw", "handle": 0, "type": "filter", "hook": "inp=
ut", "prio": -300, "policy": "accept"}}, {"chain": {"family": "ip", "table"=
: "x", "name": "inputrawp10", "handle": 0, "type": "filter", "hook": "input=
", "prio": -290, "policy": "accept"}}, {"chain": {"family": "ip", "table": =
"x", "name": "inputrawp11", "handle": 0, "type": "filter", "hook": "input",=
 "prio": -289, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x=
", "name": "inputmanglem11", "handle": 0, "type": "filter", "hook": "input"=
, "prio": -161, "policy": "accept"}}, {"chain": {"family": "ip", "table": "=
x", "name": "inputmanglem10", "handle": 0, "type": "filter", "hook": "input=
", "prio": -160, "policy": "accept"}}, {"chain": {"family": "ip", "table": =
"x", "name": "inputmangle", "handle": 0, "type": "filter", "hook": "input",=
 "prio": -150, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x=
", "name": "inputmanglep10", "handle": 0, "type": "filter", "hook": "input"=
, "prio": -140, "policy": "accept"}}, {"chain": {"family": "ip", "table": "=
x", "name": "inputmanglep11", "handle": 0, "type": "filter", "hook": "input=
", "prio": -139, "policy": "accept"}}, {"chain": {"family": "ip", "table": =
"x", "name": "inputfilterm11", "handle": 0, "type": "filter", "hook": "inpu=
t", "prio": -11, "policy": "accept"}}, {"chain": {"family": "ip", "table": =
"x", "name": "inputfilterm10", "handle": 0, "type": "filter", "hook": "inpu=
t", "prio": -10, "policy": "accept"}}, {"chain": {"family": "ip", "table": =
"x", "name": "inputfilter", "handle": 0, "type": "filter", "hook": "input",=
 "prio": 0, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", =
"name": "inputfilterp10", "handle": 0, "type": "filter", "hook": "input", "=
prio": 10, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "=
name": "inputfilterp11", "handle": 0, "type": "filter", "hook": "input", "p=
rio": 11, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "n=
ame": "inputsecuritym11", "handle": 0, "type": "filter", "hook": "input", "=
prio": 39, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "=
name": "inputsecuritym10", "handle": 0, "type": "filter", "hook": "input", =
"prio": 40, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", =
"name": "inputsecurity", "handle": 0, "type": "filter", "hook": "input", "p=
rio": 50, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "n=
ame": "inputsecurityp10", "handle": 0, "type": "filter", "hook": "input", "=
prio": 60, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "=
name": "inputsecurityp11", "handle": 0, "type": "filter", "hook": "input", =
"prio": 61, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", =
"name": "forwardrawm11", "handle": 0, "type": "filter", "hook": "forward", =
"prio": -311, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x"=
, "name": "forwardrawm10", "handle": 0, "type": "filter", "hook": "forward"=
, "prio": -310, "policy": "accept"}}, {"chain": {"family": "ip", "table": "=
x", "name": "forwardraw", "handle": 0, "type": "filter", "hook": "forward",=
 "prio": -300, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x=
", "name": "forwardrawp10", "handle": 0, "type": "filter", "hook": "forward=
", "prio": -290, "policy": "accept"}}, {"chain": {"family": "ip", "table": =
"x", "name": "forwardrawp11", "handle": 0, "type": "filter", "hook": "forwa=
rd", "prio": -289, "policy": "accept"}}, {"chain": {"family": "ip", "table"=
: "x", "name": "forwardmanglem11", "handle": 0, "type": "filter", "hook": "=
forward", "prio": -161, "policy": "accept"}}, {"chain": {"family": "ip", "t=
able": "x", "name": "forwardmanglem10", "handle": 0, "type": "filter", "hoo=
k": "forward", "prio": -160, "policy": "accept"}}, {"chain": {"family": "ip=
", "table": "x", "name": "forwardmangle", "handle": 0, "type": "filter", "h=
ook": "forward", "prio": -150, "policy": "accept"}}, {"chain": {"family": "=
ip", "table": "x", "name": "forwardmanglep10", "handle": 0, "type": "filter=
", "hook": "forward", "prio": -140, "policy": "accept"}}, {"chain": {"famil=
y": "ip", "table": "x", "name": "forwardmanglep11", "handle": 0, "type": "f=
ilter", "hook": "forward", "prio": -139, "policy": "accept"}}, {"chain": {"=
family": "ip", "table": "x", "name": "forwardfilterm11", "handle": 0, "type=
": "filter", "hook": "forward", "prio": -11, "policy": "accept"}}, {"chain"=
: {"family": "ip", "table": "x", "name": "forwardfilterm10", "handle": 0, "=
type": "filter", "hook": "forward", "prio": -10, "policy": "accept"}}, {"ch=
ain": {"family": "ip", "table": "x", "name": "forwardfilter", "handle": 0, =
"type": "filter", "hook": "forward", "prio": 0, "policy": "accept"}}, {"cha=
in": {"family": "ip", "table": "x", "name": "forwardfilterp10", "handle": 0=
, "type": "filter", "hook": "forward", "prio": 10, "policy": "accept"}}, {"=
chain": {"family": "ip", "table": "x", "name": "forwardfilterp11", "handle"=
: 0, "type": "filter", "hook": "forward", "prio": 11, "policy": "accept"}},=
 {"chain": {"family": "ip", "table": "x", "name": "forwardsecuritym11", "ha=
ndle": 0, "type": "filter", "hook": "forward", "prio": 39, "policy": "accep=
t"}}, {"chain": {"family": "ip", "table": "x", "name": "forwardsecuritym10"=
, "handle": 0, "type": "filter", "hook": "forward", "prio": 40, "policy": "=
accept"}}, {"chain": {"family": "ip", "table": "x", "name": "forwardsecurit=
y", "handle": 0, "type": "filter", "hook": "forward", "prio": 50, "policy":=
 "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "forwardsecur=
ityp10", "handle": 0, "type": "filter", "hook": "forward", "prio": 60, "pol=
icy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "forward=
securityp11", "handle": 0, "type": "filter", "hook": "forward", "prio": 61,=
 "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "ou=
tputrawm11", "handle": 0, "type": "filter", "hook": "output", "prio": -311,=
 "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "ou=
tputrawm10", "handle": 0, "type": "filter", "hook": "output", "prio": -310,=
 "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "ou=
tputraw", "handle": 0, "type": "filter", "hook": "output", "prio": -300, "p=
olicy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "outpu=
trawp10", "handle": 0, "type": "filter", "hook": "output", "prio": -290, "p=
olicy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "outpu=
trawp11", "handle": 0, "type": "filter", "hook": "output", "prio": -289, "p=
olicy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "outpu=
tmanglem11", "handle": 0, "type": "filter", "hook": "output", "prio": -161,=
 "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "ou=
tputmanglem10", "handle": 0, "type": "filter", "hook": "output", "prio": -1=
60, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": =
"outputmangle", "handle": 0, "type": "filter", "hook": "output", "prio": -1=
50, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": =
"outputmanglep10", "handle": 0, "type": "filter", "hook": "output", "prio":=
 -140, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name=
": "outputmanglep11", "handle": 0, "type": "filter", "hook": "output", "pri=
o": -139, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "n=
ame": "outputfilterm11", "handle": 0, "type": "filter", "hook": "output", "=
prio": -11, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", =
"name": "outputfilterm10", "handle": 0, "type": "filter", "hook": "output",=
 "prio": -10, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x"=
, "name": "outputfilter", "handle": 0, "type": "filter", "hook": "output", =
"prio": 0, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "=
name": "outputfilterp10", "handle": 0, "type": "filter", "hook": "output", =
"prio": 10, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", =
"name": "outputfilterp11", "handle": 0, "type": "filter", "hook": "output",=
 "prio": 11, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x",=
 "name": "outputsecuritym11", "handle": 0, "type": "filter", "hook": "outpu=
t", "prio": 39, "policy": "accept"}}, {"chain": {"family": "ip", "table": "=
x", "name": "outputsecuritym10", "handle": 0, "type": "filter", "hook": "ou=
tput", "prio": 40, "policy": "accept"}}, {"chain": {"family": "ip", "table"=
: "x", "name": "outputsecurity", "handle": 0, "type": "filter", "hook": "ou=
tput", "prio": 50, "policy": "accept"}}, {"chain": {"family": "ip", "table"=
: "x", "name": "outputsecurityp10", "handle": 0, "type": "filter", "hook": =
"output", "prio": 60, "policy": "accept"}}, {"chain": {"family": "ip", "tab=
le": "x", "name": "outputsecurityp11", "handle": 0, "type": "filter", "hook=
": "output", "prio": 61, "policy": "accept"}}, {"chain": {"family": "ip", "=
table": "x", "name": "postroutingrawm11", "handle": 0, "type": "filter", "h=
ook": "postrouting", "prio": -311, "policy": "accept"}}, {"chain": {"family=
": "ip", "table": "x", "name": "postroutingrawm10", "handle": 0, "type": "f=
ilter", "hook": "postrouting", "prio": -310, "policy": "accept"}}, {"chain"=
: {"family": "ip", "table": "x", "name": "postroutingraw", "handle": 0, "ty=
pe": "filter", "hook": "postrouting", "prio": -300, "policy": "accept"}}, {=
"chain": {"family": "ip", "table": "x", "name": "postroutingrawp10", "handl=
e": 0, "type": "filter", "hook": "postrouting", "prio": -290, "policy": "ac=
cept"}}, {"chain": {"family": "ip", "table": "x", "name": "postroutingrawp1=
1", "handle": 0, "type": "filter", "hook": "postrouting", "prio": -289, "po=
licy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "postro=
utingmanglem11", "handle": 0, "type": "filter", "hook": "postrouting", "pri=
o": -161, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "n=
ame": "postroutingmanglem10", "handle": 0, "type": "filter", "hook": "postr=
outing", "prio": -160, "policy": "accept"}}, {"chain": {"family": "ip", "ta=
ble": "x", "name": "postroutingmangle", "handle": 0, "type": "filter", "hoo=
k": "postrouting", "prio": -150, "policy": "accept"}}, {"chain": {"family":=
 "ip", "table": "x", "name": "postroutingmanglep10", "handle": 0, "type": "=
filter", "hook": "postrouting", "prio": -140, "policy": "accept"}}, {"chain=
": {"family": "ip", "table": "x", "name": "postroutingmanglep11", "handle":=
 0, "type": "filter", "hook": "postrouting", "prio": -139, "policy": "accep=
t"}}, {"chain": {"family": "ip", "table": "x", "name": "postroutingfilterm1=
1", "handle": 0, "type": "filter", "hook": "postrouting", "prio": -11, "pol=
icy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "postrou=
tingfilterm10", "handle": 0, "type": "filter", "hook": "postrouting", "prio=
": -10, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "nam=
e": "postroutingfilter", "handle": 0, "type": "filter", "hook": "postroutin=
g", "prio": 0, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x=
", "name": "postroutingfilterp10", "handle": 0, "type": "filter", "hook": "=
postrouting", "prio": 10, "policy": "accept"}}, {"chain": {"family": "ip", =
"table": "x", "name": "postroutingfilterp11", "handle": 0, "type": "filter"=
, "hook": "postrouting", "prio": 11, "policy": "accept"}}, {"chain": {"fami=
ly": "ip", "table": "x", "name": "postroutingsecuritym11", "handle": 0, "ty=
pe": "filter", "hook": "postrouting", "prio": 39, "policy": "accept"}}, {"c=
hain": {"family": "ip", "table": "x", "name": "postroutingsecuritym10", "ha=
ndle": 0, "type": "filter", "hook": "postrouting", "prio": 40, "policy": "a=
ccept"}}, {"chain": {"family": "ip", "table": "x", "name": "postroutingsecu=
rity", "handle": 0, "type": "filter", "hook": "postrouting", "prio": 50, "p=
olicy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "postr=
outingsecurityp10", "handle": 0, "type": "filter", "hook": "postrouting", "=
prio": 60, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "=
name": "postroutingsecurityp11", "handle": 0, "type": "filter", "hook": "po=
strouting", "prio": 61, "policy": "accept"}}, {"chain": {"family": "ip", "t=
able": "x", "name": "preroutingdstnatm11", "handle": 0, "type": "filter", "=
hook": "prerouting", "prio": -111, "policy": "accept"}}, {"chain": {"family=
": "ip", "table": "x", "name": "preroutingdstnatm10", "handle": 0, "type": =
"filter", "hook": "prerouting", "prio": -110, "policy": "accept"}}, {"chain=
": {"family": "ip", "table": "x", "name": "preroutingdstnat", "handle": 0, =
"type": "filter", "hook": "prerouting", "prio": -100, "policy": "accept"}},=
 {"chain": {"family": "ip", "table": "x", "name": "preroutingdstnatp10", "h=
andle": 0, "type": "filter", "hook": "prerouting", "prio": -90, "policy": "=
accept"}}, {"chain": {"family": "ip", "table": "x", "name": "preroutingdstn=
atp11", "handle": 0, "type": "filter", "hook": "prerouting", "prio": -89, "=
policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "name": "post=
routingsrcnatm11", "handle": 0, "type": "filter", "hook": "postrouting", "p=
rio": 89, "policy": "accept"}}, {"chain": {"family": "ip", "table": "x", "n=
ame": "postroutingsrcnatm10", "handle": 0, "type": "filter", "hook": "postr=
outing", "prio": 90, "policy": "accept"}}, {"chain": {"family": "ip", "tabl=
e": "x", "name": "postroutingsrcnat", "handle": 0, "type": "filter", "hook"=
: "postrouting", "prio": 100, "policy": "accept"}}, {"chain": {"family": "i=
p", "table": "x", "name": "postroutingsrcnatp10", "handle": 0, "type": "fil=
ter", "hook": "postrouting", "prio": 110, "policy": "accept"}}, {"chain": {=
"family": "ip", "table": "x", "name": "postroutingsrcnatp11", "handle": 0, =
"type": "filter", "hook": "postrouting", "prio": 111, "policy": "accept"}},=
 {"table": {"family": "ip6", "name": "x", "handle": 0}}, {"chain": {"family=
": "ip6", "table": "x", "name": "preroutingrawm11", "handle": 0, "type": "f=
ilter", "hook": "prerouting", "prio": -311, "policy": "accept"}}, {"chain":=
 {"family": "ip6", "table": "x", "name": "preroutingrawm10", "handle": 0, "=
type": "filter", "hook": "prerouting", "prio": -310, "policy": "accept"}}, =
{"chain": {"family": "ip6", "table": "x", "name": "preroutingraw", "handle"=
: 0, "type": "filter", "hook": "prerouting", "prio": -300, "policy": "accep=
t"}}, {"chain": {"family": "ip6", "table": "x", "name": "preroutingrawp10",=
 "handle": 0, "type": "filter", "hook": "prerouting", "prio": -290, "policy=
": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "preroutin=
grawp11", "handle": 0, "type": "filter", "hook": "prerouting", "prio": -289=
, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "=
preroutingmanglem11", "handle": 0, "type": "filter", "hook": "prerouting", =
"prio": -161, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x=
", "name": "preroutingmanglem10", "handle": 0, "type": "filter", "hook": "p=
rerouting", "prio": -160, "policy": "accept"}}, {"chain": {"family": "ip6",=
 "table": "x", "name": "preroutingmangle", "handle": 0, "type": "filter", "=
hook": "prerouting", "prio": -150, "policy": "accept"}}, {"chain": {"family=
": "ip6", "table": "x", "name": "preroutingmanglep10", "handle": 0, "type":=
 "filter", "hook": "prerouting", "prio": -140, "policy": "accept"}}, {"chai=
n": {"family": "ip6", "table": "x", "name": "preroutingmanglep11", "handle"=
: 0, "type": "filter", "hook": "prerouting", "prio": -139, "policy": "accep=
t"}}, {"chain": {"family": "ip6", "table": "x", "name": "preroutingfilterm1=
1", "handle": 0, "type": "filter", "hook": "prerouting", "prio": -11, "poli=
cy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "prerout=
ingfilterm10", "handle": 0, "type": "filter", "hook": "prerouting", "prio":=
 -10, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name=
": "preroutingfilter", "handle": 0, "type": "filter", "hook": "prerouting",=
 "prio": 0, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x",=
 "name": "preroutingfilterp10", "handle": 0, "type": "filter", "hook": "pre=
routing", "prio": 10, "policy": "accept"}}, {"chain": {"family": "ip6", "ta=
ble": "x", "name": "preroutingfilterp11", "handle": 0, "type": "filter", "h=
ook": "prerouting", "prio": 11, "policy": "accept"}}, {"chain": {"family": =
"ip6", "table": "x", "name": "preroutingsecuritym11", "handle": 0, "type": =
"filter", "hook": "prerouting", "prio": 39, "policy": "accept"}}, {"chain":=
 {"family": "ip6", "table": "x", "name": "preroutingsecuritym10", "handle":=
 0, "type": "filter", "hook": "prerouting", "prio": 40, "policy": "accept"}=
}, {"chain": {"family": "ip6", "table": "x", "name": "preroutingsecurity", =
"handle": 0, "type": "filter", "hook": "prerouting", "prio": 50, "policy": =
"accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "preroutingse=
curityp10", "handle": 0, "type": "filter", "hook": "prerouting", "prio": 60=
, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "=
preroutingsecurityp11", "handle": 0, "type": "filter", "hook": "prerouting"=
, "prio": 61, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x=
", "name": "inputrawm11", "handle": 0, "type": "filter", "hook": "input", "=
prio": -311, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x"=
, "name": "inputrawm10", "handle": 0, "type": "filter", "hook": "input", "p=
rio": -310, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x",=
 "name": "inputraw", "handle": 0, "type": "filter", "hook": "input", "prio"=
: -300, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "na=
me": "inputrawp10", "handle": 0, "type": "filter", "hook": "input", "prio":=
 -290, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "nam=
e": "inputrawp11", "handle": 0, "type": "filter", "hook": "input", "prio": =
-289, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name=
": "inputmanglem11", "handle": 0, "type": "filter", "hook": "input", "prio"=
: -161, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "na=
me": "inputmanglem10", "handle": 0, "type": "filter", "hook": "input", "pri=
o": -160, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "=
name": "inputmangle", "handle": 0, "type": "filter", "hook": "input", "prio=
": -150, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "n=
ame": "inputmanglep10", "handle": 0, "type": "filter", "hook": "input", "pr=
io": -140, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", =
"name": "inputmanglep11", "handle": 0, "type": "filter", "hook": "input", "=
prio": -139, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x"=
, "name": "inputfilterm11", "handle": 0, "type": "filter", "hook": "input",=
 "prio": -11, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x=
", "name": "inputfilterm10", "handle": 0, "type": "filter", "hook": "input"=
, "prio": -10, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "=
x", "name": "inputfilter", "handle": 0, "type": "filter", "hook": "input", =
"prio": 0, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", =
"name": "inputfilterp10", "handle": 0, "type": "filter", "hook": "input", "=
prio": 10, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", =
"name": "inputfilterp11", "handle": 0, "type": "filter", "hook": "input", "=
prio": 11, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", =
"name": "inputsecuritym11", "handle": 0, "type": "filter", "hook": "input",=
 "prio": 39, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x"=
, "name": "inputsecuritym10", "handle": 0, "type": "filter", "hook": "input=
", "prio": 40, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "=
x", "name": "inputsecurity", "handle": 0, "type": "filter", "hook": "input"=
, "prio": 50, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x=
", "name": "inputsecurityp10", "handle": 0, "type": "filter", "hook": "inpu=
t", "prio": 60, "policy": "accept"}}, {"chain": {"family": "ip6", "table": =
"x", "name": "inputsecurityp11", "handle": 0, "type": "filter", "hook": "in=
put", "prio": 61, "policy": "accept"}}, {"chain": {"family": "ip6", "table"=
: "x", "name": "forwardrawm11", "handle": 0, "type": "filter", "hook": "for=
ward", "prio": -311, "policy": "accept"}}, {"chain": {"family": "ip6", "tab=
le": "x", "name": "forwardrawm10", "handle": 0, "type": "filter", "hook": "=
forward", "prio": -310, "policy": "accept"}}, {"chain": {"family": "ip6", "=
table": "x", "name": "forwardraw", "handle": 0, "type": "filter", "hook": "=
forward", "prio": -300, "policy": "accept"}}, {"chain": {"family": "ip6", "=
table": "x", "name": "forwardrawp10", "handle": 0, "type": "filter", "hook"=
: "forward", "prio": -290, "policy": "accept"}}, {"chain": {"family": "ip6"=
, "table": "x", "name": "forwardrawp11", "handle": 0, "type": "filter", "ho=
ok": "forward", "prio": -289, "policy": "accept"}}, {"chain": {"family": "i=
p6", "table": "x", "name": "forwardmanglem11", "handle": 0, "type": "filter=
", "hook": "forward", "prio": -161, "policy": "accept"}}, {"chain": {"famil=
y": "ip6", "table": "x", "name": "forwardmanglem10", "handle": 0, "type": "=
filter", "hook": "forward", "prio": -160, "policy": "accept"}}, {"chain": {=
"family": "ip6", "table": "x", "name": "forwardmangle", "handle": 0, "type"=
: "filter", "hook": "forward", "prio": -150, "policy": "accept"}}, {"chain"=
: {"family": "ip6", "table": "x", "name": "forwardmanglep10", "handle": 0, =
"type": "filter", "hook": "forward", "prio": -140, "policy": "accept"}}, {"=
chain": {"family": "ip6", "table": "x", "name": "forwardmanglep11", "handle=
": 0, "type": "filter", "hook": "forward", "prio": -139, "policy": "accept"=
}}, {"chain": {"family": "ip6", "table": "x", "name": "forwardfilterm11", "=
handle": 0, "type": "filter", "hook": "forward", "prio": -11, "policy": "ac=
cept"}}, {"chain": {"family": "ip6", "table": "x", "name": "forwardfilterm1=
0", "handle": 0, "type": "filter", "hook": "forward", "prio": -10, "policy"=
: "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "forwardfil=
ter", "handle": 0, "type": "filter", "hook": "forward", "prio": 0, "policy"=
: "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "forwardfil=
terp10", "handle": 0, "type": "filter", "hook": "forward", "prio": 10, "pol=
icy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "forwar=
dfilterp11", "handle": 0, "type": "filter", "hook": "forward", "prio": 11, =
"policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "fo=
rwardsecuritym11", "handle": 0, "type": "filter", "hook": "forward", "prio"=
: 39, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name=
": "forwardsecuritym10", "handle": 0, "type": "filter", "hook": "forward", =
"prio": 40, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x",=
 "name": "forwardsecurity", "handle": 0, "type": "filter", "hook": "forward=
", "prio": 50, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "=
x", "name": "forwardsecurityp10", "handle": 0, "type": "filter", "hook": "f=
orward", "prio": 60, "policy": "accept"}}, {"chain": {"family": "ip6", "tab=
le": "x", "name": "forwardsecurityp11", "handle": 0, "type": "filter", "hoo=
k": "forward", "prio": 61, "policy": "accept"}}, {"chain": {"family": "ip6"=
, "table": "x", "name": "outputrawm11", "handle": 0, "type": "filter", "hoo=
k": "output", "prio": -311, "policy": "accept"}}, {"chain": {"family": "ip6=
", "table": "x", "name": "outputrawm10", "handle": 0, "type": "filter", "ho=
ok": "output", "prio": -310, "policy": "accept"}}, {"chain": {"family": "ip=
6", "table": "x", "name": "outputraw", "handle": 0, "type": "filter", "hook=
": "output", "prio": -300, "policy": "accept"}}, {"chain": {"family": "ip6"=
, "table": "x", "name": "outputrawp10", "handle": 0, "type": "filter", "hoo=
k": "output", "prio": -290, "policy": "accept"}}, {"chain": {"family": "ip6=
", "table": "x", "name": "outputrawp11", "handle": 0, "type": "filter", "ho=
ok": "output", "prio": -289, "policy": "accept"}}, {"chain": {"family": "ip=
6", "table": "x", "name": "outputmanglem11", "handle": 0, "type": "filter",=
 "hook": "output", "prio": -161, "policy": "accept"}}, {"chain": {"family":=
 "ip6", "table": "x", "name": "outputmanglem10", "handle": 0, "type": "filt=
er", "hook": "output", "prio": -160, "policy": "accept"}}, {"chain": {"fami=
ly": "ip6", "table": "x", "name": "outputmangle", "handle": 0, "type": "fil=
ter", "hook": "output", "prio": -150, "policy": "accept"}}, {"chain": {"fam=
ily": "ip6", "table": "x", "name": "outputmanglep10", "handle": 0, "type": =
"filter", "hook": "output", "prio": -140, "policy": "accept"}}, {"chain": {=
"family": "ip6", "table": "x", "name": "outputmanglep11", "handle": 0, "typ=
e": "filter", "hook": "output", "prio": -139, "policy": "accept"}}, {"chain=
": {"family": "ip6", "table": "x", "name": "outputfilterm11", "handle": 0, =
"type": "filter", "hook": "output", "prio": -11, "policy": "accept"}}, {"ch=
ain": {"family": "ip6", "table": "x", "name": "outputfilterm10", "handle": =
0, "type": "filter", "hook": "output", "prio": -10, "policy": "accept"}}, {=
"chain": {"family": "ip6", "table": "x", "name": "outputfilter", "handle": =
0, "type": "filter", "hook": "output", "prio": 0, "policy": "accept"}}, {"c=
hain": {"family": "ip6", "table": "x", "name": "outputfilterp10", "handle":=
 0, "type": "filter", "hook": "output", "prio": 10, "policy": "accept"}}, {=
"chain": {"family": "ip6", "table": "x", "name": "outputfilterp11", "handle=
": 0, "type": "filter", "hook": "output", "prio": 11, "policy": "accept"}},=
 {"chain": {"family": "ip6", "table": "x", "name": "outputsecuritym11", "ha=
ndle": 0, "type": "filter", "hook": "output", "prio": 39, "policy": "accept=
"}}, {"chain": {"family": "ip6", "table": "x", "name": "outputsecuritym10",=
 "handle": 0, "type": "filter", "hook": "output", "prio": 40, "policy": "ac=
cept"}}, {"chain": {"family": "ip6", "table": "x", "name": "outputsecurity"=
, "handle": 0, "type": "filter", "hook": "output", "prio": 50, "policy": "a=
ccept"}}, {"chain": {"family": "ip6", "table": "x", "name": "outputsecurity=
p10", "handle": 0, "type": "filter", "hook": "output", "prio": 60, "policy"=
: "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "outputsecu=
rityp11", "handle": 0, "type": "filter", "hook": "output", "prio": 61, "pol=
icy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "postro=
utingrawm11", "handle": 0, "type": "filter", "hook": "postrouting", "prio":=
 -311, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "nam=
e": "postroutingrawm10", "handle": 0, "type": "filter", "hook": "postroutin=
g", "prio": -310, "policy": "accept"}}, {"chain": {"family": "ip6", "table"=
: "x", "name": "postroutingraw", "handle": 0, "type": "filter", "hook": "po=
strouting", "prio": -300, "policy": "accept"}}, {"chain": {"family": "ip6",=
 "table": "x", "name": "postroutingrawp10", "handle": 0, "type": "filter", =
"hook": "postrouting", "prio": -290, "policy": "accept"}}, {"chain": {"fami=
ly": "ip6", "table": "x", "name": "postroutingrawp11", "handle": 0, "type":=
 "filter", "hook": "postrouting", "prio": -289, "policy": "accept"}}, {"cha=
in": {"family": "ip6", "table": "x", "name": "postroutingmanglem11", "handl=
e": 0, "type": "filter", "hook": "postrouting", "prio": -161, "policy": "ac=
cept"}}, {"chain": {"family": "ip6", "table": "x", "name": "postroutingmang=
lem10", "handle": 0, "type": "filter", "hook": "postrouting", "prio": -160,=
 "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "p=
ostroutingmangle", "handle": 0, "type": "filter", "hook": "postrouting", "p=
rio": -150, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x",=
 "name": "postroutingmanglep10", "handle": 0, "type": "filter", "hook": "po=
strouting", "prio": -140, "policy": "accept"}}, {"chain": {"family": "ip6",=
 "table": "x", "name": "postroutingmanglep11", "handle": 0, "type": "filter=
", "hook": "postrouting", "prio": -139, "policy": "accept"}}, {"chain": {"f=
amily": "ip6", "table": "x", "name": "postroutingfilterm11", "handle": 0, "=
type": "filter", "hook": "postrouting", "prio": -11, "policy": "accept"}}, =
{"chain": {"family": "ip6", "table": "x", "name": "postroutingfilterm10", "=
handle": 0, "type": "filter", "hook": "postrouting", "prio": -10, "policy":=
 "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "postrouting=
filter", "handle": 0, "type": "filter", "hook": "postrouting", "prio": 0, "=
policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "pos=
troutingfilterp10", "handle": 0, "type": "filter", "hook": "postrouting", "=
prio": 10, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", =
"name": "postroutingfilterp11", "handle": 0, "type": "filter", "hook": "pos=
trouting", "prio": 11, "policy": "accept"}}, {"chain": {"family": "ip6", "t=
able": "x", "name": "postroutingsecuritym11", "handle": 0, "type": "filter"=
, "hook": "postrouting", "prio": 39, "policy": "accept"}}, {"chain": {"fami=
ly": "ip6", "table": "x", "name": "postroutingsecuritym10", "handle": 0, "t=
ype": "filter", "hook": "postrouting", "prio": 40, "policy": "accept"}}, {"=
chain": {"family": "ip6", "table": "x", "name": "postroutingsecurity", "han=
dle": 0, "type": "filter", "hook": "postrouting", "prio": 50, "policy": "ac=
cept"}}, {"chain": {"family": "ip6", "table": "x", "name": "postroutingsecu=
rityp10", "handle": 0, "type": "filter", "hook": "postrouting", "prio": 60,=
 "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "p=
ostroutingsecurityp11", "handle": 0, "type": "filter", "hook": "postrouting=
", "prio": 61, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "=
x", "name": "preroutingdstnatm11", "handle": 0, "type": "filter", "hook": "=
prerouting", "prio": -111, "policy": "accept"}}, {"chain": {"family": "ip6"=
, "table": "x", "name": "preroutingdstnatm10", "handle": 0, "type": "filter=
", "hook": "prerouting", "prio": -110, "policy": "accept"}}, {"chain": {"fa=
mily": "ip6", "table": "x", "name": "preroutingdstnat", "handle": 0, "type"=
: "filter", "hook": "prerouting", "prio": -100, "policy": "accept"}}, {"cha=
in": {"family": "ip6", "table": "x", "name": "preroutingdstnatp10", "handle=
": 0, "type": "filter", "hook": "prerouting", "prio": -90, "policy": "accep=
t"}}, {"chain": {"family": "ip6", "table": "x", "name": "preroutingdstnatp1=
1", "handle": 0, "type": "filter", "hook": "prerouting", "prio": -89, "poli=
cy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "name": "postrou=
tingsrcnatm11", "handle": 0, "type": "filter", "hook": "postrouting", "prio=
": 89, "policy": "accept"}}, {"chain": {"family": "ip6", "table": "x", "nam=
e": "postroutingsrcnatm10", "handle": 0, "type": "filter", "hook": "postrou=
ting", "prio": 90, "policy": "accept"}}, {"chain": {"family": "ip6", "table=
": "x", "name": "postroutingsrcnat", "handle": 0, "type": "filter", "hook":=
 "postrouting", "prio": 100, "policy": "accept"}}, {"chain": {"family": "ip=
6", "table": "x", "name": "postroutingsrcnatp10", "handle": 0, "type": "fil=
ter", "hook": "postrouting", "prio": 110, "policy": "accept"}}, {"chain": {=
"family": "ip6", "table": "x", "name": "postroutingsrcnatp11", "handle": 0,=
 "type": "filter", "hook": "postrouting", "prio": 111, "policy": "accept"}}=
, {"table": {"family": "inet", "name": "x", "handle": 0}}, {"chain": {"fami=
ly": "inet", "table": "x", "name": "preroutingrawm11", "handle": 0, "type":=
 "filter", "hook": "prerouting", "prio": -311, "policy": "accept"}}, {"chai=
n": {"family": "inet", "table": "x", "name": "preroutingrawm10", "handle": =
0, "type": "filter", "hook": "prerouting", "prio": -310, "policy": "accept"=
}}, {"chain": {"family": "inet", "table": "x", "name": "preroutingraw", "ha=
ndle": 0, "type": "filter", "hook": "prerouting", "prio": -300, "policy": "=
accept"}}, {"chain": {"family": "inet", "table": "x", "name": "preroutingra=
wp10", "handle": 0, "type": "filter", "hook": "prerouting", "prio": -290, "=
policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "pr=
eroutingrawp11", "handle": 0, "type": "filter", "hook": "prerouting", "prio=
": -289, "policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "=
name": "preroutingmanglem11", "handle": 0, "type": "filter", "hook": "prero=
uting", "prio": -161, "policy": "accept"}}, {"chain": {"family": "inet", "t=
able": "x", "name": "preroutingmanglem10", "handle": 0, "type": "filter", "=
hook": "prerouting", "prio": -160, "policy": "accept"}}, {"chain": {"family=
": "inet", "table": "x", "name": "preroutingmangle", "handle": 0, "type": "=
filter", "hook": "prerouting", "prio": -150, "policy": "accept"}}, {"chain"=
: {"family": "inet", "table": "x", "name": "preroutingmanglep10", "handle":=
 0, "type": "filter", "hook": "prerouting", "prio": -140, "policy": "accept=
"}}, {"chain": {"family": "inet", "table": "x", "name": "preroutingmanglep1=
1", "handle": 0, "type": "filter", "hook": "prerouting", "prio": -139, "pol=
icy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "prero=
utingfilterm11", "handle": 0, "type": "filter", "hook": "prerouting", "prio=
": -11, "policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "n=
ame": "preroutingfilterm10", "handle": 0, "type": "filter", "hook": "prerou=
ting", "prio": -10, "policy": "accept"}}, {"chain": {"family": "inet", "tab=
le": "x", "name": "preroutingfilter", "handle": 0, "type": "filter", "hook"=
: "prerouting", "prio": 0, "policy": "accept"}}, {"chain": {"family": "inet=
", "table": "x", "name": "preroutingfilterp10", "handle": 0, "type": "filte=
r", "hook": "prerouting", "prio": 10, "policy": "accept"}}, {"chain": {"fam=
ily": "inet", "table": "x", "name": "preroutingfilterp11", "handle": 0, "ty=
pe": "filter", "hook": "prerouting", "prio": 11, "policy": "accept"}}, {"ch=
ain": {"family": "inet", "table": "x", "name": "preroutingsecuritym11", "ha=
ndle": 0, "type": "filter", "hook": "prerouting", "prio": 39, "policy": "ac=
cept"}}, {"chain": {"family": "inet", "table": "x", "name": "preroutingsecu=
ritym10", "handle": 0, "type": "filter", "hook": "prerouting", "prio": 40, =
"policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "p=
reroutingsecurity", "handle": 0, "type": "filter", "hook": "prerouting", "p=
rio": 50, "policy": "accept"}}, {"chain": {"family": "inet", "table": "x", =
"name": "preroutingsecurityp10", "handle": 0, "type": "filter", "hook": "pr=
erouting", "prio": 60, "policy": "accept"}}, {"chain": {"family": "inet", "=
table": "x", "name": "preroutingsecurityp11", "handle": 0, "type": "filter"=
, "hook": "prerouting", "prio": 61, "policy": "accept"}}, {"chain": {"famil=
y": "inet", "table": "x", "name": "inputrawm11", "handle": 0, "type": "filt=
er", "hook": "input", "prio": -311, "policy": "accept"}}, {"chain": {"famil=
y": "inet", "table": "x", "name": "inputrawm10", "handle": 0, "type": "filt=
er", "hook": "input", "prio": -310, "policy": "accept"}}, {"chain": {"famil=
y": "inet", "table": "x", "name": "inputraw", "handle": 0, "type": "filter"=
, "hook": "input", "prio": -300, "policy": "accept"}}, {"chain": {"family":=
 "inet", "table": "x", "name": "inputrawp10", "handle": 0, "type": "filter"=
, "hook": "input", "prio": -290, "policy": "accept"}}, {"chain": {"family":=
 "inet", "table": "x", "name": "inputrawp11", "handle": 0, "type": "filter"=
, "hook": "input", "prio": -289, "policy": "accept"}}, {"chain": {"family":=
 "inet", "table": "x", "name": "inputmanglem11", "handle": 0, "type": "filt=
er", "hook": "input", "prio": -161, "policy": "accept"}}, {"chain": {"famil=
y": "inet", "table": "x", "name": "inputmanglem10", "handle": 0, "type": "f=
ilter", "hook": "input", "prio": -160, "policy": "accept"}}, {"chain": {"fa=
mily": "inet", "table": "x", "name": "inputmangle", "handle": 0, "type": "f=
ilter", "hook": "input", "prio": -150, "policy": "accept"}}, {"chain": {"fa=
mily": "inet", "table": "x", "name": "inputmanglep10", "handle": 0, "type":=
 "filter", "hook": "input", "prio": -140, "policy": "accept"}}, {"chain": {=
"family": "inet", "table": "x", "name": "inputmanglep11", "handle": 0, "typ=
e": "filter", "hook": "input", "prio": -139, "policy": "accept"}}, {"chain"=
: {"family": "inet", "table": "x", "name": "inputfilterm11", "handle": 0, "=
type": "filter", "hook": "input", "prio": -11, "policy": "accept"}}, {"chai=
n": {"family": "inet", "table": "x", "name": "inputfilterm10", "handle": 0,=
 "type": "filter", "hook": "input", "prio": -10, "policy": "accept"}}, {"ch=
ain": {"family": "inet", "table": "x", "name": "inputfilter", "handle": 0, =
"type": "filter", "hook": "input", "prio": 0, "policy": "accept"}}, {"chain=
": {"family": "inet", "table": "x", "name": "inputfilterp10", "handle": 0, =
"type": "filter", "hook": "input", "prio": 10, "policy": "accept"}}, {"chai=
n": {"family": "inet", "table": "x", "name": "inputfilterp11", "handle": 0,=
 "type": "filter", "hook": "input", "prio": 11, "policy": "accept"}}, {"cha=
in": {"family": "inet", "table": "x", "name": "inputsecuritym11", "handle":=
 0, "type": "filter", "hook": "input", "prio": 39, "policy": "accept"}}, {"=
chain": {"family": "inet", "table": "x", "name": "inputsecuritym10", "handl=
e": 0, "type": "filter", "hook": "input", "prio": 40, "policy": "accept"}},=
 {"chain": {"family": "inet", "table": "x", "name": "inputsecurity", "handl=
e": 0, "type": "filter", "hook": "input", "prio": 50, "policy": "accept"}},=
 {"chain": {"family": "inet", "table": "x", "name": "inputsecurityp10", "ha=
ndle": 0, "type": "filter", "hook": "input", "prio": 60, "policy": "accept"=
}}, {"chain": {"family": "inet", "table": "x", "name": "inputsecurityp11", =
"handle": 0, "type": "filter", "hook": "input", "prio": 61, "policy": "acce=
pt"}}, {"chain": {"family": "inet", "table": "x", "name": "forwardrawm11", =
"handle": 0, "type": "filter", "hook": "forward", "prio": -311, "policy": "=
accept"}}, {"chain": {"family": "inet", "table": "x", "name": "forwardrawm1=
0", "handle": 0, "type": "filter", "hook": "forward", "prio": -310, "policy=
": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "forwardr=
aw", "handle": 0, "type": "filter", "hook": "forward", "prio": -300, "polic=
y": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "forward=
rawp10", "handle": 0, "type": "filter", "hook": "forward", "prio": -290, "p=
olicy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "for=
wardrawp11", "handle": 0, "type": "filter", "hook": "forward", "prio": -289=
, "policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": =
"forwardmanglem11", "handle": 0, "type": "filter", "hook": "forward", "prio=
": -161, "policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "=
name": "forwardmanglem10", "handle": 0, "type": "filter", "hook": "forward"=
, "prio": -160, "policy": "accept"}}, {"chain": {"family": "inet", "table":=
 "x", "name": "forwardmangle", "handle": 0, "type": "filter", "hook": "forw=
ard", "prio": -150, "policy": "accept"}}, {"chain": {"family": "inet", "tab=
le": "x", "name": "forwardmanglep10", "handle": 0, "type": "filter", "hook"=
: "forward", "prio": -140, "policy": "accept"}}, {"chain": {"family": "inet=
", "table": "x", "name": "forwardmanglep11", "handle": 0, "type": "filter",=
 "hook": "forward", "prio": -139, "policy": "accept"}}, {"chain": {"family"=
: "inet", "table": "x", "name": "forwardfilterm11", "handle": 0, "type": "f=
ilter", "hook": "forward", "prio": -11, "policy": "accept"}}, {"chain": {"f=
amily": "inet", "table": "x", "name": "forwardfilterm10", "handle": 0, "typ=
e": "filter", "hook": "forward", "prio": -10, "policy": "accept"}}, {"chain=
": {"family": "inet", "table": "x", "name": "forwardfilter", "handle": 0, "=
type": "filter", "hook": "forward", "prio": 0, "policy": "accept"}}, {"chai=
n": {"family": "inet", "table": "x", "name": "forwardfilterp10", "handle": =
0, "type": "filter", "hook": "forward", "prio": 10, "policy": "accept"}}, {=
"chain": {"family": "inet", "table": "x", "name": "forwardfilterp11", "hand=
le": 0, "type": "filter", "hook": "forward", "prio": 11, "policy": "accept"=
}}, {"chain": {"family": "inet", "table": "x", "name": "forwardsecuritym11"=
, "handle": 0, "type": "filter", "hook": "forward", "prio": 39, "policy": "=
accept"}}, {"chain": {"family": "inet", "table": "x", "name": "forwardsecur=
itym10", "handle": 0, "type": "filter", "hook": "forward", "prio": 40, "pol=
icy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "forwa=
rdsecurity", "handle": 0, "type": "filter", "hook": "forward", "prio": 50, =
"policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "f=
orwardsecurityp10", "handle": 0, "type": "filter", "hook": "forward", "prio=
": 60, "policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "na=
me": "forwardsecurityp11", "handle": 0, "type": "filter", "hook": "forward"=
, "prio": 61, "policy": "accept"}}, {"chain": {"family": "inet", "table": "=
x", "name": "outputrawm11", "handle": 0, "type": "filter", "hook": "output"=
, "prio": -311, "policy": "accept"}}, {"chain": {"family": "inet", "table":=
 "x", "name": "outputrawm10", "handle": 0, "type": "filter", "hook": "outpu=
t", "prio": -310, "policy": "accept"}}, {"chain": {"family": "inet", "table=
": "x", "name": "outputraw", "handle": 0, "type": "filter", "hook": "output=
", "prio": -300, "policy": "accept"}}, {"chain": {"family": "inet", "table"=
: "x", "name": "outputrawp10", "handle": 0, "type": "filter", "hook": "outp=
ut", "prio": -290, "policy": "accept"}}, {"chain": {"family": "inet", "tabl=
e": "x", "name": "outputrawp11", "handle": 0, "type": "filter", "hook": "ou=
tput", "prio": -289, "policy": "accept"}}, {"chain": {"family": "inet", "ta=
ble": "x", "name": "outputmanglem11", "handle": 0, "type": "filter", "hook"=
: "output", "prio": -161, "policy": "accept"}}, {"chain": {"family": "inet"=
, "table": "x", "name": "outputmanglem10", "handle": 0, "type": "filter", "=
hook": "output", "prio": -160, "policy": "accept"}}, {"chain": {"family": "=
inet", "table": "x", "name": "outputmangle", "handle": 0, "type": "filter",=
 "hook": "output", "prio": -150, "policy": "accept"}}, {"chain": {"family":=
 "inet", "table": "x", "name": "outputmanglep10", "handle": 0, "type": "fil=
ter", "hook": "output", "prio": -140, "policy": "accept"}}, {"chain": {"fam=
ily": "inet", "table": "x", "name": "outputmanglep11", "handle": 0, "type":=
 "filter", "hook": "output", "prio": -139, "policy": "accept"}}, {"chain": =
{"family": "inet", "table": "x", "name": "outputfilterm11", "handle": 0, "t=
ype": "filter", "hook": "output", "prio": -11, "policy": "accept"}}, {"chai=
n": {"family": "inet", "table": "x", "name": "outputfilterm10", "handle": 0=
, "type": "filter", "hook": "output", "prio": -10, "policy": "accept"}}, {"=
chain": {"family": "inet", "table": "x", "name": "outputfilter", "handle": =
0, "type": "filter", "hook": "output", "prio": 0, "policy": "accept"}}, {"c=
hain": {"family": "inet", "table": "x", "name": "outputfilterp10", "handle"=
: 0, "type": "filter", "hook": "output", "prio": 10, "policy": "accept"}}, =
{"chain": {"family": "inet", "table": "x", "name": "outputfilterp11", "hand=
le": 0, "type": "filter", "hook": "output", "prio": 11, "policy": "accept"}=
}, {"chain": {"family": "inet", "table": "x", "name": "outputsecuritym11", =
"handle": 0, "type": "filter", "hook": "output", "prio": 39, "policy": "acc=
ept"}}, {"chain": {"family": "inet", "table": "x", "name": "outputsecuritym=
10", "handle": 0, "type": "filter", "hook": "output", "prio": 40, "policy":=
 "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "outputsecu=
rity", "handle": 0, "type": "filter", "hook": "output", "prio": 50, "policy=
": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "outputse=
curityp10", "handle": 0, "type": "filter", "hook": "output", "prio": 60, "p=
olicy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "out=
putsecurityp11", "handle": 0, "type": "filter", "hook": "output", "prio": 6=
1, "policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name":=
 "postroutingrawm11", "handle": 0, "type": "filter", "hook": "postrouting",=
 "prio": -311, "policy": "accept"}}, {"chain": {"family": "inet", "table": =
"x", "name": "postroutingrawm10", "handle": 0, "type": "filter", "hook": "p=
ostrouting", "prio": -310, "policy": "accept"}}, {"chain": {"family": "inet=
", "table": "x", "name": "postroutingraw", "handle": 0, "type": "filter", "=
hook": "postrouting", "prio": -300, "policy": "accept"}}, {"chain": {"famil=
y": "inet", "table": "x", "name": "postroutingrawp10", "handle": 0, "type":=
 "filter", "hook": "postrouting", "prio": -290, "policy": "accept"}}, {"cha=
in": {"family": "inet", "table": "x", "name": "postroutingrawp11", "handle"=
: 0, "type": "filter", "hook": "postrouting", "prio": -289, "policy": "acce=
pt"}}, {"chain": {"family": "inet", "table": "x", "name": "postroutingmangl=
em11", "handle": 0, "type": "filter", "hook": "postrouting", "prio": -161, =
"policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "p=
ostroutingmanglem10", "handle": 0, "type": "filter", "hook": "postrouting",=
 "prio": -160, "policy": "accept"}}, {"chain": {"family": "inet", "table": =
"x", "name": "postroutingmangle", "handle": 0, "type": "filter", "hook": "p=
ostrouting", "prio": -150, "policy": "accept"}}, {"chain": {"family": "inet=
", "table": "x", "name": "postroutingmanglep10", "handle": 0, "type": "filt=
er", "hook": "postrouting", "prio": -140, "policy": "accept"}}, {"chain": {=
"family": "inet", "table": "x", "name": "postroutingmanglep11", "handle": 0=
, "type": "filter", "hook": "postrouting", "prio": -139, "policy": "accept"=
}}, {"chain": {"family": "inet", "table": "x", "name": "postroutingfilterm1=
1", "handle": 0, "type": "filter", "hook": "postrouting", "prio": -11, "pol=
icy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "postr=
outingfilterm10", "handle": 0, "type": "filter", "hook": "postrouting", "pr=
io": -10, "policy": "accept"}}, {"chain": {"family": "inet", "table": "x", =
"name": "postroutingfilter", "handle": 0, "type": "filter", "hook": "postro=
uting", "prio": 0, "policy": "accept"}}, {"chain": {"family": "inet", "tabl=
e": "x", "name": "postroutingfilterp10", "handle": 0, "type": "filter", "ho=
ok": "postrouting", "prio": 10, "policy": "accept"}}, {"chain": {"family": =
"inet", "table": "x", "name": "postroutingfilterp11", "handle": 0, "type": =
"filter", "hook": "postrouting", "prio": 11, "policy": "accept"}}, {"chain"=
: {"family": "inet", "table": "x", "name": "postroutingsecuritym11", "handl=
e": 0, "type": "filter", "hook": "postrouting", "prio": 39, "policy": "acce=
pt"}}, {"chain": {"family": "inet", "table": "x", "name": "postroutingsecur=
itym10", "handle": 0, "type": "filter", "hook": "postrouting", "prio": 40, =
"policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "p=
ostroutingsecurity", "handle": 0, "type": "filter", "hook": "postrouting", =
"prio": 50, "policy": "accept"}}, {"chain": {"family": "inet", "table": "x"=
, "name": "postroutingsecurityp10", "handle": 0, "type": "filter", "hook": =
"postrouting", "prio": 60, "policy": "accept"}}, {"chain": {"family": "inet=
", "table": "x", "name": "postroutingsecurityp11", "handle": 0, "type": "fi=
lter", "hook": "postrouting", "prio": 61, "policy": "accept"}}, {"chain": {=
"family": "inet", "table": "x", "name": "preroutingdstnatm11", "handle": 0,=
 "type": "filter", "hook": "prerouting", "prio": -111, "policy": "accept"}}=
, {"chain": {"family": "inet", "table": "x", "name": "preroutingdstnatm10",=
 "handle": 0, "type": "filter", "hook": "prerouting", "prio": -110, "policy=
": "accept"}}, {"chain": {"family": "inet", "table": "x", "name": "prerouti=
ngdstnat", "handle": 0, "type": "filter", "hook": "prerouting", "prio": -10=
0, "policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name":=
 "preroutingdstnatp10", "handle": 0, "type": "filter", "hook": "prerouting"=
, "prio": -90, "policy": "accept"}}, {"chain": {"family": "inet", "table": =
"x", "name": "preroutingdstnatp11", "handle": 0, "type": "filter", "hook": =
"prerouting", "prio": -89, "policy": "accept"}}, {"chain": {"family": "inet=
", "table": "x", "name": "postroutingsrcnatm11", "handle": 0, "type": "filt=
er", "hook": "postrouting", "prio": 89, "policy": "accept"}}, {"chain": {"f=
amily": "inet", "table": "x", "name": "postroutingsrcnatm10", "handle": 0, =
"type": "filter", "hook": "postrouting", "prio": 90, "policy": "accept"}}, =
{"chain": {"family": "inet", "table": "x", "name": "postroutingsrcnat", "ha=
ndle": 0, "type": "filter", "hook": "postrouting", "prio": 100, "policy": "=
accept"}}, {"chain": {"family": "inet", "table": "x", "name": "postroutings=
rcnatp10", "handle": 0, "type": "filter", "hook": "postrouting", "prio": 11=
0, "policy": "accept"}}, {"chain": {"family": "inet", "table": "x", "name":=
 "postroutingsrcnatp11", "handle": 0, "type": "filter", "hook": "postroutin=
g", "prio": 111, "policy": "accept"}}, {"table": {"family": "arp", "name": =
"x", "handle": 0}}, {"chain": {"family": "arp", "table": "x", "name": "inpu=
tfilterm11", "handle": 0, "type": "filter", "hook": "input", "prio": -11, "=
policy": "accept"}}, {"chain": {"family": "arp", "table": "x", "name": "inp=
utfilterm10", "handle": 0, "type": "filter", "hook": "input", "prio": -10, =
"policy": "accept"}}, {"chain": {"family": "arp", "table": "x", "name": "in=
putfilter", "handle": 0, "type": "filter", "hook": "input", "prio": 0, "pol=
icy": "accept"}}, {"chain": {"family": "arp", "table": "x", "name": "inputf=
ilterp10", "handle": 0, "type": "filter", "hook": "input", "prio": 10, "pol=
icy": "accept"}}, {"chain": {"family": "arp", "table": "x", "name": "inputf=
ilterp11", "handle": 0, "type": "filter", "hook": "input", "prio": 11, "pol=
icy": "accept"}}, {"chain": {"family": "arp", "table": "x", "name": "output=
filterm11", "handle": 0, "type": "filter", "hook": "output", "prio": -11, "=
policy": "accept"}}, {"chain": {"family": "arp", "table": "x", "name": "out=
putfilterm10", "handle": 0, "type": "filter", "hook": "output", "prio": -10=
, "policy": "accept"}}, {"chain": {"family": "arp", "table": "x", "name": "=
outputfilter", "handle": 0, "type": "filter", "hook": "output", "prio": 0, =
"policy": "accept"}}, {"chain": {"family": "arp", "table": "x", "name": "ou=
tputfilterp10", "handle": 0, "type": "filter", "hook": "output", "prio": 10=
, "policy": "accept"}}, {"chain": {"family": "arp", "table": "x", "name": "=
outputfilterp11", "handle": 0, "type": "filter", "hook": "output", "prio": =
11, "policy": "accept"}}, {"table": {"family": "netdev", "name": "x", "hand=
le": 0}}, {"chain": {"family": "netdev", "table": "x", "name": "ingressfilt=
erm11", "handle": 0, "dev": "lo", "type": "filter", "hook": "ingress", "pri=
o": -11, "policy": "accept"}}, {"chain": {"family": "netdev", "table": "x",=
 "name": "ingressfilterm10", "handle": 0, "dev": "lo", "type": "filter", "h=
ook": "ingress", "prio": -10, "policy": "accept"}}, {"chain": {"family": "n=
etdev", "table": "x", "name": "ingressfilter", "handle": 0, "dev": "lo", "t=
ype": "filter", "hook": "ingress", "prio": 0, "policy": "accept"}}, {"chain=
": {"family": "netdev", "table": "x", "name": "ingressfilterp10", "handle":=
 0, "dev": "lo", "type": "filter", "hook": "ingress", "prio": 10, "policy":=
 "accept"}}, {"chain": {"family": "netdev", "table": "x", "name": "ingressf=
ilterp11", "handle": 0, "dev": "lo", "type": "filter", "hook": "ingress", "=
prio": 11, "policy": "accept"}}, {"chain": {"family": "netdev", "table": "x=
", "name": "egressfilterm11", "handle": 0, "dev": "lo", "type": "filter", "=
hook": "egress", "prio": -11, "policy": "accept"}}, {"chain": {"family": "n=
etdev", "table": "x", "name": "egressfilterm10", "handle": 0, "dev": "lo", =
"type": "filter", "hook": "egress", "prio": -10, "policy": "accept"}}, {"ch=
ain": {"family": "netdev", "table": "x", "name": "egressfilter", "handle": =
0, "dev": "lo", "type": "filter", "hook": "egress", "prio": 0, "policy": "a=
ccept"}}, {"chain": {"family": "netdev", "table": "x", "name": "egressfilte=
rp10", "handle": 0, "dev": "lo", "type": "filter", "hook": "egress", "prio"=
: 10, "policy": "accept"}}, {"chain": {"family": "netdev", "table": "x", "n=
ame": "egressfilterp11", "handle": 0, "dev": "lo", "type": "filter", "hook"=
: "egress", "prio": 11, "policy": "accept"}}, {"table": {"family": "bridge"=
, "name": "x", "handle": 0}}, {"chain": {"family": "bridge", "table": "x", =
"name": "preroutingfilterm11", "handle": 0, "type": "filter", "hook": "prer=
outing", "prio": -211, "policy": "accept"}}, {"chain": {"family": "bridge",=
 "table": "x", "name": "preroutingfilterm10", "handle": 0, "type": "filter"=
, "hook": "prerouting", "prio": -210, "policy": "accept"}}, {"chain": {"fam=
ily": "bridge", "table": "x", "name": "preroutingfilter", "handle": 0, "typ=
e": "filter", "hook": "prerouting", "prio": -200, "policy": "accept"}}, {"c=
hain": {"family": "bridge", "table": "x", "name": "preroutingfilterp10", "h=
andle": 0, "type": "filter", "hook": "prerouting", "prio": -190, "policy": =
"accept"}}, {"chain": {"family": "bridge", "table": "x", "name": "preroutin=
gfilterp11", "handle": 0, "type": "filter", "hook": "prerouting", "prio": -=
189, "policy": "accept"}}, {"chain": {"family": "bridge", "table": "x", "na=
me": "inputfilterm11", "handle": 0, "type": "filter", "hook": "input", "pri=
o": -211, "policy": "accept"}}, {"chain": {"family": "bridge", "table": "x"=
, "name": "inputfilterm10", "handle": 0, "type": "filter", "hook": "input",=
 "prio": -210, "policy": "accept"}}, {"chain": {"family": "bridge", "table"=
: "x", "name": "inputfilter", "handle": 0, "type": "filter", "hook": "input=
", "prio": -200, "policy": "accept"}}, {"chain": {"family": "bridge", "tabl=
e": "x", "name": "inputfilterp10", "handle": 0, "type": "filter", "hook": "=
input", "prio": -190, "policy": "accept"}}, {"chain": {"family": "bridge", =
"table": "x", "name": "inputfilterp11", "handle": 0, "type": "filter", "hoo=
k": "input", "prio": -189, "policy": "accept"}}, {"chain": {"family": "brid=
ge", "table": "x", "name": "forwardfilterm11", "handle": 0, "type": "filter=
", "hook": "forward", "prio": -211, "policy": "accept"}}, {"chain": {"famil=
y": "bridge", "table": "x", "name": "forwardfilterm10", "handle": 0, "type"=
: "filter", "hook": "forward", "prio": -210, "policy": "accept"}}, {"chain"=
: {"family": "bridge", "table": "x", "name": "forwardfilter", "handle": 0, =
"type": "filter", "hook": "forward", "prio": -200, "policy": "accept"}}, {"=
chain": {"family": "bridge", "table": "x", "name": "forwardfilterp10", "han=
dle": 0, "type": "filter", "hook": "forward", "prio": -190, "policy": "acce=
pt"}}, {"chain": {"family": "bridge", "table": "x", "name": "forwardfilterp=
11", "handle": 0, "type": "filter", "hook": "forward", "prio": -189, "polic=
y": "accept"}}, {"chain": {"family": "bridge", "table": "x", "name": "outpu=
tfilterm11", "handle": 0, "type": "filter", "hook": "output", "prio": -211,=
 "policy": "accept"}}, {"chain": {"family": "bridge", "table": "x", "name":=
 "outputfilterm10", "handle": 0, "type": "filter", "hook": "output", "prio"=
: -210, "policy": "accept"}}, {"chain": {"family": "bridge", "table": "x", =
"name": "outputfilter", "handle": 0, "type": "filter", "hook": "output", "p=
rio": -200, "policy": "accept"}}, {"chain": {"family": "bridge", "table": "=
x", "name": "outputfilterp10", "handle": 0, "type": "filter", "hook": "outp=
ut", "prio": -190, "policy": "accept"}}, {"chain": {"family": "bridge", "ta=
ble": "x", "name": "outputfilterp11", "handle": 0, "type": "filter", "hook"=
: "output", "prio": -189, "policy": "accept"}}, {"chain": {"family": "bridg=
e", "table": "x", "name": "postroutingfilterm11", "handle": 0, "type": "fil=
ter", "hook": "postrouting", "prio": -211, "policy": "accept"}}, {"chain": =
{"family": "bridge", "table": "x", "name": "postroutingfilterm10", "handle"=
: 0, "type": "filter", "hook": "postrouting", "prio": -210, "policy": "acce=
pt"}}, {"chain": {"family": "bridge", "table": "x", "name": "postroutingfil=
ter", "handle": 0, "type": "filter", "hook": "postrouting", "prio": -200, "=
policy": "accept"}}, {"chain": {"family": "bridge", "table": "x", "name": "=
postroutingfilterp10", "handle": 0, "type": "filter", "hook": "postrouting"=
, "prio": -190, "policy": "accept"}}, {"chain": {"family": "bridge", "table=
": "x", "name": "postroutingfilterp11", "handle": 0, "type": "filter", "hoo=
k": "postrouting", "prio": -189, "policy": "accept"}}, {"chain": {"family":=
 "bridge", "table": "x", "name": "preroutingdstnatm11", "handle": 0, "type"=
: "filter", "hook": "prerouting", "prio": -311, "policy": "accept"}}, {"cha=
in": {"family": "bridge", "table": "x", "name": "preroutingdstnatm10", "han=
dle": 0, "type": "filter", "hook": "prerouting", "prio": -310, "policy": "a=
ccept"}}, {"chain": {"family": "bridge", "table": "x", "name": "preroutingd=
stnat", "handle": 0, "type": "filter", "hook": "prerouting", "prio": -300, =
"policy": "accept"}}, {"chain": {"family": "bridge", "table": "x", "name": =
"preroutingdstnatp10", "handle": 0, "type": "filter", "hook": "prerouting",=
 "prio": -290, "policy": "accept"}}, {"chain": {"family": "bridge", "table"=
: "x", "name": "preroutingdstnatp11", "handle": 0, "type": "filter", "hook"=
: "prerouting", "prio": -289, "policy": "accept"}}, {"chain": {"family": "b=
ridge", "table": "x", "name": "outputoutm11", "handle": 0, "type": "filter"=
, "hook": "output", "prio": 89, "policy": "accept"}}, {"chain": {"family": =
"bridge", "table": "x", "name": "outputoutm10", "handle": 0, "type": "filte=
r", "hook": "output", "prio": 90, "policy": "accept"}}, {"chain": {"family"=
: "bridge", "table": "x", "name": "outputout", "handle": 0, "type": "filter=
", "hook": "output", "prio": 100, "policy": "accept"}}, {"chain": {"family"=
: "bridge", "table": "x", "name": "outputoutp10", "handle": 0, "type": "fil=
ter", "hook": "output", "prio": 110, "policy": "accept"}}, {"chain": {"fami=
ly": "bridge", "table": "x", "name": "outputoutp11", "handle": 0, "type": "=
filter", "hook": "output", "prio": 111, "policy": "accept"}}, {"chain": {"f=
amily": "bridge", "table": "x", "name": "postroutingsrcnatm11", "handle": 0=
, "type": "filter", "hook": "postrouting", "prio": 289, "policy": "accept"}=
}, {"chain": {"family": "bridge", "table": "x", "name": "postroutingsrcnatm=
10", "handle": 0, "type": "filter", "hook": "postrouting", "prio": 290, "po=
licy": "accept"}}, {"chain": {"family": "bridge", "table": "x", "name": "po=
stroutingsrcnat", "handle": 0, "type": "filter", "hook": "postrouting", "pr=
io": 300, "policy": "accept"}}, {"chain": {"family": "bridge", "table": "x"=
, "name": "postroutingsrcnatp10", "handle": 0, "type": "filter", "hook": "p=
ostrouting", "prio": 310, "policy": "accept"}}, {"chain": {"family": "bridg=
e", "table": "x", "name": "postroutingsrcnatp11", "handle": 0, "type": "fil=
ter", "hook": "postrouting", "prio": 311, "policy": "accept"}}]}
diff --git a/tests/shell/testcases/chains/dumps/0042chain_variable_0.json-n=
ft b/tests/shell/testcases/chains/dumps/0042chain_variable_0.json-nft
index 7f0134a0d258..e39f7ff7c2e8 100644
--- a/tests/shell/testcases/chains/dumps/0042chain_variable_0.json-nft
+++ b/tests/shell/testcases/chains/dumps/0042chain_variable_0.json-nft
@@ -1 +1 @@
-{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "netdev", "name": =
"filter1", "handle": 0}}, {"chain": {"family": "netdev", "table": "filter1"=
, "name": "Main_Ingress1", "handle": 0, "type": "filter", "hook": "ingress"=
, "prio": -500, "policy": "accept"}}, {"table": {"family": "netdev", "name"=
: "filter2", "handle": 0}}, {"chain": {"family": "netdev", "table": "filter=
2", "name": "Main_Ingress2", "handle": 0, "type": "filter", "hook": "ingres=
s", "prio": -500, "policy": "accept"}}, {"table": {"family": "netdev", "nam=
e": "filter3", "handle": 0}}, {"chain": {"family": "netdev", "table": "filt=
er3", "name": "Main_Ingress3", "handle": 0, "type": "filter", "hook": "ingr=
ess", "prio": -500, "policy": "accept"}}, {"chain": {"family": "netdev", "t=
able": "filter3", "name": "Main_Egress3", "handle": 0, "type": "filter", "h=
ook": "egress", "prio": -500, "policy": "accept"}}]}
+{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "netdev", "name": =
"filter1", "handle": 0}}, {"chain": {"family": "netdev", "table": "filter1"=
, "name": "Main_Ingress1", "handle": 0, "dev": "lo", "type": "filter", "hoo=
k": "ingress", "prio": -500, "policy": "accept"}}, {"table": {"family": "ne=
tdev", "name": "filter2", "handle": 0}}, {"chain": {"family": "netdev", "ta=
ble": "filter2", "name": "Main_Ingress2", "handle": 0, "dev": ["d2345678901=
2345", "lo"], "type": "filter", "hook": "ingress", "prio": -500, "policy": =
"accept"}}, {"table": {"family": "netdev", "name": "filter3", "handle": 0}}=
, {"chain": {"family": "netdev", "table": "filter3", "name": "Main_Ingress3=
", "handle": 0, "dev": ["d23456789012345", "lo"], "type": "filter", "hook":=
 "ingress", "prio": -500, "policy": "accept"}}, {"chain": {"family": "netde=
v", "table": "filter3", "name": "Main_Egress3", "handle": 0, "dev": "lo", "=
type": "filter", "hook": "egress", "prio": -500, "policy": "accept"}}]}
diff --git a/tests/shell/testcases/chains/dumps/0043chain_ingress_0.json-nf=
t b/tests/shell/testcases/chains/dumps/0043chain_ingress_0.json-nft
index 2e9b643371dd..77eb7237666d 100644
--- a/tests/shell/testcases/chains/dumps/0043chain_ingress_0.json-nft
+++ b/tests/shell/testcases/chains/dumps/0043chain_ingress_0.json-nft
@@ -1 +1 @@
-{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "inet", "name": "f=
ilter", "handle": 0}}, {"chain": {"family": "inet", "table": "filter", "nam=
e": "ingress", "handle": 0, "type": "filter", "hook": "ingress", "prio": 0,=
 "policy": "accept"}}, {"chain": {"family": "inet", "table": "filter", "nam=
e": "input", "handle": 0, "type": "filter", "hook": "input", "prio": 0, "po=
licy": "accept"}}, {"chain": {"family": "inet", "table": "filter", "name": =
"forward", "handle": 0, "type": "filter", "hook": "forward", "prio": 0, "po=
licy": "accept"}}]}
+{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "inet", "name": "f=
ilter", "handle": 0}}, {"chain": {"family": "inet", "table": "filter", "nam=
e": "ingress", "handle": 0, "dev": "lo", "type": "filter", "hook": "ingress=
", "prio": 0, "policy": "accept"}}, {"chain": {"family": "inet", "table": "=
filter", "name": "input", "handle": 0, "type": "filter", "hook": "input", "=
prio": 0, "policy": "accept"}}, {"chain": {"family": "inet", "table": "filt=
er", "name": "forward", "handle": 0, "type": "filter", "hook": "forward", "=
prio": 0, "policy": "accept"}}]}
--=20
2.30.2

