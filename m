From: Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH 09/14] net: sched: don't release reference on action overwrite
Date: Sun, 20 May 2018 21:42:08 +0300
Message-ID: <vbfpo1q9njz.fsf@reg-r-vrt-018-180.mtr.labs.mlnx>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com> <1526308035-12484-10-git-send-email-vladbu@mellanox.com> <20180519215246.GD5488@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Cc: netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, ast@kernel.org,
        daniel@iogearbox.net, edumazet@google.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, kliteyn@mellanox.com
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20180519215246.GD5488@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat 19 May 2018 at 21:52, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> On Mon, May 14, 2018 at 05:27:10PM +0300, Vlad Buslov wrote:
>> Return from action init function with reference to action taken,
>> even when overwriting existing action.
>
> Isn't this patch necessary before patch 7, to not break things up?
> AFAICU after patchset 7 it assumes the action init function is already
> behaving like this.

I have re-split these patches for V2.
