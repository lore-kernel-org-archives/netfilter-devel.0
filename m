From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH 04/14] net: sched: implement unlocked action init API
Date: Mon, 14 May 2018 17:16:41 +0200
Message-ID: <20180514151641.GD1848@nanopsycho>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
 <1526308035-12484-5-git-send-email-vladbu@mellanox.com>
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
In-Reply-To: <1526308035-12484-5-git-send-email-vladbu@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Mon, May 14, 2018 at 04:27:05PM CEST, vladbu@mellanox.com wrote:
>Add additional 'unlocked' argument to act API init functions.
>Argument is true when rtnl lock is not taken and false otherwise.
>It is required to implement actions that need to release rtnl lock before
>loading kernel module and reacquire if afterwards.
>
>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

[...]


>@@ -721,9 +722,11 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
> 	a_o = tc_lookup_action_n(act_name);
> 	if (a_o == NULL) {
> #ifdef CONFIG_MODULES
>-		rtnl_unlock();
>+		if (!unlocked)
>+			rtnl_unlock();
> 		request_module("act_%s", act_name);
>-		rtnl_lock();
>+		if (!unlocked)
>+			rtnl_lock();

Although I don't like this conditional locking scheme, I see no other
way to solve this :/ But I think would be better perhaps to rename
"unlocked" to something like "rtnl_held".

[...]
