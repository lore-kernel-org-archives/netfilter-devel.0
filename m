From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v3 2/2] src: add import command
Date: Tue, 10 Mar 2015 19:57:08 +0100
Message-ID: <20150310185708.GA6322@salvia>
References: <1425981858-10687-1-git-send-email-alvaroneay@gmail.com>
 <20150310102107.GB27395@salvia>
 <54FF35AA.3030104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: =?iso-8859-1?Q?=C1lvaro?= Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46409 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbbCJSx3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Mar 2015 14:53:29 -0400
Content-Disposition: inline
In-Reply-To: <54FF35AA.3030104@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 10, 2015 at 07:19:22PM +0100, =C1lvaro Neira Ayuso wrote:
> El 10/03/15 a las 11:21, Pablo Neira Ayuso escribi=F3:
> >On Tue, Mar 10, 2015 at 11:04:18AM +0100, Alvaro Neira Ayuso wrote:
> >>diff --git a/src/rule.c b/src/rule.c
> >>index 8d76fd0..8c58a2b 100644
> >>--- a/src/rule.c
> >>+++ b/src/rule.c
> >>@@ -20,6 +20,7 @@
> >>  #include <rule.h>
> >>  #include <utils.h>
> >>  #include <netlink.h>
> >>+#include <mnl.h>
> >>
> >>  #include <libnftnl/common.h>
> >>  #include <libnftnl/ruleset.h>
> >>@@ -555,6 +556,21 @@ void export_free(struct export *e)
> >>  	xfree(e);
> >>  }
> >>
> >>+struct import *import_alloc(uint32_t format)
> >>+{
> >>+	struct import *import;
> >>+
> >>+	import =3D xmalloc(sizeof(struct import));
> >>+	import->format =3D format;
> >>+
> >>+	return import;
> >>+}
> >>+
> >>+void import_free(struct import *i)
> >>+{
> >>+	xfree(i);
> >>+}
> >>+
> >>  struct monitor *monitor_alloc(uint32_t format, uint32_t type, con=
st char *event)
> >>  {
> >>  	struct monitor *mon;
> >>@@ -599,6 +615,9 @@ void cmd_free(struct cmd *cmd)
> >>  		case CMD_OBJ_MONITOR:
> >>  			monitor_free(cmd->monitor);
> >>  			break;
> >>+		case CMD_OBJ_IMPORT:
> >>+			import_free(cmd->import);
> >>+			break;
> >>  		case CMD_OBJ_EXPORT:
> >>  			export_free(cmd->export);
> >>  			break;
> >>@@ -1006,6 +1025,322 @@ static int do_command_describe(struct netli=
nk_ctx *ctx, struct cmd *cmd)
> >>  	return 0;
> >>  }
> >>
> >>+struct ruleset_parse {
> >>+	struct netlink_ctx *nl_ctx;
> >>+	struct cmd *cmd;
> >>+};
> >>+
> >>+static int ruleset_parse_setelems(const struct nft_parse_ctx *ctx)
> >>+{
> >>+	const struct ruleset_parse *rp;
> >>+	struct nft_set *set;
> >>+	uint32_t cmd;
> >>+	int ret =3D -1;
> >>+
> >>+	set =3D nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_SET);
> >>+	rp =3D nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_DATA);
> >>+
> >>+	cmd =3D nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_CMD);
> >>+	switch (cmd) {
> >>+	case NFT_CMD_ADD:
> >>+		ret =3D mnl_nft_setelem_batch_add(set, 0, rp->nl_ctx->seqnum);
> >>+		break;
> >>+	case NFT_CMD_DELETE:
> >>+		ret =3D mnl_nft_setelem_batch_del(set, 0, rp->nl_ctx->seqnum);
> >>+		break;
> >>+	default:
> >>+		errno =3D EOPNOTSUPP;
> >>+		break;
> >>+	}
> >>+
> >>+	if (ret < 0)
> >>+		netlink_io_error(rp->nl_ctx, &rp->cmd->location,
> >>+				 "Could not import set_elems: %s",
> >>+				 strerror(errno));
> >
> >I think rp->cmd->location is unset, so this will crash. Could you
> >validate this by forcing an error to make sure it works?
>=20
> It's not unset. If we have an error, the location is in the import
> command. For example:
>=20
> Error: Could not import set_elems: Invalid argument
> import json
> ^^^^^^^^^^^

Good, thanks.

BTW, please don't use developer jargon in the error messages, you
better say "Could not import set elements" instead of "set_elems".
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
