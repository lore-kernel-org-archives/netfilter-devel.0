From: varun <varun@rocsys.com>
Subject: Re: Doubt on packet generation in kernel space.
Date: Tue, 23 Aug 2005 09:23:19 +0530
Message-ID: <1124769199.7681.20.camel@varun>
References: <1123742009.14923.110.camel@varun>
	<001701c59f16$11acc780$0f01a8c0@deansoft8ufttf>
	<1123845780.2598.7.camel@varun> <001301c5a154$8ae51180$1501a8c0@test1>
	<1124163056.1639.3.camel@varun>
	<000901c5a3c9$14cc1440$0f01a8c0@deansoft8ufttf>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilters <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jesse Peng <jesse@deansoft.com.tw>
In-Reply-To: <000901c5a3c9$14cc1440$0f01a8c0@deansoft8ufttf>
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

Hi jesse,

          I was not at home so i didnt check mail. Anyway thanx for your
help. I understand that instead of sending icmp if i can send an arp
packet using arp_send() (correct me if iam wrong) and maintain that
database. You also said if register with NF_ARP_IN that ill be able to
get all the arp packet.So in other words what you are asking me to do is
to build my own arp request and wait for the response. On based on the
response i should be able to update my table.I have a doubt here that is
if i register with NF_ARP_IN then i might get even packets that are arp
request from other host am i correct? If so is there any way i can make
sure that i get only response for the arp-request i sent? I guess i
might have write a logic to filter it myself is it?
Can you tell me what happens if the host to which i sent an arp request
is not reachable?I will not get the response so i must wait for sometime
and time out?

                sorry for asking lot of questions. If possible please
help me. actually i planned of using arp but for the above reasons i
opted for icmp.

                                                     Varun  









On Thu, 2005-08-18 at 13:17, Jesse Peng wrote:
> Dear Varun:
> 
> Sorry for replying late.Please forget anything that I mentioned about
> icmp.Accroding to your scenario,unless any special case you would taken into
> account,others will resort to arp solution.Since the key issues are all
> within arp domain.Let me share my idea as following:
> I supposed the MAC-ip database you maintained are derived from arp_table,and
> __neigh_lookup are used to keep it updated.Then to serve the ip-mac updating
> request,arp_send is used to send your arp request.And since this is
> netfilter list where you look for things,then I suggest you take care the
> reponse by hooking at NF_ARP_IN,which is at NF_ARP.
> Hope things help!
> 
> Your sincerely
> Jesse
> 
> ----- Original Message -----
> From: "varun" <varun@rocsys.com>
> To: "JessePeng" <jesse@deansoft.com.tw>
> Cc: "netfilters" <netfilter-devel@lists.netfilter.org>
> Sent: Tuesday, August 16, 2005 11:30 AM
> Subject: Re: Doubt on packet generation in kernel space.
> 
> 
> > Hi Jesse,
> > On Mon, 2005-08-15 at 10:18, JessePeng wrote:
> > > Dear Varun:
> > >
> > > How will you handle the response?Actually,that's derived from how you
> manage
> > > your "probe by icmp" machenism.It looks not simple as hacking an icmp
> > > packet!
> > > Pardon me if iam wrong but what i was thinking is i can use netfilters
> >   or dev_add_pack() and capture packets and take only packets with icmp
> > header and compare it. I dont know if it possible...Can i know what
> > might be the complications involved in it?
> >   You said "probe by icmp" mechanism ---Can you give me any suggestions
> > for this?
> >                                                             Varun
> >
> >
> > > Your sincerely
> > > Jesse
> > > ----- Original Message -----
> > > From: "varun" <varun@rocsys.com>
> > > To: "Jesse Peng" <jesse@deansoft.com.tw>
> > > Cc: "netfilters" <netfilter-devel@lists.netfilter.org>
> > > Sent: Friday, August 12, 2005 7:23 PM
> > > Subject: Re: Doubt on packet generation in kernel space.
> > >
> > >
> > > > Hi jesse,
> > > >
> > > >            Let me explain my requirement. I have a kernel module which
> > > > is basically maintaining some network database of what are the MAC and
> > > > Ip of each of the system in the network. Now with the help of a
> > > > character pseudo driver, my user program will send an request to the
> > > > kernel module to generate the icmp (ping) packet to a particular host
> > > > from the maintained kernel database. It is on this event that the
> packet
> > > > generator module comes into picture where in the inputs to the module
> is
> > > > IP and based on this the i might get a response from the destination
> > > > system and i will compare the MACs to see if they are equal. So for
> this
> > > > requirement i need a packet generator to handle this event. Only an
> icmp
> > > > packet is enough.
> > > >
> > > >                  Thanx in advance.
> > > >                                                        Varun
> > > >
> > > >
> > > > On Fri, 2005-08-12 at 13:45, Jesse Peng wrote:
> > > > > Dear Varun:
> > > > >
> > > > > It depends on whether your code is in process context or interupt
> > > context.
> > > > > Maybe you will elaberate the situation you generate the icmp
> packet?It
> > > will
> > > > > help more for others to help..
> > > > >
> > > > > Your sincerely
> > > > > Jesse
> > > > >
> > > > >
> > > > >
> > > > > ----- Original Message -----
> > > > > From: "varun" <varun@rocsys.com>
> > > > > To: <netfilter-devel@lists.netfilter.org>
> > > > > Sent: Thursday, August 11, 2005 2:33 PM
> > > > > Subject: Doubt on packet generation in kernel space.
> > > > >
> > > > >
> > > > > > Hi all
> > > > > >
> > > > > > Iam a newbie and iam basically interested in generation my own
> > > > > > icmp packet in the kernel space using skb. That is iam aware that
> this
> > > > > > can be done using raw or packet socket from user space.
> But to
> > > > > > do it from kernel space is it possible if yes how to go
> > > > > > about it. i believe that what raw socket call from User space does
> in
> > > > > > kernel thats what iam supposed to do.(Correct me if iam wrong). I
> > > think
> > > > > > i might have to build my own skb and put it in transmit queue. Is
> it
> > > > > > possible? Iam also aware that there are some packet generation
> module
> > > > > > that is inbuilt as per the Documentation in linux kernel states.
> But i
> > > > > > dont want to use that instead i want to create my own module that
> will
> > > > > > allow me generate the icmp packet. Please help!!
> > > > > >
> > > > > >                                                             Varun
> > > > > >
> > > > > >
> > > >
