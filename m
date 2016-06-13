From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH V2] net: Allow xt_owner in any user namespace
Date: Mon, 13 Jun 2016 17:09:05 -0500
Message-ID: <87h9cw2132.fsf@x220.int.ebiederm.org>
References: <1465850579-23431-1-git-send-email-cernekee@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out03.mta.xmission.com ([166.70.13.233]:36019 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161258AbcFMWVT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jun 2016 18:21:19 -0400
In-Reply-To: <1465850579-23431-1-git-send-email-cernekee@chromium.org> (Kevin
	Cernekee's message of "Mon, 13 Jun 2016 13:42:59 -0700")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Kevin Cernekee <cernekee@chromium.org> writes:

> From: "Eric W. Biederman" <ebiederm@xmission.com>
>
> Making this work is a little tricky as it really isn't kosher to
> change the xt_owner_match_info in a check function.
>
> Without changing xt_owner_match_info we need to know the user
> namespace the uids and gids are specified in.  In the common case
> net->user_ns == current_user_ns().  Verify net->user_ns ==
> current_user_ns() in owner_check so we can later assume it in
> owner_mt.
>
> In owner_check also verify that all of the uids and gids specified are
> in net->user_ns and that the expected min/max relationship exists
> between the uids and gids in xt_owner_match_info.
>
> In owner_mt get the network namespace from the outgoing socket, as this
> must be the same network namespace as the netfilter rules, and use that
> network namespace to find the user namespace the uids and gids in
> xt_match_owner_info are encoded in.  Then convert from their encoded
> from into the kernel internal format for uids and gids and perform the
> owner match.
>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
> ---
>
>
> Original post:
> https://lists.linuxfoundation.org/pipermail/containers/2014-May/034514.html
>
> V1->V2:
>
>  - Change (max <= min) check to (max < min), because it is legal for
> min == max.  I suspect this was the root cause of this error:
>
> https://lists.linuxfoundation.org/pipermail/containers/2014-June/034661.html
>
>  - Fix checkpatch warnings.
>
>
> This was tested on a system running Linux 3.14, then compile-tested on
> Linus' master branch.
>
> Similar to ping_group_range, this code does not try to detect
> noncontiguous UID/GID ranges.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Would it be worth including this changelog in with the text?

>
>
>  net/netfilter/xt_owner.c | 42 ++++++++++++++++++++++++++++++++++++------
>  1 file changed, 36 insertions(+), 6 deletions(-)
>
> diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
> index 1302b475abcb..e1c1f31ef1e9 100644
> --- a/net/netfilter/xt_owner.c
> +++ b/net/netfilter/xt_owner.c
> @@ -21,11 +21,39 @@
>  static int owner_check(const struct xt_mtchk_param *par)
>  {
>  	struct xt_owner_match_info *info = par->matchinfo;
> +	struct net *net = par->net;
>  
> -	/* For now only allow adding matches from the initial user namespace */
> +	/* Only allow the common case where the userns of the writer
> +	 * matches the userns of the network namespace.
> +	 */
>  	if ((info->match & (XT_OWNER_UID|XT_OWNER_GID)) &&
> -	    (current_user_ns() != &init_user_ns))
> +	    (current_user_ns() != net->user_ns))
>  		return -EINVAL;
> +
> +	/* Ensure the uids are valid */
> +	if (info->match & XT_OWNER_UID) {
> +		kuid_t uid_min = make_kuid(net->user_ns, info->uid_min);
> +		kuid_t uid_max = make_kuid(net->user_ns, info->uid_max);
> +
> +		if (!uid_valid(uid_min) || !uid_valid(uid_max) ||
> +		    (info->uid_max < info->uid_min) ||
> +		    uid_lt(uid_max, uid_min)) {
> +			return -EINVAL;
> +		}
> +	}
> +
> +	/* Ensure the gids are valid */
> +	if (info->match & XT_OWNER_GID) {
> +		kgid_t gid_min = make_kgid(net->user_ns, info->gid_min);
> +		kgid_t gid_max = make_kgid(net->user_ns, info->gid_max);
> +
> +		if (!gid_valid(gid_min) || !gid_valid(gid_max) ||
> +		    (info->gid_max < info->gid_min) ||
> +		    gid_lt(gid_max, gid_min)) {
> +			return -EINVAL;
> +		}
> +	}
> +
>  	return 0;
>  }
>  
> @@ -35,6 +63,7 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  	const struct xt_owner_match_info *info = par->matchinfo;
>  	const struct file *filp;
>  	struct sock *sk = skb_to_full_sk(skb);
> +	const struct net *net;
>  
>  	if (sk == NULL || sk->sk_socket == NULL)
>  		return (info->match ^ info->invert) == 0;
> @@ -50,9 +79,10 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  		return ((info->match ^ info->invert) &
>  		       (XT_OWNER_UID | XT_OWNER_GID)) == 0;
>  
> +	net = sock_net(skb->sk);
>  	if (info->match & XT_OWNER_UID) {
> -		kuid_t uid_min = make_kuid(&init_user_ns, info->uid_min);
> -		kuid_t uid_max = make_kuid(&init_user_ns, info->uid_max);
> +		kuid_t uid_min = make_kuid(net->user_ns, info->uid_min);
> +		kuid_t uid_max = make_kuid(net->user_ns, info->uid_max);
>  		if ((uid_gte(filp->f_cred->fsuid, uid_min) &&
>  		     uid_lte(filp->f_cred->fsuid, uid_max)) ^
>  		    !(info->invert & XT_OWNER_UID))
> @@ -60,8 +90,8 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  	}
>  
>  	if (info->match & XT_OWNER_GID) {
> -		kgid_t gid_min = make_kgid(&init_user_ns, info->gid_min);
> -		kgid_t gid_max = make_kgid(&init_user_ns, info->gid_max);
> +		kgid_t gid_min = make_kgid(net->user_ns, info->gid_min);
> +		kgid_t gid_max = make_kgid(net->user_ns, info->gid_max);
>  		if ((gid_gte(filp->f_cred->fsgid, gid_min) &&
>  		     gid_lte(filp->f_cred->fsgid, gid_max)) ^
>  		    !(info->invert & XT_OWNER_GID))
