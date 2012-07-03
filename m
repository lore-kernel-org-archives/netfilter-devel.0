From: AFT <aftnix@gmail.com>
Subject: What happened to xt_match_param
Date: Tue, 03 Jul 2012 19:46:51 +0600
Message-ID: <mx3hez3o.fsf@s1.test.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44944 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab2GCN44 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jul 2012 09:56:56 -0400
Received: by yenl2 with SMTP id l2so5279428yen.19
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Jul 2012 06:56:55 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Hi,

In "writing netfilter module", by JAN, there is a inconsistancy in
section 2.5 named "Point of decision".

Here a match function is prototyped as ,

struct bool ipaddr_mt(const struct sk_buff *skb,
                      struct xt_match_param *par);
                      
Now there is no xt_match_param in netfilter.h. The closest thing is
'struct xt_mtchk_param'. which is defined as,

struct xt_mtchk_param {
	struct net *net;
	const char *table;
	const void *entryinfo;
	const struct xt_match *match;
	void *matchinfo;
	unsigned int hook_mask;
	u_int8_t family;
};

So at first i thought i can just replace it with xt_mtchk_param. But the
problem is the text reads following lines which can not be right if i
replace xt_match_param with xt_mtchk_param.

par->in and par->out supposed to point to IN or OUT network devices. but
as you can see there is no such fields in xt_mtchk_param.

These struct net_device *in,out fields are inside struct
xt_action_param.

struct xt_action_param{
       ...........
       struct net_device *in,*out;
       ...........
}

After subsequent reading i understood, it should be struct
xt_action_param in the match function's prototype. so the correct
prototype should be,

static bool ipaddr_mt(const struct sk_buff *skb,
                      struct xt_action_param *par);

So it should be updated so that noobs like me does not get confused.

cheers
aft
