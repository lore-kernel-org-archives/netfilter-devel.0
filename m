From: Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH] selftests/netfilter: fix config fragment CONFIG_NF_TABLES_INET
Date: Tue, 29 Jan 2019 06:28:35 +0000
Message-ID: <20190129062835.31122-1-naresh.kamboju@linaro.org>
Cc: fw@strlen.de, pablo@netfilter.org, davem@davemloft.net,
        linux-kselftest@vger.kernel.org,
        Naresh Kamboju <naresh.kamboju@linaro.org>
To: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

In selftests the config fragment for netfilter was added as
NF_TABLES_INET=y and this patch correct it as CONFIG_NF_TABLES_INET=y

Signed-off-by: Naresh Kamboju <naresh.kamboju@linaro.org>
---
 tools/testing/selftests/netfilter/config | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/netfilter/config b/tools/testing/selftests/netfilter/config
index 1017313e41a8..59caa8f71cd8 100644
--- a/tools/testing/selftests/netfilter/config
+++ b/tools/testing/selftests/netfilter/config
@@ -1,2 +1,2 @@
 CONFIG_NET_NS=y
-NF_TABLES_INET=y
+CONFIG_NF_TABLES_INET=y
-- 
2.17.1
