From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [RFC PATCH] ctnetlink port to nf_conntrack take #1
Date: Tue, 15 Nov 2005 01:22:09 +0900 (JST)
Message-ID: <200511141622.jAEGMA79023465@toshiba.co.jp>
References: <4377E89A.5030205@eurodev.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@eurodev.net
In-Reply-To: <4377E89A.5030205@eurodev.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hi, Pablo, that's great news.

From: Pablo Neira <pablo@eurodev.net>
Date: Mon, 14 Nov 2005 02:30:02 +0100

> This is a RFC. Attached two patches, the first contains the required
> modifications for nf_conntrack in order to get nf_conntrack_netlink working.

I'll read this deeply on this weekend.

> The second patch is an incremental diff against ip_conntrack_netlink.c,
> my intention with this patch is making easy your review. It clearly
> shows the slighty modifications introduced to carry out the porting.
> 
> On the other hand, the whole C file (nf_netlink_conntrack.c) is
> available at http://people.netfilter.org/pablo/nf_conntrack_netlink.c

I think we can generalize layer 3 protocol handling more, by introducing
nfattr_to_tuple/tuple_to_nfattr to l3proto modules like proto.

And it would be great if {ip,nf}_conntrack_netlink.c can be unified.
But currently I don't have good idea to do that in clear way, and without
extensibility limitation of nf_conntrack_netlink. I'll think about this more.
How do you think ?

Regards,

-- Yasuyuki Kozakai
