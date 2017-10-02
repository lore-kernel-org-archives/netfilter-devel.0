From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH 3/3] evaluate: make pointers in string arrays constant
Date: Mon,  2 Oct 2017 13:02:50 +0530
Message-ID: <9b81cec687c3082f5fd762ece696f1272945e0ad.1506928244.git.harshasharmaiitr@gmail.com>
References: <cover.1506928244.git.harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1506928244.git.harshasharmaiitr@gmail.com>
In-Reply-To: <cover.1506928244.git.harshasharmaiitr@gmail.com>
References: <cover.1506928244.git.harshasharmaiitr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

static const char * array should probably be static const char * const
array
as per linux-kernel coding style

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 src/evaluate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index b783054..f48801a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -33,7 +33,7 @@
 static struct output_ctx octx_debug_dummy;
 static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr);
 
-static const char *byteorder_names[] = {
+static const char * const byteorder_names[] = {
 	[BYTEORDER_INVALID]		= "invalid",
 	[BYTEORDER_HOST_ENDIAN]		= "host endian",
 	[BYTEORDER_BIG_ENDIAN]		= "big endian",
@@ -3350,7 +3350,7 @@ static int cmd_evaluate_export(struct eval_ctx *ctx, struct cmd *cmd)
 			    ctx->debug_mask & DEBUG_NETLINK);
 }
 
-static const char *cmd_op_name[] = {
+static const char * const cmd_op_name[] = {
 	[CMD_INVALID]	= "invalid",
 	[CMD_ADD]	= "add",
 	[CMD_REPLACE]	= "replace",
-- 
1.9.1
