From: "Maarten Wijnants" <maarten.wijnants@pandora.be>
Subject: Re: How can I get these packets in the user space application?
	Performance Issues?
Date: Thu, 9 Dec 2004 17:30:38 +0100
Message-ID: <00dd01c4de0c$6ad9d0d0$6c2813ac@in.edm.luc.ac.be>
References: <OF3990817D.244AD4C0-ON86256F65.005572ED-86256F65.0055EDC2@ra.rockwell.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>, kung@uiuc.edu,
	netfilter-devel@lists.netfilter.org,
	"Mukund JB." <mukundjb@esntechnologies.co.in>,
	netfilter-devel-bounces@lists.netfilter.org,
	Diego Woitasen <diegows@linux.org.ar>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Steven J Scott" <sjscott@ra.rockwell.com>
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

Hello Steven,

>I have a side question on this.  I have a kernel module that creates a
> netfilter hook that looks for packets with a certain source port, and then
> directs them to NF_QUEUE, and I have a user space application that 
> receives the queued packets.
> Since I am only queuing packets I want to monitor/modify is my performance
> hit significant?  Or am I better off doing everything within the kernel
> module?
>

As I see it, there will only be a slight performance loss for the packets 
you are queueing to userspace, all other packets are not sent to userspace 
and as a result do not incur extra delay. In my opinion, the question 
whether you should monitor/modify the packets in userspace or kernelspace 
depends on the complexity of the operations you would like to perform on the 
packets. If rather complicated operations are needed, it is my opinion you 
are better off in userspace (programming in userspace is easier than 
programming in kernelspace). On the other hand, if processing speed is 
really essential, you should choose for kernelspace processing.

Kind regards,
Maarten 
