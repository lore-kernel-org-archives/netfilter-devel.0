From: Steven J Scott <sjscott@ra.rockwell.com>
Subject: Re: How can I get these packets in the user space application?
 Performance Issues?
Date: Thu, 9 Dec 2004 11:25:33 -0600
Message-ID: <OF983ED5C8.70FF0673-ON86256F65.005EA189-86256F65.005FB213@ra.rockwell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>,
	"Maarten Wijnants" <maarten.wijnants@pandora.be>
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

Hello Henrik and Maarten,

Thanks for the replies btw.

I am matching the source port in the kernel module, and then parsing the 
payload in the user space.  If there is a match its sent to NF_QUEUE.  In 
the user space app I am looking for certain criteria in the payload 
portion of the packet and then making a decision to accept or drop. 

My parsing algorithm consists of about 15 different checks per matching 
packet sent from the kernel module.  Its not that complicated, but I was 
wondering from a performance stand point if it was better to implement 
everything into kernel space?  The amount of network traffic being 
filtered will be relatively small.  On the size of maybe 2mb per second.

I don't think this is possible with IPTABLES... Please correct me if I'm 
wrong..

Thanks again,

Steven Scott - CISSP, CISA, RHCT, LCP, MCSE
Rockwell Automation / Advanced Technology
sjscott@ra.rockwell.com
<---------------------------------------------------->
(This email was sent via Notes running on Linux)




Henrik Nordstrom <hno@marasystems.com>
09/12/2004 11:02 AM

 
        To:     Steven J Scott <sjscott@ra.rockwell.com>
        cc:     netfilter-devel@lists.netfilter.org
        Subject:        Re: How can I get these packets in the user space application? Performance 
Issues?


On Thu, 9 Dec 2004, Steven J Scott wrote:

> I have a side question on this.  I have a kernel module that creates a
> netfilter hook that looks for packets with a certain source port, and 
then
> directs them to NF_QUEUE, and I have a user space application that 
receives the queued packets.
> Since I am only queuing packets I want to monitor/modify is my 
performance
> hit significant?  Or am I better off doing everything within the kernel
> module?

Only the packets you return NF_QUEUE on receives a noticeable performance 
penalty.

But if all you do is to look into the source port then why not use plain 
iptables for the match?

Regards
Henrik
