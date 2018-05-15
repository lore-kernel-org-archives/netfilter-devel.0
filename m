From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH] net: sched: __tcf_idr_check() can be static
Date: Tue, 15 May 2018 09:38:20 +0800
Message-ID: <20180515013820.GA78657@lkp-sbx04>
References: <1526308035-12484-6-git-send-email-vladbu@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, netdev@vger.kernel.org, davem@davemloft.net,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        ast@kernel.org, daniel@iogearbox.net, edumazet@google.com,
        vladbu@mellanox.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, kliteyn@mellanox.com
To: Vlad Buslov <vladbu@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1526308035-12484-6-git-send-email-vladbu@mellanox.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Fixes: 446adedb5339 ("net: sched: always take reference to action")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 act_api.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 9459cce..27e80cf 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -284,8 +284,8 @@ int tcf_generic_walker(struct tc_action_net *tn, struct sk_buff *skb,
 }
 EXPORT_SYMBOL(tcf_generic_walker);
 
-bool __tcf_idr_check(struct tc_action_net *tn, u32 index, struct tc_action **a,
-		     int bind)
+static bool __tcf_idr_check(struct tc_action_net *tn, u32 index, struct tc_action **a,
+			    int bind)
 {
 	struct tcf_idrinfo *idrinfo = tn->idrinfo;
 	struct tc_action *p;
