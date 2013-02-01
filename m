From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [stable-3.7 00/14] netfilter stable fixes for 3.7
Date: Fri, 1 Feb 2013 13:34:36 +0100
Message-ID: <20130201123436.GA31102@kroah.com>
References: <1359401493-6196-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, davem@davemloft.net,
	netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1359401493-6196-1-git-send-email-pablo@netfilter.org>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jan 28, 2013 at 08:31:19PM +0100, pablo@netfilter.org wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> This patchset contain netfilter stable fixes for 3.7, original
> commits (in no particular order) are:
> 
> 0c36b48 netfilter: nfnetlink_log: fix mac address for 6in4 tunnels
> e035edd netfilter: nfnetlink_log: fix possible compilation issue due to missing include
> 665e205 netfilter: xt_recent: fix namespace destroy path
> 2727de7 netfilter: xt_recent: avoid high order page allocations
> 5b76c49 netfilter: x_tables: print correct hook names for ARP
> 4fe198e netfilter: ipset: Fix range bug in hash:ip,port,net

This patch didn't apply as a straight 'git cherrypick', so I didn't take
it.  You also didn't send it, so something is odd here.

> c6f4089 netfilter: ip[6]t_REJECT: fix wrong transport header pointer in TCP reset
> 32263dd netfilter: xt_hashlimit: fix namespace destroy path
> 0918184 netfilter: xt_hashlimit: fix race that results in duplicated entries
> 1310b95 netfilter: ctnetlink: fix leak in error path of ctnetlink_create_expect
> 97cf00e netfilter: nf_ct_reasm: fix conntrack reassembly expire code
> 10db906 netfilter: xt_CT: recover NOTRACK target support
> 757ae31 netfilter: fix missing dependencies for the NOTRACK target
> 1e47ee8 netfilter: nf_conntrack: fix BUG_ON while removing nf_conntrack with netns
> 
> Please, apply. Thanks!

In the future, please put the git commit ids in the patches you send, I
had to match them up by hand and put them into the patch.

I've only applied 13 patches, so I know I've messed something up, can
you take a look at what I've applied and let me know what I missed?

thanks,

greg k-h
