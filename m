From: Xin Long <lucien.xin@gmail.com>
Subject: Re: [PATCH net] netfilter: unlock xt_table earlier in __do_replace
Date: Fri, 16 Feb 2018 12:25:56 +0100
Message-ID: <CADvbK_eTNMqT_-fwcvUi8JRT-XTtz_bWMtZssCH_cGd7GxhR1A@mail.gmail.com>
References: <61f106376f836829d8c283fb4c0cf11567c953bf.1518775496.git.lucien.xin@gmail.com>
 <20180216110245.GB31046@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180216110245.GB31046@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Feb 16, 2018 at 12:02 PM, Florian Westphal <fw@strlen.de> wrote:
> Xin Long <lucien.xin@gmail.com> wrote:
>> Now it's doing cleanup_entry for oldinfo under the xt_table lock,
>> but it's not really necessary. After the replacement job is done
>> in xt_replace_table, oldinfo is not used elsewhere any more, and
>> it can be freed without xt_table lock safely.
>
> Right.
>
>> The important thing is that rtnl_lock is called in some xt_target
>> destroy, which means rtnl_lock, a big lock is used in xt_table
>> lock, a smaller one. It usually could be the reason why a dead
>> lock may happen.
>
> In which cases do we aquire the xt table mutex from places that hold
> rtnl mutex?
Not really now.
But there was one, which though had been fixed in another way in:
https://patchwork.ozlabs.org/patch/870797/

I meant this kind of case (big lock used under small lock) have the
risk that may cause a dead lock.
Sorry for confusing.

>
>> Besides, all xt_target/match checkentry is called out of xt_table
>> lock. It's better also to move all cleanup_entry calling out of
>> xt_table lock, just as do_replace_finish does for ebtables.
>
> Agree but I don't see how this patch fixes a bug so I would prefer if
> this could simmer in nf-next first.
Sure. No bug fix, it's an improvement.
