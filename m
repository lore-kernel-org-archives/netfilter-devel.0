From: mathieu.poirier@linaro.org
Subject: [PATCH] nfacct: remove unecessary end of line check
Date: Tue,  6 May 2014 11:48:31 -0600
Message-ID: <1399398511-15854-1-git-send-email-mathieu.poirier@linaro.org>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	john.stultz@linaro.org, mathieu.poirier@linaro.org
To: pablo@netfilter.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

The EOF character alone should determine the end of input during
restore operations.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 src/nfacct.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/src/nfacct.c b/src/nfacct.c
index e1c405e..091a5c9 100644
--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -581,10 +581,6 @@ static int nfacct_cmd_restore(int argc, char *argv[])
 			return -1;
 		}
 
-		/* a single ';' terminates the input */
-		if (strncmp(buffer, ";", 1) == 0)
-			break;
-
 		*semicolon = 0;
 		ret = flags = 0;
 		quota = 0;
-- 
1.9.1

