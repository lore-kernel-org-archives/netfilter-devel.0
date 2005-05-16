From: Steven J Scott <sjscott@ra.rockwell.com>
Subject: Re: Handling large amounts of data (SIDE QUESTION)
Date: Mon, 16 May 2005 10:23:39 -0500
Message-ID: <OF9338F2A4.2824107C-ON86257003.0051EBEE-86257003.00546CEB@ra.rockwell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	netfilter-devel-bounces@lists.netfilter.org
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

When developing filters where rules can have IP ranges what is the most 
efficient way of handling this?  Do you have a single rule that your user 
space program breaks down to multiple rules in your kernel module?

END USER PROGRAM: IP: 192.90.22.33->192.90.22.40, PORT: 90, BLOCK

KERNEL MODULE TABLE:

192.90.22.33 BLOCK 90
192.90.22.34 BLOCK 90
....
....
192.90.22.40 BLOCK 90

Then the kernel module just steps through each of the tables entries 
looking for a match.
 
Or is there a more effiect way of taging a rule as a range and then have a 
function do some type of greater then or less operation?

e.g.  compare the range of addresses in their native 32bit order to the 
packet that was captured?

So if I have the range above I could use the following operation to do a 
very effient check:


__u32 32bitLowIPRang = hton(192.90.22.33);
--u32 32bitHighIPRange = hton(192.90.22.40);

if ( captured_packets_ip_address >= 32bitLowIPRange && 
captured_packets_ip_address <= 32bitHighIPRange)
        printf("match!");

Now I know with masks it gets tricky, but I am wondering how people handle 
this specfic requiment.

Thanks,

Steven Scott - CISSP, CISA, RHCT, LCP, MCSE
Rockwell Automation / Advanced Technology
sjscott@ra.rockwell.com
<---------------------------------------------------->
(This email was sent via Notes running on Linux)




Silimite <silimite@gmail.com>
Sent by: netfilter-devel-bounces@lists.netfilter.org
05/16/2005 09:39 AM
Please respond to Silimite

 
        To:     Tobias DiPasquale <codeslinger@gmail.com>
        cc:     netfilter-devel <netfilter-devel@lists.netfilter.org>
        Subject:        Re: Handling large amounts of data


Thanks!  I'll look into that more.  I had looked at the netlink
sockets in the past but they seemed to require a more complex
interface (ie. I can't just cat/echo commands like in procfs).  I do
like the idea of being able to use netlink and have persistent
connections open (for status updates like in a GUI interface).

I suppose there are not a lot of modules that need this type of
interface.   I noticed that there was at least one other module using
procfs.

s

On 5/15/05, Tobias DiPasquale <codeslinger@gmail.com> wrote:
>  A unicast netlink socket would almost certainly be the best way to go
> here. For examples on how to use unicast netlink sockets, look at
> net/ipv4/netfilter/ip_queue.c or net/core/rtnetlink.c.
> 
> --
> [ Tobias DiPasquale ]
> 0x636f6465736c696e67657240676d61696c2e636f6d
