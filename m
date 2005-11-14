From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [RFC PATCH] ctnetlink port to nf_conntrack take #1
Date: Mon, 14 Nov 2005 20:15:24 +0100
Message-ID: <4378E24C.7060307@eurodev.net>
References: <4377E89A.5030205@eurodev.net>
	<200511141622.jAEGMAXf015099@toshiba.co.jp>
	<20051114171015.GI4773@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051114171015.GI4773@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> On Tue, Nov 15, 2005 at 01:22:09AM +0900, Yasuyuki KOZAKAI wrote:
> 
> 
>>I think we can generalize layer 3 protocol handling more, by introducing
>>nfattr_to_tuple/tuple_to_nfattr to l3proto modules like proto.
> 
> I agree.

Fine with it. I expect to send a new patch before the weekend.

>>And it would be great if {ip,nf}_conntrack_netlink.c can be unified.
>>But currently I don't have good idea to do that in clear way, and without
>>extensibility limitation of nf_conntrack_netlink. I'll think about this more.
>>How do you think ?
> 
> I don't think it's really worth the effort.  we already have two
> instances of connection tracking code.  
> 
> ip_conntrack will go sooner or later, so we should rather spend time on
> important features such as userspace conntrack helpers and NAT for
> nf_conntrack

Same feeling.

-- 
Pablo
