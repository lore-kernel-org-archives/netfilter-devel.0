From: Patrick McHardy <kaber@trash.net>
Subject: Re: libnetfilter_queue and libnetfilter_log
Date: Fri, 15 Dec 2006 11:00:13 +0100
Message-ID: <4582722D.8010304@trash.net>
References: <1166116491.3905.14.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, FireFlier <fireflier@gibraltar.at>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin MAURER <martinmaurer@gmx.at>
In-Reply-To: <1166116491.3905.14.camel@localhost>
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

Martin MAURER wrote:
> Hi,
> 
> In one of my software projects (fireflier - interactive firewall) I have
> been using QUEUE and ULOG for quite a while now. 
> When I recently decided to spend more work on fireflier again, I
> remembered that those two systems are deprecated meanwhile. Looking at
> the subversion archives I realized, that there is quite little
> development going on there for the new ones (at least for NFQUEUE, which
> I concentrated on so far).
> So before spending too much time on switching to those libs I first
> wanted to ask, if it comes still true, that those are the ones to use
> for now. (Or should I switch later and encourage users to use ULOG and
> QUEUE for now?)
> 
> During my experiments I realized, that there seems to be a problem in
> libipq_compat.c(ipq_read). This function never returns positive for me
> (which the former implementation did on new packets. 
> I guess it might have to do something with ipq_netlink_recvfrom being
> commented out?

Yes, it was never finished and it pretty useless currently.
nfnetlink_log and nfnetlink_queue are the future and provide
a few benefits over the old implementation (easily extendable,
multiple queue instances, address family agnostic). The downside
is that if your application should also run on old kernels you
need to support both implementations (compatibility in the
other direction would be more useful IMO, so you could use the
nfnetlink_queue API with both the old and new implementation).
