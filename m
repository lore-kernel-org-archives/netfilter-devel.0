From: Phil Sutter <phil@nwl.cc>
Subject: [iptables PATCH 1/2] utils: nfnl_osf: Fix synopsis in help text
Date: Wed, 20 Sep 2017 18:54:08 +0200
Message-ID: <20170920165409.11456-2-phil@nwl.cc>
References: <20170920165409.11456-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:41434 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750973AbdITQyZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2017 12:54:25 -0400
In-Reply-To: <20170920165409.11456-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* -d is optional
* -h is not really a flag, just anything not recognized triggers the
  help output.
* That '<del rules>' bit is rather confusing than helpful.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 utils/nfnl_osf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/nfnl_osf.c b/utils/nfnl_osf.c
index 645ec648fcc63..720e3a38dbd36 100644
--- a/utils/nfnl_osf.c
+++ b/utils/nfnl_osf.c
@@ -438,7 +438,7 @@ int main(int argc, char *argv[])
 				break;
 			default:
 				fprintf(stderr,
-					"Usage: %s -f fingerprints -d <del rules> -h\n",
+					"Usage: %s -f fingerprints [-d]\n",
 					argv[0]);
 				return -1;
 		}
-- 
2.13.1

