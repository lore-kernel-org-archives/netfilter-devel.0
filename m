From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] libnfnetlink, libnetfilter_log, libnetfilter_queue  error
 handling
Date: Mon, 12 Jun 2006 00:04:08 +0200
Message-ID: <448C9358.6070904@netfilter.org>
References: <44899B44.2030605@net.in.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gregor Maier <gregor@net.in.tum.de>
In-Reply-To: <44899B44.2030605@net.in.tum.de>
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

Gregor Maier wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hi,
> 
> 
> I noticed that libnfnetlink, libnetfilter_* are currently missing decent
> error handling and reporting mechanisms.
> 
> libnetfilter_log and libnetfilter_queue define a nflog_errno resp.
> nfq_errno but those aren't really used. libnfnetlink uses fprintf for
> error handling/reporting.
> 
> What do you think about the following suggestions:
> * add a nfnl_errno variable
> * add #defines for nfnl_errno values also add a nfnl_strerror and a
> nfnl_perror function
> * add #defines for nflog_errno and nfq_errno and nf{log|q}_strerror and
> nf{log|q}_perror functions.
> 
> * make nflog_errno and nfq_errno a superset of the nfnl_errnos. E.g. by
> defining that error values from 1...N are for nfnl and values above N
> are for nfq_errno and nflog_errno.
> * nflog_strerror (and nfq_strerror) check if nflog_errno (resp.
> nfq_errno) is <= N. If so, they call nfnl_strerror otherwise they handle
> the error themselves.

All those seem a good idea, I have currently enqueued a set of patches 
for libnfnetlink and friends that I'll post in some days, still want to 
give them some spins. I think that we could integrate this changes that 
you propose.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
