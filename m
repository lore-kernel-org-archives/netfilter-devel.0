From: "Mayank Kumar" <mayank_kumar@intersolutions.stpn.soft.net>
Subject: FW: injecting new packets into the netfilter
Date: Wed, 30 Jun 2004 10:16:59 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <BNELKLECKCDLOPNOBHFHOEBNJEAA.mayank_kumar@intersolutions.stpn.soft.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <netfilter@lists.netfilter.org>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <aksingh@hss.hns.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Amit
i think u missed out my mail so i resending it to you
regds
Mayank

-----Original Message-----
From: Mayank Kumar [mailto:mayank_kumar@intersolutions.stpn.soft.net]
Sent: Tuesday, June 29, 2004 11:49 AM
To: aksingh@hss.hns.com
Cc: netfilter@lists.netfilter.org
Subject: RE: injecting new packets into the netfilter


Hi Amit
thanks for ur prompt replies.
firstly from ur replies it seems
that
1: Whatever packets that i will construct using libnet or
   for that matter using ordinary bsd sockets would pass the
   relevant hooks in the netfilter based on the dest ip address
   i set. Is this true?? In this case i am constructing the packet
   completely on my own.

Now what i want to do is steal(NF_STOLEN) packets at specific hooks
(generally pre routing)
within the netfilter and queue them to a user mode process.
The User mode process does some processing and either sends
the same packet or completely new and umpteen in number packets
at the post routing hook in netfilter(from ur answer using libnet).
>From ur answer it seems quite possible very easily. Correct
me if i am wrong here. Also is there any advantage of using
libnet over bsd sockets in terms of performance. Is there any
other performance optmized way of sending and receiving packets from
user to kernel mode?? Does netlink sockets way offer a more
optimized way of doing it?? (Sorry for a flurry of questions!!)


Now the second part is what if i want to move it all to kernel mode for
performance reasons.
This means steal packet at pre_routing and then queue them all to
a kernel thread which was created using a kernel module. The kernel
thread then does some processing on the packets and then sends either
the captured packet or completely new packets out through the post routing
hook.
How can this be achieved??

regds
Mayank




-----Original Message-----
From: aksingh@hss.hns.com [mailto:aksingh@hss.hns.com]
Sent: Tuesday, June 29, 2004 11:21 AM
To: Mayank Kumar
Cc: netfilter@lists.netfilter.org
Subject: RE: injecting new packets into the netfilter






Hi,

 You want to insert packets within the kernel module thta has netfilter
hooks ?, I dont thinkthat is a very good idea, as the packets u send using
a libnet application wld be caught at the netfilter hooks, if the
application resides on the same pc on which yr kernel module that has hook
funcstions resides, then those packets will traverse, local_out, post
routing, pre_routing, local_in etc based on their dest ip addresses, any
packet coming from ethernet wld traverse pre_routing, then local_in or
ip_forward and post_routing .....

Amit




"Mayank Kumar"
<mayank_kumar@intersolutions.stpn.soft.net>@lists.netfilter.org on
06/29/2004 11:15:52 AM

Sent by:    netfilter-admin@lists.netfilter.org


To:    Amit Kumar Singh/HSS@HSS
cc:    <netfilter@lists.netfilter.org>

Subject:    RE: injecting new packets into the netfilter


Hi Akash
i know of this library.
But i want to inject packets at precise hooks
in the netfilter. for e.g. i want to inject packets whenever
the need arises ,at the fwding hook or the post routing hook. Will the
raw packets i send using the libnet get caught at hooks inserted using
netfilter at various points.

regds
Mayank

-----Original Message-----
From: aksingh@hss.hns.com [mailto:aksingh@hss.hns.com]
Sent: Tuesday, June 29, 2004 10:49 AM
To: Mayank Kumar
Cc: netfilter@lists.netfilter.org
Subject: Re: injecting new packets into the netfilter






Hi,

  Try libnet for injecting new packets, you can use raw packets(u inject
from userland), libnet provides you with a better interface, but you wld
need root permission to use raw sockets. you can get libnet library from
packetfactory.net

HTH
Amit




"Mayank Kumar"
<mayank_kumar@intersolutions.stpn.soft.net>@lists.netfilter.org on
06/29/2004 10:17:16 AM

Sent by:    netfilter-admin@lists.netfilter.org


To:    <netfilter@lists.netfilter.org>
cc:

Subject:    injecting new packets into the netfilter


Hi all,
I want to know how can we inject absolutely new packets at
various hook points in netfilter. I have already seen
some questions posted on this earlier too but no replies
as such. I am very eager to know about this because using
this we can construct some really cool stuff. Currently we
are undergoing a project on this and it would be of greate
help if somebody can find a solution to this.

Thanks in advance for any help on this.
regds
Mayank
