From: Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH 06/14] net: sched: implement reference counted action release
Date: Tue, 15 May 2018 12:16:10 +0300
Message-ID: <vbfmux1mg85.fsf@reg-r-vrt-018-180.mtr.labs.mlnx>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com> <1526308035-12484-7-git-send-email-vladbu@mellanox.com> <20180514164753.GF2134@nanopsycho.orion> <vbfsh6udpk5.fsf@reg-r-vrt-018-180.mtr.labs.mlnx> <20180515090357.GK2134@nanopsycho.orion>
Mime-Version: 1.0
Content-Type: text/plain
Cc: netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, ast@kernel.org,
        daniel@iogearbox.net, edumazet@google.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, kliteyn@mellanox.com
To: Jiri Pirko <jiri@resnulli.us>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20180515090357.GK2134@nanopsycho.orion>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Tue 15 May 2018 at 09:03, Jiri Pirko <jiri@resnulli.us> wrote:
> Mon, May 14, 2018 at 09:07:06PM CEST, vladbu@mellanox.com wrote:
>>
>>On Mon 14 May 2018 at 16:47, Jiri Pirko <jiri@resnulli.us> wrote:
>>> Mon, May 14, 2018 at 04:27:07PM CEST, vladbu@mellanox.com wrote:
>>>
>>> [...]
>>>
>>>
>>>>+static int tcf_action_del_1(struct net *net, char *kind, u32 index,
>>>>+			    struct netlink_ext_ack *extack)
>>>>+{
>>>>+	const struct tc_action_ops *ops;
>>>>+	int err = -EINVAL;
>>>>+
>>>>+	ops = tc_lookup_action_n(kind);
>>>>+	if (!ops) {
>>>
>>> How this can happen? Apparently you hold reference to the module since
>>> you put it couple lines below. In that case, I don't really understand
>>> why you need to lookup and just don't use "ops" pointer you have in
>>> tcf_action_delete().
>>
>>The problem is that I cant really delete action while holding reference
>
> Wait a sec. I was talking about a "module reference" (module_put())

I misunderstood your question. Yes, I guess I can just save return value
of tcf_action_put to variable, continue using ops pointer and only
call module_put after delete.

>
>
>>to it. I can try to decrement reference twice, however that might result
>>race condition if another task tries to delete that action at the same
>>time.
>>
>>Imagine situation:
>>1. Action is in actions idr, refcount==1
>>2. Task tries to delete action, takes reference while working with it,
>>refcount==2
>>3. Another task tries to delete same action, takes reference,
>>refcount==3
>>4. First task decrements refcount twice, refcount==1
>>5. At the same time second task decrements refcount twice, refcount==-1
>>
>>My solution is to save action index, but release the reference. Then try
>>to lookup action again and delete it if it is still in idr. (was not
>>concurrently deleted)
>>
>>Now same potential race condition with this patch:
>>1. Action is in actions idr, refcount==1
>>2. Task tries to delete action, takes reference while working with it,
>>refcount==2
>>3. Another task tries to delete same action, takes reference,
>>refcount==3
>>4. First task releases reference and deletes actions from idr, which
>>results another refcount decrement, refcount==1
>>5. At the same time second task releases reference to action,
>>refcount==0, action is deleted
>>6. When task tries to lookup-delete action from idr by index, action is
>>not found. This case is handled correctly by code and no negative
>>overflow of refcount happens.
>>
>>>
>>>
>>>>+		NL_SET_ERR_MSG(extack, "Specified TC action not found");
>>>>+		goto err_out;
>>>>+	}
>>>>+
>>>>+	if (ops->delete)
>>>>+		err = ops->delete(net, index);
>>>>+
>>>>+	module_put(ops->owner);
>>>>+err_out:
>>>>+	return err;
>>>>+}
>>>>+
>>>> static int tca_action_flush(struct net *net, struct nlattr *nla,
>>>> 			    struct nlmsghdr *n, u32 portid,
>>>> 			    struct netlink_ext_ack *extack)
>>>>@@ -1052,6 +1088,36 @@ static int tca_action_flush(struct net *net, struct nlattr *nla,
>>>> 	return err;
>>>> }
>>>> 
>>>>+static int tcf_action_delete(struct net *net, struct list_head *actions,
>>>>+			     struct netlink_ext_ack *extack)
>>>>+{
>>>>+	int ret;
>>>>+	struct tc_action *a, *tmp;
>>>>+	char kind[IFNAMSIZ];
>>>>+	u32 act_index;
>>>>+
>>>>+	list_for_each_entry_safe(a, tmp, actions, list) {
>>>>+		const struct tc_action_ops *ops = a->ops;
>>>>+
>>>>+		/* Actions can be deleted concurrently
>>>>+		 * so we must save their type and id to search again
>>>>+		 * after reference is released.
>>>>+		 */
>>>>+		strncpy(kind, a->ops->kind, sizeof(kind) - 1);
>>>>+		act_index = a->tcfa_index;
>>>>+
>>>>+		list_del(&a->list);
>>>>+		if (tcf_action_put(a))
>>>>+			module_put(ops->owner);
>>>>+
>>>>+		/* now do the delete */
>>>>+		ret = tcf_action_del_1(net, kind, act_index, extack);
>>>>+		if (ret < 0)
>>>>+			return ret;
>>>>+	}
>>>>+	return 0;
>>>>+}
>>>>+
>>>
>>> [...]
>>
