From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 16/23] netfilter: ebtables: clean up initialization of buf
Date: Tue,  7 Nov 2017 01:52:06 +0100
Message-ID: <20171107005213.22618-17-pablo@netfilter.org>
References: <20171107005213.22618-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171107005213.22618-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

buf is initialized to buf_start and then set on the next statement
to buf_start + offsets[i].  Clean this up to just initialize buf
to buf_start + offsets[i] to clean up the clang build warning:
"Value stored to 'buf' during its initialization is never read"

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebtables.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 83951f978445..54c274dbf4f1 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -2111,9 +2111,8 @@ static int size_entry_mwt(struct ebt_entry *entry, const unsigned char *base,
 	for (i = 0, j = 1 ; j < 4 ; j++, i++) {
 		struct compat_ebt_entry_mwt *match32;
 		unsigned int size;
-		char *buf = buf_start;
+		char *buf = buf_start + offsets[i];
 
-		buf = buf_start + offsets[i];
 		if (offsets[i] > offsets[j])
 			return -EINVAL;
 
-- 
2.11.0
