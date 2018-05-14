From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH 01/14] net: sched: use rcu for action cookie update
Date: Mon, 14 May 2018 17:10:56 +0200
Message-ID: <20180514151056.GA1848@nanopsycho>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
 <1526308035-12484-2-git-send-email-vladbu@mellanox.com>
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
In-Reply-To: <1526308035-12484-2-git-send-email-vladbu@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Mon, May 14, 2018 at 04:27:02PM CEST, vladbu@mellanox.com wrote:
>Implement functions to atomically update and free action cookie
>using rcu mechanism.
>
>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
