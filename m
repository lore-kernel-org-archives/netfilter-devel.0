From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH V2] net: Allow xt_owner in any user namespace
Date: Mon, 13 Jun 2016 21:06:55 -0500
Message-ID: <87wplszfpc.fsf@x220.int.ebiederm.org>
References: <1465850579-23431-1-git-send-email-cernekee@chromium.org>
	<20160614000223.GC16798@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Kevin Cernekee <cernekee@chromium.org>, pablo@netfilter.org,
	kaber@trash.net, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out01.mta.xmission.com ([166.70.13.231]:42788 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423347AbcFNCSs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jun 2016 22:18:48 -0400
In-Reply-To: <20160614000223.GC16798@breakpoint.cc> (Florian Westphal's
	message of "Tue, 14 Jun 2016 02:02:23 +0200")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> writes:

> Kevin Cernekee <cernekee@chromium.org> wrote:
>> @@ -35,6 +63,7 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
>>  	const struct xt_owner_match_info *info = par->matchinfo;
>>  	const struct file *filp;
>>  	struct sock *sk = skb_to_full_sk(skb);
>> +	const struct net *net;
>>  
>>  	if (sk == NULL || sk->sk_socket == NULL)
>>  		return (info->match ^ info->invert) == 0;
>> @@ -50,9 +79,10 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
>>  		return ((info->match ^ info->invert) &
>>  		       (XT_OWNER_UID | XT_OWNER_GID)) == 0;
>>  
>> +	net = sock_net(skb->sk);
>
> I think you need to use sock_net(sk) as skb_to_full_sk(skb) can return something
> other than skb->sk.

Actually this should be "par->net".  That did not exist a few years ago
when the patch was written but it does now, and that should simplify
things a little bit, and remove any guess work or uncertainty.

Eric

