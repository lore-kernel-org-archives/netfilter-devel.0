Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 782BEC43334
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jun 2022 22:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352857AbiFUW5A (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Jun 2022 18:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiFUW5A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Jun 2022 18:57:00 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F129231932
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jun 2022 15:56:57 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id e2so10458670edv.3
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jun 2022 15:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VJ9vuzeYYfC93pnPXVz/v64rwUxujCcqZgX33La398E=;
        b=Gzbqb+/QgXENsKOaTT9XTdx24zt8JoAYBV31P2/M7eUDFlf5zUoNZdph+w4EdWeQc4
         lYk5UvzE+M6vFT6Hgub5dcJS4lQmOBsVuleyXZQHu79J6uAlTSj3RYaLdz82I3xNwhLe
         H4xB3+7Yb5hU6xLF973zlZlfvAwW1VEhkZlVZwss0dyrvCuXOiB22EAdEvzr/Op8nZ8c
         hJ+Y+BBhnlUJgOCyedANXc8PDBweiuOev2OJIk9GO8uAeMAloLZSFy6DU+q/thfN2BIc
         AKFsztbnoqlJaE+eDzACNY0WSFDfoQPBvmtr6/x8V9z31YMWaCZ8/1Rtd5r2kbeSfXxh
         y6KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VJ9vuzeYYfC93pnPXVz/v64rwUxujCcqZgX33La398E=;
        b=DPue1KRxL9mHQrtEPQTMwjTTXADR4koW+RCelfOlSK1F3fL4vjp2VPysM5fmEXptz0
         rncefpXjLL5U1yO4ridzpDPatM5VrV4eu9lKKbncJuE6YsuLsyuM8//SfVwLiUa4zXYV
         hgqgJFJx+I74WnRWSk3ceK43GOKGmooy5nACifp3maBolyzunCoySlHmb8NYPVBt6P0s
         ZQmUoE5h8PZBoC9liiAUvi0t36C4dvR8N0m+q1v5zlkjXeCxL3xIkDzIu+FOwTzBY5gy
         lw2ZRrGJPPfRCz+hIED4/93Qd2r2OBKLi63kUdJmDHQw2MRnB+XH1kAmEXU1aCYiamEy
         runQ==
X-Gm-Message-State: AJIora+KU39pXIYEVE84j2oE5Xq7U++xKXVdX6RpOPJ7l5Q0g3MPdNxY
        BxRRmrOx9UtZyLnd0Maf9ma+UCt7VNsCmA==
X-Google-Smtp-Source: AGRyM1vex0TPrsxR0Esj/amprgcAFdpACNJ/+ewp+gMiR4t1mnez6+PIRO0RbTQFO5p3HmKdRiOoCA==
X-Received: by 2002:a05:6402:369b:b0:431:665e:f91a with SMTP id ej27-20020a056402369b00b00431665ef91amr542005edb.350.1655852216037;
        Tue, 21 Jun 2022 15:56:56 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf48a.dynamic.kabel-deutschland.de. [95.91.244.138])
        by smtp.gmail.com with ESMTPSA id z12-20020a50e68c000000b004358c3bfb4csm4540118edm.31.2022.06.21.15.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 15:56:55 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH 1/3] conntrack: introduce new -A command
Date:   Wed, 22 Jun 2022 00:55:45 +0200
Message-Id: <20220621225547.69349-2-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220621225547.69349-1-mikhail.sennikovskii@ionos.com>
References: <20220621225547.69349-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The -A command works exactly the same way as -I except that it
does not fail if the ct entry already exists.
This command is useful for the batched ct loads to not abort if
some entries being applied exist.

