From: Alexander Alemayhu <alexander@alemayhu.com>
Subject: [PATCH nft] mnl: continue monitor if errno is ESRCH
Date: Sun, 26 Feb 2017 17:30:58 +0100
Message-ID: <20170226163058.24754-1-alexander@alemayhu.com>
Cc: Alexander Alemayhu <alexander@alemayhu.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:36614 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752271AbdBZQb3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Feb 2017 11:31:29 -0500
Received: by mail-lf0-f43.google.com with SMTP id b80so24698807lfe.3
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Feb 2017 08:31:02 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Running the test cases in the shell directory while running nft monitor results
in nft exiting with '# ERROR: No such process'. The minimal steps where I could
reproduce is:

nft monitor # shell 1
run-tests.sh testcases/sets/0011add_many_elements_0 # shell 2

Signed-off-by: Alexander Alemayhu <alexander@alemayhu.com>
---

Not sure if this is considered a fix or desired behaviour, but I was not
expecting monitor to exit like this.

 src/mnl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/mnl.c b/src/mnl.c
index 295dd84a5840..a0066a28b44f 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1129,7 +1129,10 @@ int mnl_nft_event_listener(struct mnl_socket *nf_sock,
 				printf("# ERROR: We lost some netlink events!\n");
 				continue;
 			}
+
 			fprintf(stdout, "# ERROR: %s\n", strerror(errno));
+			if (errno == ESRCH)
+				continue;
 			break;
 		}
 		ret = mnl_cb_run(buf, ret, 0, 0, cb, cb_data);
-- 
2.9.3

