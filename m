From: Patrick McHardy <kaber@trash.net>
Subject: Re: CLASSIFY target
Date: Tue, 30 May 2006 21:21:32 +0200
Message-ID: <447C9B3C.5030108@trash.net>
References: <0633E0EDB4F25F43A2D7179CA11FAFAB2553EF@xavier.staff.greatlakes.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Eliot, Wireless and Server Administrator,
	Great Lakes Internet" <support8@greatlakes.net>
In-Reply-To: <0633E0EDB4F25F43A2D7179CA11FAFAB2553EF@xavier.staff.greatlakes.net>
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

Eliot, Wireless and Server Administrator, Great Lakes Internet wrote:
> I am attempting to classify packets in tc using the iptables classify
> target in the postrouting chain of the mangle table, but it does not
> work. I am looking through the code to try to find out what is going on
> (whether I am doing something wrong, or whether the kernel module code
> is messed up). I have verified that the ipt_CLASSIFY.c file is correctly
> building a handle and that it is storing the handle in the skb->priority
> field. However, inside the packet scheduler code, I cannot find where
> the skb->priority field is being read so that the packets can be sent to
> the correct class. Could someone please point me in the correct
> direction for viewing this section of the code? Thanks.


The *_classify functions of the individual schedulers use it. I see
you also posted a more detailed description of your problem to lartc:
you can't use classify to classify to multiple nested qdiscs. So
if you have something like:

         <1:0 (root) hfsc>
<1:1 hfsc class> <1:2 hfsc class>
         |
   <2:0 PRIO>
         |
<2:1 - 2:3 PRIO classes>


and say CLASSIFY --set-class 2:1, the upper HFSC qdisc had no idea
how to reach qdisc 2:0. You can either use CLASSIFY --class 2:0
and then attach more classifiers to the PRIO qdisc or manually
direct traffic from 1:0 -> 2:0 and use CLASSIFY --set-class 2:1.
CLASSIFY is really only useful if you have only a single level
of classful qdiscs.
