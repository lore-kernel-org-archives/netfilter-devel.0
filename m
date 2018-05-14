From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH 03/14] net: sched: add 'delete' function to action ops
Date: Mon, 14 May 2018 18:30:44 +0200
Message-ID: <20180514163044.GE2134@nanopsycho.orion>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
 <1526308035-12484-4-git-send-email-vladbu@mellanox.com>
 <20180514151222.GC1848@nanopsycho>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, ast@kernel.org,
        daniel@iogearbox.net, edumazet@google.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, kliteyn@mellanox.com
To: Vlad Buslov <vladbu@mellanox.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180514151222.GC1848@nanopsycho>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Mon, May 14, 2018 at 05:12:22PM CEST, jiri@resnulli.us wrote:
>Mon, May 14, 2018 at 04:27:04PM CEST, vladbu@mellanox.com wrote:
>>Extend action ops with 'delete' function. Each action type to implement its
>>own delete function that doesn't depend on rtnl lock.
>>
>>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
>>---
>> include/net/act_api.h | 1 +
>> 1 file changed, 1 insertion(+)
>>
>>diff --git a/include/net/act_api.h b/include/net/act_api.h
>>index e634014..73175a3 100644
>>--- a/include/net/act_api.h
>>+++ b/include/net/act_api.h
>>@@ -100,6 +100,7 @@ struct tc_action_ops {
>> 	void	(*stats_update)(struct tc_action *, u64, u32, u64);
>> 	size_t  (*get_fill_size)(const struct tc_action *act);
>> 	struct net_device *(*get_dev)(const struct tc_action *a);
>>+	int     (*delete)(struct net *net, u32 index);
>
>Probably better to squash this to patch 14.

Oh, I see you call it in patch 6. Fine.
