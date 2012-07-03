From: AFT <aftnix@gmail.com>
Subject: Re: What happened to xt_match_param
Date: Tue, 03 Jul 2012 21:03:47 +0600
Message-ID: <fw98ga3w.fsf@s1.test.com>
References: <mx3hez3o.fsf@s1.test.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41335 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab2GCPNy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jul 2012 11:13:54 -0400
Received: by yhmm54 with SMTP id m54so6170681yhm.19
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Jul 2012 08:13:54 -0700 (PDT)
In-Reply-To: <mx3hez3o.fsf@s1.test.com> (AFT's message of "Tue, 03 Jul 2012
	19:46:51 +0600")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

AFT <aftnix@gmail.com> writes:

> Hi,
>
> In "writing netfilter module", by JAN, there is a inconsistancy in
> section 2.5 named "Point of decision".
>
> Here a match function is prototyped as ,
>
> struct bool ipaddr_mt(const struct sk_buff *skb,
>                       struct xt_match_param *par);
>                       
> Now there is no xt_match_param in netfilter.h. The closest thing is
> 'struct xt_mtchk_param'. which is defined as,
>
> struct xt_mtchk_param {
> 	struct net *net;
> 	const char *table;
> 	const void *entryinfo;
> 	const struct xt_match *match;
> 	void *matchinfo;
> 	unsigned int hook_mask;
> 	u_int8_t family;
> };
>
> So at first i thought i can just replace it with xt_mtchk_param. But the
> problem is the text reads following lines which can not be right if i
> replace xt_match_param with xt_mtchk_param.
>
> par->in and par->out supposed to point to IN or OUT network devices. but
> as you can see there is no such fields in xt_mtchk_param.
>
> These struct net_device *in,out fields are inside struct
> xt_action_param.
>
> struct xt_action_param{
>        ...........
>        struct net_device *in,*out;
>        ...........
> }
>
> After subsequent reading i understood, it should be struct
> xt_action_param in the match function's prototype. so the correct
> prototype should be,
>
> static bool ipaddr_mt(const struct sk_buff *skb,
>                       struct xt_action_param *par);
>
> So it should be updated so that noobs like me does not get confused.
>
> cheers
> aft

another thing I forgot to mention, why there is a separate structure
struct xt_action_param and struct xt_mtchk_param? where most of the
fields appear to be identical?

struct xt_mtchk_param {
	struct net *net;
	const char *table;
	const void *entryinfo;
	const struct xt_match *match;
	void *matchinfo;
	unsigned int hook_mask;
	u_int8_t family;
};

and 

struct xt_action_param {
	union {
		const struct xt_match *match;
		const struct xt_target *target;
	};
	union {
		const void *matchinfo, *targinfo;
	};
	const struct net_device *in, *out;
	int fragoff;
	unsigned int thoff;
	unsigned int hooknum;
	u_int8_t family;
	bool hotdrop;
};

Although in comments, its mentioned that struct xt_action_param is for
match/target extensions where as struct xt_mtchk_param is for checkentry
functions. these explanations seems superficial to me, so there should
be better explanation. (one thing comes to my mind, that xt_action_param
contains a union for xt_match/xt_target. so checking entry it will not
be usable when this is initialized with xt_target rather than
xt_match. But this explanation also seems a mere technicality, which can
easily be overcome),

cheers
aft
