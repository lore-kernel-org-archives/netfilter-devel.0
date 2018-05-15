From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH 07/14] net: sched: use reference counting action init
Date: Tue, 15 May 2018 13:24:04 +0200
Message-ID: <20180515112404.GL2134@nanopsycho.orion>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
 <1526308035-12484-8-git-send-email-vladbu@mellanox.com>
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
In-Reply-To: <1526308035-12484-8-git-send-email-vladbu@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Mon, May 14, 2018 at 04:27:08PM CEST, vladbu@mellanox.com wrote:
>Change action API to assume that action init function always takes
>reference to action, even when overwriting existing action. This is
>necessary because action API continues to use action pointer after init
>function is done. At this point action becomes accessible for concurrent
>modifications so user must always hold reference to it.
>
>Implement helper put list function to atomically release list of actions
>after action API init code is done using them.
>
>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
>---
> net/sched/act_api.c | 38 +++++++++++++++++---------------------
> 1 file changed, 17 insertions(+), 21 deletions(-)
>

[...]


>@@ -1196,8 +1190,7 @@ tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
> 		return ret;
> 	}
> err:
>-	if (event != RTM_GETACTION)

Howcome you do this for RTM_GETACTION now too? Where is the related "get"?


>-		tcf_action_destroy(&actions, 0);
>+	tcf_action_put_lst(&actions);
> 	return ret;
> }
> 

[...]
