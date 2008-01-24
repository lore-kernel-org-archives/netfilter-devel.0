From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/8] netfilter: more sparse warning fixes
Date: Thu, 24 Jan 2008 19:40:41 +0100
Message-ID: <4798DBA9.4050204@trash.net>
References: <20080124181536.446214111@vyatta.com> <20080124181628.238890645@vyatta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49825 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbYAXSkp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 13:40:45 -0500
In-Reply-To: <20080124181628.238890645@vyatta.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Stephen Hemminger wrote:

 > --- a/net/netfilter/nfnetlink_queue.c	2008-01-23 10:04:00.000000000 -0800
 > +++ b/net/netfilter/nfnetlink_queue.c	2008-01-23 10:04:43.000000000 -0800
 > @@ -360,7 +360,7 @@ nfqnl_build_packet_message(struct nfqnl_
 >
 > 	if (data_len) {
 >  		struct nlattr *nla;
 > -		int size = nla_attr_size(data_len);
 > +		size = nla_attr_size(data_len);
 >
 >  		if (skb_tailroom(skb) < nla_total_size(data_len)) {
 >  			printk(KERN_WARNING "nf_queue: no tailroom!\n");
 > @@ -845,6 +845,7 @@ static struct hlist_node *get_idx(struct
 >  }
 >
 >  static void *seq_start(struct seq_file *seq, loff_t *pos)
 > +	__acquires(instances_lock)
 >  {
 >  	spin_lock(&instances_lock);
 >  	return get_idx(seq, *pos);
 > @@ -857,6 +858,7 @@ static void *seq_next(struct seq_file *s
 >  }
 >
 >  static void seq_stop(struct seq_file *s, void *v)
 > +	__releases(instances_lock)
 >  {
 >  	spin_unlock(&instances_lock);
 >  }


I already have this part queued from Eric, but I've applied the
nfnetlink_log part. Thanks.
