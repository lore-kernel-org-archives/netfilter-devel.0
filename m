From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH 06/14] net: sched: implement reference counted action
 release
Date: Mon, 14 May 2018 18:47:53 +0200
Message-ID: <20180514164753.GF2134@nanopsycho.orion>
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

[...]


>+static int tcf_action_del_1(struct net *net, char *kind, u32 index,
>+			    struct netlink_ext_ack *extack)
>+{
>+	const struct tc_action_ops *ops;
>+	int err = -EINVAL;
>+
>+	ops = tc_lookup_action_n(kind);
>+	if (!ops) {

How this can happen? Apparently you hold reference to the module since
you put it couple lines below. In that case, I don't really understand
why you need to lookup and just don't use "ops" pointer you have in
tcf_action_delete().


>+		NL_SET_ERR_MSG(extack, "Specified TC action not found");
>+		goto err_out;
>+	}
>+
>+	if (ops->delete)
>+		err = ops->delete(net, index);
>+
>+	module_put(ops->owner);
>+err_out:
>+	return err;
>+}
>+
> static int tca_action_flush(struct net *net, struct nlattr *nla,
> 			    struct nlmsghdr *n, u32 portid,
> 			    struct netlink_ext_ack *extack)
>@@ -1052,6 +1088,36 @@ static int tca_action_flush(struct net *net, struct nlattr *nla,
> 	return err;
> }
> 
>+static int tcf_action_delete(struct net *net, struct list_head *actions,
>+			     struct netlink_ext_ack *extack)
>+{
>+	int ret;
>+	struct tc_action *a, *tmp;
>+	char kind[IFNAMSIZ];
>+	u32 act_index;
>+
>+	list_for_each_entry_safe(a, tmp, actions, list) {
>+		const struct tc_action_ops *ops = a->ops;
>+
>+		/* Actions can be deleted concurrently
>+		 * so we must save their type and id to search again
>+		 * after reference is released.
>+		 */
>+		strncpy(kind, a->ops->kind, sizeof(kind) - 1);
>+		act_index = a->tcfa_index;
>+
>+		list_del(&a->list);
>+		if (tcf_action_put(a))
>+			module_put(ops->owner);
>+
>+		/* now do the delete */
>+		ret = tcf_action_del_1(net, kind, act_index, extack);
>+		if (ret < 0)
>+			return ret;
>+	}
>+	return 0;
>+}
>+

[...]
