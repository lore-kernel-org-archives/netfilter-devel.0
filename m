From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: How can I get these packets in the user space application?
 Performance Issues?
Date: Thu, 9 Dec 2004 18:02:15 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0412091801040.1688@filer.marasystems.com>
References: <OF3990817D.244AD4C0-ON86256F65.005572ED-86256F65.0055EDC2@ra.rockwell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Steven J Scott <sjscott@ra.rockwell.com>
In-Reply-To: <OF3990817D.244AD4C0-ON86256F65.005572ED-86256F65.0055EDC2@ra.rockwell.com>
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

On Thu, 9 Dec 2004, Steven J Scott wrote:

> I have a side question on this.  I have a kernel module that creates a
> netfilter hook that looks for packets with a certain source port, and then
> directs them to NF_QUEUE, and I have a user space application that receives the queued packets.
> Since I am only queuing packets I want to monitor/modify is my performance
> hit significant?  Or am I better off doing everything within the kernel
> module?

Only the packets you return NF_QUEUE on receives a noticeable performance 
penalty.

But if all you do is to look into the source port then why not use plain 
iptables for the match?

Regards
Henrik
