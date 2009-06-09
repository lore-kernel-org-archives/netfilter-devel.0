From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: conntrack: optional reliable conntrack
 event	delivery
Date: Wed, 10 Jun 2009 00:36:02 +0200
Message-ID: <4A2EE3D2.1090007@netfilter.org>
References: <20090604110307.6702.10147.stgit@Decadence> <20090604110841.6702.76228.stgit@Decadence> <4A292DB7.4000000@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34391 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbZFIWgM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Jun 2009 18:36:12 -0400
In-Reply-To: <4A292DB7.4000000@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

A couple of minor issues related to this patch.

Patrick McHardy wrote:
>> +    hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
> 
> Why is _rcu used? The lists are never used for a lookup.

There's no hlist_nulls_del() operation without rcu. I have a patch here
to add hlist_nulls_add_head() and hlist_nulls_del() although I guess
that you are going to tell me that you cannot apply that patch? So,
where to go?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
