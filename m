From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH 13/14] net: sched: use unique idr insert function in
 unlocked actions
Date: Sun, 20 May 2018 18:33:49 -0300
Message-ID: <20180520213349.GC26212@localhost.localdomain>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
 <1526308035-12484-14-git-send-email-vladbu@mellanox.com>
 <20180519222028.GF5488@localhost.localdomain>
 <CAJ3xEMhNC91YFcy-Qi+vk--DwSZ5wZdYMNp=-7mHUk9oag9HSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: Or Gerlitz <gerlitz.or@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMhNC91YFcy-Qi+vk--DwSZ5wZdYMNp=-7mHUk9oag9HSg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, May 21, 2018 at 12:13:06AM +0300, Or Gerlitz wrote:
> On Sun, May 20, 2018 at 1:20 AM, Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> > On Mon, May 14, 2018 at 05:27:14PM +0300, Vlad Buslov wrote:
> >> Substitute calls to action insert function with calls to action insert
> >> unique function that warns if insertion overwrites index in idr.
> >
> > I know this patch may be gone on V2, but a general comment, please use
> > the function names themselves instead of a textualized version. I.e.,
> > s/action insert unique/tcf_idr_insert_unique/
>
> disagree. While doing reviews I found out that if I ask the developer
> to use higher
> level / descriptive language and specifically to avoid putting
> variable / function names in
> patch titles and change logs, the quality gets ++ big time, vs if the
> developer is allowed to say
>
> net/mlx5: Changed add_vovo_bobo()
>
> Added variable do_it_right to add_vovo_bobo(), now we are terribly good.

In your example I agree that it is not helping and it is even allowing
such empty changelog, just as in the section I highlighted, the
descriptive language is also not helping IMHO.

I had to read it 3 times to make sure I wasn't missing a modifier word
when comparing the two functions and well, it's just saying
"Substitute calls to foo function to bar function". I don't see how
the textualized version helps in this case while, at least in this
one, I would have visually recognized the function names way faster.

Sounds like 2 bad examples for either approach.
