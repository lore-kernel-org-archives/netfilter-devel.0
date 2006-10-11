From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Add TCPCONG target to patch-o-matic
Date: Wed, 11 Oct 2006 07:32:18 +0200
Message-ID: <452C81E2.1040206@trash.net>
References: <45235EDC.4080709@aarnet.edu.au>
	<4524118B.4020903@netfilter.org>	<4524BBB2.2000109@aarnet.edu.au>
	<452A66CA.70603@trash.net> <452B4512.4070705@aarnet.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Stephen Hemminger <shemminger@osdl.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Glen Turner <glen.turner@aarnet.edu.au>
In-Reply-To: <452B4512.4070705@aarnet.edu.au>
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

Glen Turner wrote:
> Patrick McHardy wrote:
> 
>> I don't think iptables is the right place to do this. It should
>> be controllable through routing IMO (which can already control
>> some aspects of congestion control).
> 
> 
> I too think the choice should usually be done through routing,
> with the route holding the preferred congestion control algorithm
> for traffic with that prefix. Whereas now the preferred algorithm
> is read from a global parameter.
> 
> But the algorithm for a particular connection should still be
> able to be changed through iptables.
> 
> Firstly, not every application can be easily altered to use
> setsockopt() to select a differing algorithm from the default.
> This is the argument used for the TCPMSS and similar targets.

The difference is that TCPMSS changes packet data (also for
forwarded packets) and doesn't fiddle around with sockets.

> As the range of congestion control algorithms grows sysadmins
> will want to choose differing algorithms for differing
> applications. For example, most algorithm's Ack strategies
> interact poorly with transactional and remote procedure call
> traffic, so choosing an algorithm which handles this well
> could make, say, NFS over TCP traffic run a lot faster.
>
> Secondly, I want to make it easy for kernel and protocol
> developers to run differing algorithms on differing port
> numbers to test inter-algorithm fairness.  Some TCP algorithms
> are quite unfair -- unable even to share a link 50:50 between
> two identical flows started a few seconds apart.  A TCPCONG
> target makes it much easier to do this testing. Now that the
> kernel developers are getting good performance on long fat
> pipes the fairness and other attributes of that performance
> will be their next concern.

It still strikes me as a bit of a hack. Lets see what Stephen
thinks.
