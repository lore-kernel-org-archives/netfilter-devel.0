From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] add TCP protocol state event groups
Date: Mon, 02 Jul 2007 17:36:05 +0200
Message-ID: <46891B65.7090407@trash.net>
References: <466D8EEB.9080601@netfilter.org> <4677DB3F.8010901@trash.net>
	<4688C826.4020404@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Holger Eitzenberger <heitzenberger@astaro.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4688C826.4020404@astaro.com>
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

Holger Eitzenberger wrote:
> Patrick McHardy wrote:
> 
>> I can see that this is useful, but one group per protocol state
>> sounds rather excessive, I would expect that we could group them
>> more logically, maybe "connection setup, teardown and updates"?
>> Which states is conntrackd particulary interested in?
> 
> 
>> I would also like to hear from Holger whether his conntrack daemon
>> could make use of a mechnism like this too and if the filtering
>> capabilities you propose will do.
> 
> 
> ctsyncd currently does quite some per-protocol filtering, e.g. TCP
> connections currently get synced only after being in the ESTABLISHED
> state and deleted on the slave side if the teardown event is received.
> This greatly reduces the number of events which are send to the ctsyncd
> peer.
> 
> Although ctsyncd does not have a performance problem at all even if I
> run it against our Spirent performance system I generally like the idea
> of doing some of the filtering in kernelspace.  Though I would leave the
> userspace filtering code as a fallback solution in place.


I agree that kernel space filtering is useful, I'm just not convinced
of this particular approach. I would much rather like to see something
that is not specific to nf_conntrack_netlink and can be specified per
socket, something like bpf for netlink.

> As of July I have a new colleague which hopefully takes over some of the
> workloads I currently have.  My plan therefore for ctsyncd is to finally
> improve filtering capability of ctsyncd and make if configurable, as
> currently most of the filtering code is still hardcoded.  My plan is
> also to improve the partnership with keepalived et all, basically making
> this part more configurable too.  This version will then be my 1.0
> release, as it currently runs fine for serveral months now on our ASG
> products.
> 
> So hopefully I am able to release ctsyncd 1.0 into the public within the
> next few weeks, especially with Netfilter Workshop in mind.


Great.
