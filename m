From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH 06/14] net: sched: implement reference counted action
 release
Date: Mon, 14 May 2018 18:28:39 +0200
Message-ID: <20180514162839.GD2134@nanopsycho.orion>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
 <1526308035-12484-7-git-send-email-vladbu@mellanox.com>
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
In-Reply-To: <1526308035-12484-7-git-send-email-vladbu@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Mon, May 14, 2018 at 04:27:07PM CEST, vladbu@mellanox.com wrote:
>Implement helper function to delete action using new action ops delete
>function implemented by each action for lockless execution.

Reading this sentense for 4 times. I still don't understand what you say :(

>
>Implement action put function that releases reference to action and frees

When you write "Implement action put function" it is cryptic. Just
say "Implement function __tcf_action_put()".


>it if necessary. Refactor action deletion code to use new put function and
>not to rely on rtnl lock. Remove rtnl lock assertions that are no longer
>needed.

[...]