The ct entry dump in the "save" format is now switched to use the
-A command as well for the generated output.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 src/conntrack.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 500e736..465a4f9 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -115,6 +115,7 @@ struct ct_cmd {
 	unsigned int	cmd;
 	unsigned int	type;
 	unsigned int	event_mask;
+	unsigned int 	cmd_options;
 	int		options;
 	int		family;
 	int		protonum;
@@ -215,6 +216,11 @@ enum ct_command {
 };
 /* If you add a new command, you have to update NUMBER_OF_CMD in conntrack.h */
 
+enum ct_command_options {
+	CT_CMD_OPT_IGNORE_ALREADY_DONE_BIT = 0,
+	CT_CMD_OPT_IGNORE_ALREADY_DONE     = (1 << CT_CMD_OPT_IGNORE_ALREADY_DONE_BIT),
+};
+
 enum ct_options {
 	CT_OPT_ORIG_SRC_BIT	= 0,
 	CT_OPT_ORIG_SRC 	= (1 << CT_OPT_ORIG_SRC_BIT),
@@ -396,7 +402,7 @@ static struct option original_opts[] = {
 	{0, 0, 0, 0}
 };
 
-static const char *getopt_str = ":L::I::U::D::G::E::F::hVs:d:r:q:"
+static const char *getopt_str = ":L::I::U::D::G::E::F::A::hVs:d:r:q:"
 				"p:t:u:e:a:z[:]:{:}:m:i:f:o:n::"
 				"g::c:b:C::Sj::w:l:<:>::(:):";
 
@@ -805,7 +811,7 @@ static int ct_save_snprintf(char *buf, size_t len,
 
 	switch (type) {
 	case NFCT_T_NEW:
-		ret = snprintf(buf + offset, len, "-I ");
+		ret = snprintf(buf + offset, len, "-A ");
 		BUFFER_SIZE(ret, size, len, offset);
 		break;
 	case NFCT_T_UPDATE:
@@ -2918,7 +2924,10 @@ static int print_stats(const struct ct_cmd *cmd)
 	if (cmd->command && exit_msg[cmd->cmd][0]) {
 		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
 		fprintf(stderr, exit_msg[cmd->cmd], counter);
-		if (counter == 0 && !(cmd->command & (CT_LIST | EXP_LIST)))
+		if (counter == 0 &&
+		    !((cmd->command & (CT_LIST | EXP_LIST))
+		       || (cmd->command == CT_CREATE
+		           && (cmd->cmd_options & CT_CMD_OPT_IGNORE_ALREADY_DONE))))
 			return -1;
 	}
 
@@ -2931,6 +2940,7 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 	int protonum = 0, family = AF_UNSPEC;
 	size_t socketbuffersize = 0;
 	unsigned int command = 0;
+	unsigned int cmd_options = 0;
 	unsigned int options = 0;
 	struct ct_tmpl *tmpl;
 	int res = 0, partial;
@@ -2981,17 +2991,23 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 			add_command(&command, cmd2type[c][type]);
 			break;
 		case 'U':
+		case 'A':
 			type = check_type(argc, argv);
 			if (type == CT_TABLE_DYING ||
 			    type == CT_TABLE_UNCONFIRMED) {
 				exit_error(PARAMETER_PROBLEM,
 					   "Can't do that command with "
 					   "tables `dying' and `unconfirmed'");
-			} else if (type == CT_TABLE_CONNTRACK)
-				add_command(&command, CT_UPDATE);
-			else
+			} else if (type == CT_TABLE_CONNTRACK) {
+				if (c == 'A') {
+					add_command(&command, CT_CREATE);
+					cmd_options |= CT_CMD_OPT_IGNORE_ALREADY_DONE;
+				} else
+					add_command(&command, CT_UPDATE);
+			} else
 				exit_error(PARAMETER_PROBLEM,
-					   "Can't update expectations");
+					   "Can't %s expectations",
+					   c == 'U' ? "update" : "add to");
 			break;
 		/* options */
 		case 's':
@@ -3240,6 +3256,7 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 
 	ct_cmd->command = command;
 	ct_cmd->cmd = cmd;
+	ct_cmd->cmd_options = cmd_options;
 	ct_cmd->options = options;
 	ct_cmd->family = family;
 	ct_cmd->type = type;
@@ -3345,6 +3362,9 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd,
 				       NULL, cmd->tmpl.ct, NULL);
 		if (res >= 0)
 			counter++;
+		else if (errno == EEXIST
+			 && (cmd->cmd_options & CT_CMD_OPT_IGNORE_ALREADY_DONE))
+			res = 0;
 
 		break;
 
-- 
2.25.1

