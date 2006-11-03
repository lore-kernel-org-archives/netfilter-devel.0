From: "will_u_tellmemore will_u_tellmemore" <will.u.tellmemore@gmail.com>
Subject: Using netfilter for implementing ft-tcp (Fault tolerant TCP)
Date: Fri, 3 Nov 2006 14:46:33 +0530
Message-ID: <97993dc40611030116s146d0c11we0549a79ac0d7dd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

am trying to implement Fault tolerant TCP as explained in

 http://citeseer.ist.psu.edu/alvisi00wrapping.html

While looking for some information regarding how to implement this , i
came across netfilter framework.
I am new to linux world so i would like to have some help about this
before i proceed.
 The idea in paper is to implement a kernel module which will
intercept all the packets coming to server tcp and log them to stable
buffer.If server crashes , then replay these logs. Also to handle
client connection correctly ,it intercepts all outgoing packets and
modifies the sequence number and thus the "segment"  depending upon
the packet's state in stable buffer( i.e. commited /no ).

So i was wondering ,is netfilter the right choice to about it ?? or
does it intercept packet below IP layer (in PRE_ROUTING)  ??
Is thr a way to sit between TCP and IP protocol implementation and
intercept all the communication between them ??
Also does priority specified in the hook have anything to do here ??

What is  the other way to achieve this if not netfilter framework ??

Any help in this regard is highly appreciated  ...

Regards,
TellMeMore
