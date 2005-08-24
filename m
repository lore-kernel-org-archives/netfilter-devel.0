From: "Jesse Peng" <Jesse@deansoft.com.tw>
Subject: Re: Doubt on packet generation in kernel space.
Date: Wed, 24 Aug 2005 17:54:32 +0800
Message-ID: <001501c5a891$d486de60$fefefe0a@jesseh7ht76e8n>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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


----- Original Message -----
From: "Jesse Peng" <Jesse@deansoft.com.tw>
To: "varun" <varun@rocsys.com>
Sent: Wednesday, August 24, 2005 4:43 PM
Subject: Re: Doubt on packet generation in kernel space.


> Dear Varun:
> According to linux networking kernel,before an ip packet successfully
being
> transmitted,the arp_table should be updated(if lack of) for the ip-mac
pair
> maintained in neighbour structure.So no matter how you trigger to update
> your ip-mac database,the kernel still need to update its arp_table.That's
> why directly using arp solution is suggested.
> Nevertheless,before neighbour being updated for the MAC,all your icmp
> requesting packet can do is waiting at the neighbour queue and get no
> transmitted.
> And think of a rare case,what if the target doesn't response to icmp
packet?
> Finally,I don't see things prevent you from arp solution  really prevent.
>
> Hope these suggestions help!
>
> Your sincerely
> Jesse
>
> ----- Original Message -----
> From: "varun" <varun@rocsys.com>
> To: "Jesse Peng" <jesse@deansoft.com.tw>
> Cc: "netfilters" <netfilter-devel@lists.netfilter.org>
> Sent: Tuesday, August 23, 2005 11:53 AM
> Subject: Re: Doubt on packet generation in kernel space.
>
>
> > Hi jesse,
> >
> >           I was not at home so i didnt check mail. Anyway thanx for your
> > help. I understand that instead of sending icmp if i can send an arp
> > packet using arp_send() (correct me if iam wrong) and maintain that
> > database. You also said if register with NF_ARP_IN that ill be able to
> > get all the arp packet.So in other words what you are asking me to do is
> > to build my own arp request and wait for the response. On based on the
> > response i should be able to update my table.I have a doubt here that is
> > if i register with NF_ARP_IN then i might get even packets that are arp
> > request from other host am i correct? If so is there any way i can make
> > sure that i get only response for the arp-request i sent? I guess i
> > might have write a logic to filter it myself is it?
> > Can you tell me what happens if the host to which i sent an arp request
> > is not reachable?I will not get the response so i must wait for sometime
> > and time out?
> >
> >                 sorry for asking lot of questions. If possible please
> > help me. actually i planned of using arp but for the above reasons i
> > opted for icmp.
> >
> >                                                      Varun
> >
> >
> >
> >
> >
> >
> >
> >
> >
> > On Thu, 2005-08-18 at 13:17, Jesse Peng wrote:
> > > Dear Varun:
> > >
> > > Sorry for replying late.Please forget anything that I mentioned about
> > > icmp.Accroding to your scenario,unless any special case you would
taken
> into
> > > account,others will resort to arp solution.Since the key issues are
all
> > > within arp domain.Let me share my idea as following:
> > > I supposed the MAC-ip database you maintained are derived from
> arp_table,and
> > > __neigh_lookup are used to keep it updated.Then to serve the ip-mac
> updating
> > > request,arp_send is used to send your arp request.And since this is
> > > netfilter list where you look for things,then I suggest you take care
> the
> > > reponse by hooking at NF_ARP_IN,which is at NF_ARP.
> > > Hope things help!
> > >
> > > Your sincerely
> > > Jesse
> > >
> > > ----- Original Message -----
> > > From: "varun" <varun@rocsys.com>
> > > To: "JessePeng" <jesse@deansoft.com.tw>
> > > Cc: "netfilters" <netfilter-devel@lists.netfilter.org>
> > > Sent: Tuesday, August 16, 2005 11:30 AM
> > > Subject: Re: Doubt on packet generation in kernel space.
> > >
> > >
> > > > Hi Jesse,
> > > > On Mon, 2005-08-15 at 10:18, JessePeng wrote:
> > > > > Dear Varun:
> > > > >
> > > > > How will you handle the response?Actually,that's derived from how
> you
> > > manage
> > > > > your "probe by icmp" machenism.It looks not simple as hacking an
> icmp
> > > > > packet!
> > > > > Pardon me if iam wrong but what i was thinking is i can use
> netfilters
> > > >   or dev_add_pack() and capture packets and take only packets with
> icmp
> > > > header and compare it. I dont know if it possible...Can i know what
> > > > might be the complications involved in it?
> > > >   You said "probe by icmp" mechanism ---Can you give me any
> suggestions
> > > > for this?
> > > >                                                             Varun
> > > >
> > > >
> > > > > Your sincerely
> > > > > Jesse
> > > > > ----- Original Message -----
> > > > > From: "varun" <varun@rocsys.com>
> > > > > To: "Jesse Peng" <jesse@deansoft.com.tw>
> > > > > Cc: "netfilters" <netfilter-devel@lists.netfilter.org>
> > > > > Sent: Friday, August 12, 2005 7:23 PM
> > > > > Subject: Re: Doubt on packet generation in kernel space.
> > > > >
> > > > >
> > > > > > Hi jesse,
> > > > > >
> > > > > >            Let me explain my requirement. I have a kernel module
> which
> > > > > > is basically maintaining some network database of what are the
MAC
> and
> > > > > > Ip of each of the system in the network. Now with the help of a
> > > > > > character pseudo driver, my user program will send an request to
> the
> > > > > > kernel module to generate the icmp (ping) packet to a particular
> host
> > > > > > from the maintained kernel database. It is on this event that
the
> > > packet
> > > > > > generator module comes into picture where in the inputs to the
> module
> > > is
> > > > > > IP and based on this the i might get a response from the
> destination
> > > > > > system and i will compare the MACs to see if they are equal. So
> for
> > > this
> > > > > > requirement i need a packet generator to handle this event. Only
> an
> > > icmp
> > > > > > packet is enough.
> > > > > >
> > > > > >                  Thanx in advance.
> > > > > >                                                        Varun
> > > > > >
> > > > > >
> > > > > > On Fri, 2005-08-12 at 13:45, Jesse Peng wrote:
> > > > > > > Dear Varun:
> > > > > > >
> > > > > > > It depends on whether your code is in process context or
> interupt
> > > > > context.
> > > > > > > Maybe you will elaberate the situation you generate the icmp
> > > packet?It
> > > > > will
> > > > > > > help more for others to help..
> > > > > > >
> > > > > > > Your sincerely
> > > > > > > Jesse
> > > > > > >
> > > > > > >
> > > > > > >
> > > > > > > ----- Original Message -----
> > > > > > > From: "varun" <varun@rocsys.com>
> > > > > > > To: <netfilter-devel@lists.netfilter.org>
> > > > > > > Sent: Thursday, August 11, 2005 2:33 PM
> > > > > > > Subject: Doubt on packet generation in kernel space.
> > > > > > >
> > > > > > >
> > > > > > > > Hi all
> > > > > > > >
> > > > > > > > Iam a newbie and iam basically interested in generation my
own
> > > > > > > > icmp packet in the kernel space using skb. That is iam aware
> that
> > > this
> > > > > > > > can be done using raw or packet socket from user space.
> > > But to
> > > > > > > > do it from kernel space is it possible if yes how to go
> > > > > > > > about it. i believe that what raw socket call from User
space
> does
> > > in
> > > > > > > > kernel thats what iam supposed to do.(Correct me if iam
> wrong). I
> > > > > think
> > > > > > > > i might have to build my own skb and put it in transmit
queue.
> Is
> > > it
> > > > > > > > possible? Iam also aware that there are some packet
generation
> > > module
> > > > > > > > that is inbuilt as per the Documentation in linux kernel
> states.
> > > But i
> > > > > > > > dont want to use that instead i want to create my own module
> that
> > > will
> > > > > > > > allow me generate the icmp packet. Please help!!
> > > > > > > >
> > > > > > > >
> Varun
> > > > > > > >
> > > > > > > >
> > > > > >
>
