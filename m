From: "Swaroop Ashish" <sashish@novell.com>
Subject: Re: Unable to receive data Netlinks sockets
Date: Thu, 25 Mar 2004 02:37:15 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <s06245ee.077@prv-mail25.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <pablo@eurodev.net>,<netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Thanks Pablo, 

I have already used libipq successfully, but I want to play around with
Netlink sockets now. I have a problem in recieving packets through
Netlink sockets. Any help on that will be really great :-)

Thanks
Ashish

>>> Pablo Neira <pablo@eurodev.net> 3/25/2004 2:58:07 PM >>>
Hi,

Swaroop Ashish wrote:

> I want to write a test program to
>receive all the packets recieved on the system via this test program
>using Netlinks sockets.  Can anyone please tell me what is wrong in
the
>following program and what configuration/rules should be added to
>Iptables to do the same.
>  
>

if you want to play around with ip_queue, the module which let you send

packets from kernel space to user space and vice-versa, you *should*
use 
libipq instead of using raw netlink sockets, please have a look at 
libipq available in iptables source code.

regards,
Pablo
