From: "Maarten Wijnants" <maarten.wijnants@pandora.be>
Subject: Re: How can I get these packets in the user space application?
Date: Thu, 9 Dec 2004 14:24:42 +0100
Message-ID: <008101c4ddf2$736d65f0$6c2813ac@in.edm.luc.ac.be>
References: <4EE0CBA31942E547B99B3D4BFAB3481125897A@mail.esn.co.in>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: kung@uiuc.edu, netfilter-devel@lists.netfilter.org,
	"Mukund JB." <mukundjb@esntechnologies.co.in>,
	Diego Woitasen <diegows@linux.org.ar>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Srinivas G." <srinivasg@esntechnologies.co.in>,
	"Henrik Nordstrom" <hno@marasystems.com>
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

Hello Srinivas G,

> My doubt is: How the user application can get the packet from the 'hook'
> function? What APIs are used in the user space application to access the
> packet from the hook function?

I am trying to understand your current situation. So you have a kernel 
module that is subscribed to a certain netfilter hook and as a result starts 
receiving packets; and now you want to pass these packets from your kernel 
module to a userspace application? Is this correct?

If this is your current situation, you should issue a NF_QUEUE verdict for 
arriving packets in your kernel module to queue the packets to userspace. 
Subsequently, you will need to create a userspace application to receive the 
queued packets and run it. You can use libipq to write a userspace 
application that will accept queued packets. See the man page of libipq for 
more information on how to do this (the man page contains a fully working 
example).

I hope this helps you. Regards,
Maarten 
