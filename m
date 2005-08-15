From: "JessePeng" <jesse@deansoft.com.tw>
Subject: Re: Doubt on packet generation in kernel space.
Date: Mon, 15 Aug 2005 12:48:11 +0800
Message-ID: <001301c5a154$8ae51180$1501a8c0@test1>
References: <1123742009.14923.110.camel@varun>
	<001701c59f16$11acc780$0f01a8c0@deansoft8ufttf>
	<1123845780.2598.7.camel@varun>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 7bit
Cc: netfilters <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "varun" <varun@rocsys.com>
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

Dear Varun:

How will you handle the response?Actually,that's derived from how you manage
your "probe by icmp" machenism.It looks not simple as hacking an icmp
packet!

Your sincerely
Jesse
----- Original Message -----
From: "varun" <varun@rocsys.com>
To: "Jesse Peng" <jesse@deansoft.com.tw>
Cc: "netfilters" <netfilter-devel@lists.netfilter.org>
Sent: Friday, August 12, 2005 7:23 PM
Subject: Re: Doubt on packet generation in kernel space.


> Hi jesse,
>
>            Let me explain my requirement. I have a kernel module which
> is basically maintaining some network database of what are the MAC and
> Ip of each of the system in the network. Now with the help of a
> character pseudo driver, my user program will send an request to the
> kernel module to generate the icmp (ping) packet to a particular host
> from the maintained kernel database. It is on this event that the packet
> generator module comes into picture where in the inputs to the module is
> IP and based on this the i might get a response from the destination
> system and i will compare the MACs to see if they are equal. So for this
> requirement i need a packet generator to handle this event. Only an icmp
> packet is enough.
>
>                  Thanx in advance.
>                                                        Varun
>
>
> On Fri, 2005-08-12 at 13:45, Jesse Peng wrote:
> > Dear Varun:
> >
> > It depends on whether your code is in process context or interupt
context.
> > Maybe you will elaberate the situation you generate the icmp packet?It
will
> > help more for others to help..
> >
> > Your sincerely
> > Jesse
> >
> >
> >
> > ----- Original Message -----
> > From: "varun" <varun@rocsys.com>
> > To: <netfilter-devel@lists.netfilter.org>
> > Sent: Thursday, August 11, 2005 2:33 PM
> > Subject: Doubt on packet generation in kernel space.
> >
> >
> > > Hi all
> > >
> > > Iam a newbie and iam basically interested in generation my own
> > > icmp packet in the kernel space using skb. That is iam aware that this
> > > can be done using raw or packet socket from user space.         But to
> > > do it from kernel space is it possible if yes how to go
> > > about it. i believe that what raw socket call from User space does in
> > > kernel thats what iam supposed to do.(Correct me if iam wrong). I
think
> > > i might have to build my own skb and put it in transmit queue. Is it
> > > possible? Iam also aware that there are some packet generation module
> > > that is inbuilt as per the Documentation in linux kernel states. But i
> > > dont want to use that instead i want to create my own module that will
> > > allow me generate the icmp packet. Please help!!
> > >
> > >                                                             Varun
> > >
> > >
>
