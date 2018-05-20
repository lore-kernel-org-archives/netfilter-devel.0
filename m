From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH 13/14] net: sched: use unique idr insert function in
 unlocked actions
Date: Mon, 21 May 2018 00:13:06 +0300
Message-ID: <CAJ3xEMhNC91YFcy-Qi+vk--DwSZ5wZdYMNp=-7mHUk9oag9HSg@mail.gmail.com>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
 <1526308035-12484-14-git-send-email-vladbu@mellanox.com> <20180519222028.GF5488@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Vlad Buslov <vladbu@mellanox.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        kadlec@blackhole.kfki.hu, Florian Westphal <fw@strlen.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, keescook@chromium.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Yevgeny Kliteynik <kliteyn@mellanox.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180519222028.GF5488@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, May 20, 2018 at 1:20 AM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> On Mon, May 14, 2018 at 05:27:14PM +0300, Vlad Buslov wrote:
>> Substitute calls to action insert function with calls to action insert
>> unique function that warns if insertion overwrites index in idr.
>
> I know this patch may be gone on V2, but a general comment, please use
> the function names themselves instead of a textualized version. I.e.,
> s/action insert unique/tcf_idr_insert_unique/

disagree. While doing reviews I found out that if I ask the developer
to use higher
level / descriptive language and specifically to avoid putting
variable / function names in
patch titles and change logs, the quality gets ++ big time, vs if the
developer is allowed to say

net/mlx5: Changed add_vovo_bobo()

Added variable do_it_right to add_vovo_bobo(), now we are terribly good.
