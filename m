From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 8/9] netfilter: conntrack: use a single hashtable
 for all namespaces
Date: Fri, 29 Apr 2016 17:04:50 +0200
Message-ID: <20160429150450.GR17538@breakpoint.cc>
References: <1461863628-23350-1-git-send-email-fw@strlen.de>
 <1461863628-23350-9-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461863628-23350-9-git-send-email-fw@strlen.de>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> We already include netns address in the hash and compare the netns pointers
> during lookup, so even if namespaces have overlapping addresses entries
> will be spread across the table.
> 
> Assuming 64k bucket size, this change saves 0.5 mbyte per namespace on a
> 64bit system.
> 
> NAT bysrc and expectation hash is still per namespace, those will
> changed too soon.
> 
> Future patch will also make conntrack object slab cache global again.
> 
> @@ -1527,7 +1528,6 @@ i_see_dead_people:
>  	}
>  
>  	list_for_each_entry(net, net_exit_list, exit_list) {
> -		nf_ct_free_hashtable(net->ct.hash, net->ct.htable_size);

Removing this is ok, but nf_ct_free_hashtable() must now be called in
nf_conntrack_cleanup_end().

I'll wait with v2 for a couple of days.
