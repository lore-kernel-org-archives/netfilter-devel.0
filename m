From: Steven J Scott <sjscott@ra.rockwell.com>
Subject: Re: sk_buff examples
Date: Mon, 6 Dec 2004 10:41:59 -0600
Message-ID: <OFF13352DE.0A7FFD69-ON86256F62.005B5298-86256F62.005BB504@ra.rockwell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Diego Woitasen <diegows@linux.org.ar>, netfilter-devel@lists.netfilter.org
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

Thank you very much.  That was exactly what I was looking for.  This 
weekend I was also able to find a book titled, "The Linux TCP/IP Stack: 
Networking for Embedded Systems" by Thomas F. Herbert.  It has a whole 
chapter on sk_buff.  It's a great book for those looking to completely 
understand the Linux TCP/IP stack.

Thanks again for your help!

Steven Scott - CISSP, CISA, RHCT, LCP, MCSE
Rockwell Automation / Advanced Technology
sjscott@ra.rockwell.com
<---------------------------------------------------->
(This email was sent via Notes running on Linux)




Diego Woitasen <diegows@linux.org.ar>
03/12/2004 05:14 PM

 
        To:     Steven J Scott <sjscott@ra.rockwell.com>
        cc: 
        Subject:        Re: sk_buff examples


See the ipt_string.c match module, it's a good example of string search
in payload.



On Fri, 2004-12-03 at 11:35 -0600, Steven J Scott wrote:
> Hello,
> 
> I am trying to decode packets within the kernel using netfilter hooks, 
and 
> I have read through multiple examples of parsing the src and dst 
address, 
> ports, etc., but I am unable to find any information on parsing the 
> payload of the packet.  What I am trying to do is examine payload to 
find 
> a string match. Could anyone point me in the right direction.
> 
> Thanks a lot.
> 
> Steve
-- 
