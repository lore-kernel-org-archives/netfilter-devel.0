From: Ravi Kumar <ravivsn@rocsys.com>
Subject: Re: How can I get these packets in the user space application?
Date: Thu, 09 Dec 2004 19:04:01 +0530
Message-ID: <41B85449.6080306@rocsys.com>
References: <4EE0CBA31942E547B99B3D4BFAB3481125897A@mail.esn.co.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kung@uiuc.edu, netfilter-devel@lists.netfilter.org,
	"Mukund JB." <mukundjb@esntechnologies.co.in>,
	Henrik Nordstrom <hno@marasystems.com>,
	Diego Woitasen <diegows@linux.org.ar>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Srinivas G." <srinivasg@esntechnologies.co.in>
In-Reply-To: <4EE0CBA31942E547B99B3D4BFAB3481125897A@mail.esn.co.in>
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

Srinivas,
  You can use libipq library to get packets in user space and can also 
give verdicts. snort_inline uses this method to get packets to IDS 
engine which works in user space.

Regards,
-Ravi


Srinivas G. wrote:
>>On Wed, 8 Dec 2004, Srinivas G. wrote:
>>
>>
>>>My question is: How can I get these packets in the user space
>>>application?
>>
>>Depends on what you want to do with the packet. If you intend to have
> 
> them
> 
>>returned back to the kernel then QUEUE is the best action.
>>
>>If you only want to have them sent to userspace then a more lean
> 
> design
> 
>>may be desireable.
>>
>>Regards
>>Henrik
> 
> 
> Dear Henrik,
> 
> Actually I am new to network device drivers. Please spend some time to
> read this mail.
> 
> Actually I need to send the packets to user space and then in the user
> space I need to do some calculations on the packet data and then I want
> to send the packet back to kernel space.
> 
> According to Mr. Ravi Kumar from rocsys.com there is a performance issue
> in moving packets from kernel space to user space and then back to
> kernel space. Even though, I need to transmit the packets from kernel to
> user space and back to kernel space.
> 
> I have gone through the documents that are available in the
> netfilter.org. 
> Especially I read the netfilter-hacking-HOWTO-4.html document which
> explains about iptables, NAT and netfilter. I mainly concentrated on
> netfilter driver. My understanding is as follows.
> 
> I send the sample code in the previous mail to you. 
> 
> I understood that queue the packet for user space handling. Finally we
> can issue 'nf_reinject' to send the packet into the network path again.
> 
> I understood the some of the concepts about 'setsockopt' mechanism in
> the netfilter driver which is useful for processing the user space
> commands in the kernel. 
> 
> I understood the topics from the following link.
> http://www.netfilter.org/documentation/HOWTO//netfilter-hacking-HOWTO-4.
> html
> 
> ---------
> My doubt is: How the user application can get the packet from the 'hook'
> function? What APIs are used in the user space application to access the
> packet from the hook function?
> 
> Thanks and regards,
> Srinivas G
> 
> 
