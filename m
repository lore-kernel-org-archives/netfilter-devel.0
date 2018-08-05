From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/21] netfilter: nf_osf: move nf_osf_fingers to non-uapi header file
Date: Sun,  5 Aug 2018 23:21:29 +0200
Message-ID: <20180805212141.3033-10-pablo@netfilter.org>
References: <20180805212141.3033-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180805212141.3033-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

All warnings (new ones prefixed by >>):

>> ./usr/include/linux/netfilter/nf_osf.h:73: userspace cannot reference function or variable defined in the kernel

Fixes: f9324952088f ("netfilter: nfnetlink_osf: extract nfnetlink_subsystem code from xt_osf.c")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_osf.h      | 2 ++
 include/uapi/linux/netfilter/nf_osf.h | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nf_osf.h b/include/linux/netfilter/nf_osf.h
index aee460fcbd31..3e455d6f94d5 100644
--- a/include/linux/netfilter/nf_osf.h
+++ b/include/linux/netfilter/nf_osf.h
@@ -25,6 +25,8 @@ enum osf_fmatch_states {
 	FMATCH_OPT_WRONG,
 };
 
+extern struct list_head nf_osf_fingers[2];
+
 struct nf_osf_finger {
 	struct rcu_head			rcu_head;
 	struct list_head		finger_entry;
diff --git a/include/uapi/linux/netfilter/nf_osf.h b/include/uapi/linux/netfilter/nf_osf.h
index cc2487ff74f6..3b93fbb9fc24 100644
--- a/include/uapi/linux/netfilter/nf_osf.h
+++ b/include/uapi/linux/netfilter/nf_osf.h
@@ -70,8 +70,6 @@ struct nf_osf_nlmsg {
 	struct tcphdr			tcp;
 };
 
-extern struct list_head nf_osf_fingers[2];
-
 /* Defines for IANA option kinds */
 enum iana_options {
 	OSFOPT_EOL = 0,		/* End of options */
-- 
2.11.0
