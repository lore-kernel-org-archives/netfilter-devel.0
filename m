From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] TCP window tracking patch with nfsim testsuite
Date: Thu, 03 Mar 2005 13:50:34 +0100
Message-ID: <4227081A.40509@trash.net>
References: <Pine.LNX.4.58.0502212344350.1749@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0502212344350.1749@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:
> Hi,
> 
> The first attached patch addresses several problems in the current TCP
> connection tracking in the 2.6 tree. Some of the problems was reported,
> others was discovered by nfsim tests:
> 
> - tcp_sack function was not safe against nonlinear skbs
> - practically arbitrary RST segments (addresses, ports assumed to be
>   known) could cause connection teardown in conntrack (thanks to Tim
>   Burress for the bugreport and patch)
> - article on which the code was based falsely assumed that packets
>   must fit completely into the window: packets must at least overlap
>   (thanks to Phil Oester for the bugreport and patch)
> - state table slightly changed to handle ACK packets sent by server to
>   late resent SYNs
> - tracking reopening connections reworked
> - cosmetic change: when window tracking is ignored by setting
>   ip_conntrack_tcp_be_liberal to nonzero, it's ignored completely from
>   now on
> 
> I think, after review, the patch should be sent for kernel inclusion.

Unfortunately there are too many changes for me to give it some
good review, but I've been running it for some time now without
problems. I'm going to push it to Dave with my next batch of
patches.

Regards
Patrick
