From: Steven J Scott <sjscott@ra.rockwell.com>
Subject: Re: How can I get these packets in the user space application?
 Performance Issues?
Date: Thu, 9 Dec 2004 09:38:52 -0600
Message-ID: <OF3990817D.244AD4C0-ON86256F65.005572ED-86256F65.0055EDC2@ra.rockwell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Henrik Nordstrom <hno@marasystems.com>, kung@uiuc.edu,
	netfilter-devel@lists.netfilter.org,
	"Mukund JB." <mukundjb@esntechnologies.co.in>,
	netfilter-devel-bounces@lists.netfilter.org,
	Diego Woitasen <diegows@linux.org.ar>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Maarten Wijnants" <maarten.wijnants@pandora.be>
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

I have a side question on this.  I have a kernel module that creates a 
netfilter hook that looks for packets with a certain source port, and then 
directs them to NF_QUEUE, and I have a user space application that receives the queued packets. 
Since I am only queuing packets I want to monitor/modify is my performance 
hit significant?  Or am I better off doing everything within the kernel 
module?

Thanks,

Steven Scott - CISSP, CISA, RHCT, LCP, MCSE
Rockwell Automation / Advanced Technology
sjscott@ra.rockwell.com
<---------------------------------------------------->
(This email was sent via Notes running on Linux)




"Maarten Wijnants" <maarten.wijnants@pandora.be>
Sent by: netfilter-devel-bounces@lists.netfilter.org
09/12/2004 07:24 AM

 
        To:     "Srinivas G." <srinivasg@esntechnologies.co.in>, "Henrik Nordstrom" 
<hno@marasystems.com>
        cc:     kung@uiuc.edu, netfilter-devel@lists.netfilter.org, "Mukund JB." 
<mukundjb@esntechnologies.co.in>, Diego Woitasen <diegows@linux.org.ar>
        Subject:        Re: How can I get these packets in the user space application?


Hello Srinivas G,

> My doubt is: How the user application can get the packet from the 'hook'
> function? What APIs are used in the user space application to access the
> packet from the hook function?

I am trying to understand your current situation. So you have a kernel 
module that is subscribed to a certain netfilter hook and as a result 
starts 
receiving packets; and now you want to pass these packets from your kernel 

module to a userspace application? Is this correct?

If this is your current situation, you should issue a NF_QUEUE verdict for 

arriving packets in your kernel module to queue the packets to userspace. 
Subsequently, you will need to create a userspace application to receive 
the 
queued packets and run it. You can use libipq to write a userspace 
application that will accept queued packets. See the man page of libipq 
for 
more information on how to do this (the man page contains a fully working 
example).

I hope this helps you. Regards,
Maarten 
