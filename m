From: Matt Walters <mattw@parasun.com>
Subject: Re: libipq scaling
Date: Thu, 05 Aug 2004 13:08:03 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1091736483.32021.106.camel@marx.mindlink.net>
References: <1091658643.32021.91.camel@marx.mindlink.net>
	 <4111D449.8080806@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4111D449.8080806@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2004-08-04 at 23:31, Pablo Neira wrote:
> Hi Matt,
> 
> Matt Walters wrote:
> 
> >	We're considering using netfilter to do some packet filtering/tagging
> >based on external information, and it seems like libipq is the best way
> >to do it.  I'm wondering if there are any issues with using this tool in
> >an environment where sustained 30Mbit/s throughput is to be expected. 
> >The target platform is a dual Xeon 2.8 with gobs of memory, 2.6.7
> >kernel.
> 
> I think that it will work fine with 30 Mbit/s.
> 
> >	Has anyone experimented with it?
> 
> I don't think so AFAIK. I've been benchmarking netlink sockets which is 
> the method used but libipq to pass information from/to user space.

	Is this information available?  I'd love to have a look at it.

> >  If not, when we do some performance testing, is anyone interested in the results?
> >  
> >
> I didn't test libipq performance, but I suppose that it won't work for 
> gigabit networks because of netlink sockets limitations. If you do those 
> performance testings, please post the results to the mailling list.

	Hmm.  What are the netlink sockets' limitations?  Will they explode at
155Mbps?  500Mbps?  Do we know?  Does their performance scale with
processor speed / memory bandwidth?

> To do the testing, I propose you to set three boxes, a client and a 
> server with iperf and a box between both of them with libipq enqueuing 
> all the packets for a 100Mbit/s network.

	Yes, we'd planned something like that - three machines, four 1Gbps
Ethernet interfaces ( [x]<-->[y]<-->[z] ) with [y] forwarding between
the other two, passing everything through userspace.

	I'm thinking that ipq is a great way to prove the concept we're toying
with, but that in order to scale to very large throughput we'll want to
have the work done by a kernel module.

	Thanks for your input,

-Matt
