From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 3/4] check invalid esp spi range
Date: Fri, 07 Apr 2006 20:31:49 +0900 (JST)
Message-ID: <200604071131.k37BVoAs009386@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline; filename="03-esp.patch"
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[IPTABLES,IP6TABLES]: check invalid esp spi range

---
commit c2faea0a63833f5b8c65542c36a24ee1fb53207b
tree 3c49018aafea3725abbf6b1519bbc252b5374b7b
parent c94b52d4b6fff1bfc2da3e192b39e0f45cd12750
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 06 Apr 2006 20:21:50 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 06 Apr 2006 20:21:50 +0900

 extensions/libip6t_esp.c |    3 +++
 extensions/libipt_esp.c  |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/extensions/libip6t_esp.c b/extensions/libip6t_esp.c
index 29e865d..886e09b 100644
--- a/extensions/libip6t_esp.c
+++ b/extensions/libip6t_esp.c
@@ -61,6 +61,9 @@ parse_esp_spis(const char *spistring, u_
 
 		spis[0] = buffer[0] ? parse_esp_spi(buffer) : 0;
 		spis[1] = cp[0] ? parse_esp_spi(cp) : 0xFFFFFFFF;
+		if (spis[0] > spis[1])
+			exit_error(PARAMETER_PROBLEM,
+				   "Invalid ESP spi range: %s", spistring);
 	}
 	free(buffer);
 }
diff --git a/extensions/libipt_esp.c b/extensions/libipt_esp.c
index 4abfba3..21e912b 100644
--- a/extensions/libipt_esp.c
+++ b/extensions/libipt_esp.c
@@ -62,6 +62,9 @@ parse_esp_spis(const char *spistring, u_
 
 		spis[0] = buffer[0] ? parse_esp_spi(buffer) : 0;
 		spis[1] = cp[0] ? parse_esp_spi(cp) : 0xFFFFFFFF;
+		if (spis[0] > spis[1])
+			exit_error(PARAMETER_PROBLEM,
+				   "Invalid ESP spi range: %s", spistring);
 	}
 	free(buffer);
 }
