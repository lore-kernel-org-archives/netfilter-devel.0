From: Steven J Scott <sjscott@ra.rockwell.com>
Subject: Re: Handling large amounts of data (SIDE QUESTION)
Date: Mon, 16 May 2005 11:37:39 -0500
Message-ID: <OF359FE022.8D754822-ON86257003.005B3FA2-86257003.005B33A3@ra.rockwell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

That's good to hear.  I wanted to insure that was the proper way of doing 
range searches.

Thanks for you input.


Steven Scott - CISSP, CISA, RHCT, LCP, MCSE
Rockwell Automation / Advanced Technology
sjscott@ra.rockwell.com
<---------------------------------------------------->
(This email was sent via Notes running on Linux)




Silimite <silimite@gmail.com>
05/16/2005 10:49 AM
Please respond to Silimite

 
        To:     Steven J Scott <sjscott@ra.rockwell.com>
        cc:     netfilter-devel <netfilter-devel@lists.netfilter.org>
        Subject:        Re: Handling large amounts of data (SIDE QUESTION)


As far as I know iprange does what you are talking about for single
ranges.  So if you set a range like:

iptables -A INPUT -m iprange --src-range 192.0.0.0-192.255.255.255 -j DROP

It just does a less-than/greater-than to check IP's against the range.

My multirange module is similar except it takes it to the next level. 
Since it needs to match against many thousands of ranges it has a
sorted table of all the ranges and then uses a binary search to find
matches within the ranges.

s


On 5/16/05, Steven J Scott <sjscott@ra.rockwell.com> wrote:
> When developing filters where rules can have IP ranges what is the most
> efficient way of handling this?  Do you have a single rule that your 
user
> space program breaks down to multiple rules in your kernel module?
> 
> END USER PROGRAM: IP: 192.90.22.33->192.90.22.40, PORT: 90, BLOCK
> 
> KERNEL MODULE TABLE:
> 
> 192.90.22.33 BLOCK 90
> 192.90.22.34 BLOCK 90
> ....
> ....
> 192.90.22.40 BLOCK 90
> 
> Then the kernel module just steps through each of the tables entries
> looking for a match.
> 
> Or is there a more effiect way of taging a rule as a range and then have 
a
> function do some type of greater then or less operation?
> 
> e.g.  compare the range of addresses in their native 32bit order to the
> packet that was captured?
> 
> So if I have the range above I could use the following operation to do a
> very effient check:
> 
> __u32 32bitLowIPRang = hton(192.90.22.33);
> --u32 32bitHighIPRange = hton(192.90.22.40);
> 
> if ( captured_packets_ip_address >= 32bitLowIPRange &&
> captured_packets_ip_address <= 32bitHighIPRange)
>         printf("match!");
> 
> Now I know with masks it gets tricky, but I am wondering how people 
handle
> this specfic requiment.
>
