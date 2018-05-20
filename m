From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH 06/14] net: sched: implement reference counted action
 release
Date: Sun, 20 May 2018 08:22:42 +0200
Message-ID: <20180520062242.GB2255@nanopsycho.orion>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
 <1526308035-12484-7-git-send-email-vladbu@mellanox.com>
 <20180519214327.GC5488@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vlad Buslov <vladbu@mellanox.com>, netdev@vger.kernel.org,
        davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        ast@kernel.org, daniel@iogearbox.net, edumazet@google.com,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kliteyn@mellanox.com
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180519214327.GC5488@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Sat, May 19, 2018 at 11:43:27PM CEST, marcelo.leitner@gmail.com wrote:
>On Mon, May 14, 2018 at 05:27:07PM +0300, Vlad Buslov wrote:
>...
>> @@ -1052,6 +1088,36 @@ static int tca_action_flush(struct net *net, struct nlattr *nla,
>>  	return err;
>>  }
>>
>> +static int tcf_action_delete(struct net *net, struct list_head *actions,
>> +			     struct netlink_ext_ack *extack)
>> +{
>> +	int ret;
>
>Reverse christmass tree.. this line should be the last in variable
>declarations.
>
>> +	struct tc_action *a, *tmp;
>> +	char kind[IFNAMSIZ];
>> +	u32 act_index;
>> +
>> +	list_for_each_entry_safe(a, tmp, actions, list) {
>> +		const struct tc_action_ops *ops = a->ops;
>> +
>> +		/* Actions can be deleted concurrently
>> +		 * so we must save their type and id to search again
>> +		 * after reference is released.
>> +		 */
>> +		strncpy(kind, a->ops->kind, sizeof(kind) - 1);
>
>This may be problematic. Why strncpy here?

This is not necessary if Vlad is going to hold module referece, ops
cannot disappear.


>
>a->ops->kind is also of size IFNAMSIZ. If a->ops->kind is actually
>IFNAMSIZ-1 long, kind here won't be NULL terminated, as kind is not
>initialized and strncpy won't add the NULL.
>
>> +		act_index = a->tcfa_index;
>> +
>> +		list_del(&a->list);
>> +		if (tcf_action_put(a))
>> +			module_put(ops->owner);
>> +
>> +		/* now do the delete */
>> +		ret = tcf_action_del_1(net, kind, act_index, extack);
>> +		if (ret < 0)
>> +			return ret;
>> +	}
>> +	return 0;
>> +}
