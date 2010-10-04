From: Nicolas Kaiser <nikai@nikai.net>
Subject: [PATCH] netfilter: remove duplicated include
Date: Mon, 4 Oct 2010 16:22:16 +0200
Message-ID: <20101004162216.6d2c26c5@absol.kitzblitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Hannes Eder <heder@google.com>, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Remove duplicated include.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 net/netfilter/xt_ipvs.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_ipvs.c b/net/netfilter/xt_ipvs.c
index 7a4d66d..9127a3d 100644
--- a/net/netfilter/xt_ipvs.c
+++ b/net/netfilter/xt_ipvs.c
@@ -16,7 +16,6 @@
 #include <linux/ip_vs.h>
 #include <linux/types.h>
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_ipvs.h>
 #include <net/netfilter/nf_conntrack.h>
 
-- 
1.7.2.2
