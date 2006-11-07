From: "will_u_tellmemore will_u_tellmemore" <will.u.tellmemore@gmail.com>
Subject: problems while using netfilter hook with NF_IP_LOCAL_IN
Date: Tue, 7 Nov 2006 19:03:25 +0530
Message-ID: <97993dc40611070533m42ea7304g41106013daeedf2c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi all,

I am trying to implement Fault tolerant TCP as explained in

http://citeseer.ist.psu.edu/alvisi00wrapping.html

While looking for some information regarding how to implement this , i
came across netfilter framework.I am new to linux world so i would
like to have some help about this before i proceed.

      The idea in paper is to implement a kernel module which will
intercept all the packets coming to server tcp and log them to stable
buffer.If server crashes , then replay these logs. Also to handle
client connection correctly ,it intercepts all outgoing packets and
modifies the sequence number and thus the "segment"  depending upon
the packet's state in stable buffer( i.e. committed /no ).

So i was wondering ,is netfilter the right choice to about it ?? Or
does it intercept packet below IP layer (in PRE_ROUTING)  ??Is there a
way to sit between TCP and IP protocol implementation and intercept
all the communication between them (using netfilter)??

What is  the other way to acheive this if not netfilter framework ??

I had put this question on netfilter user list but it was not
answered. So i am putting this question here.
    i tried with NF_IP_LOCAL_IN but my hook is not getting
called.Though module is inserted correctly and connections getting
established (I tested this by making an ftp connection to a site).Same
code works for NF_IP_PRE_ROUTING. The hook priority is INT_MIN in both
cases . I also noticed my NF_IP_PRE_ROUTING doesn't work if i change
the priority to INT_MAX.

Any help with these questions is greatly appreciated ..

Regards,
TellMeMore
