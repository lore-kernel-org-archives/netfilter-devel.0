From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Unable to receive data Netlinks sockets
Date: Thu, 25 Mar 2004 10:28:07 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4062A627.3070002@eurodev.net>
References: <s06214ce.076@prv-mail25.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Swaroop Ashish <sashish@novell.com>,
 netfilter-devel@lists.netfilter.org
In-Reply-To: <s06214ce.076@prv-mail25.provo.novell.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Swaroop Ashish wrote:

> I want to write a test program to
>receive all the packets recieved on the system via this test program
>using Netlinks sockets.  Can anyone please tell me what is wrong in the
>following program and what configuration/rules should be added to
>Iptables to do the same.
>  
>

if you want to play around with ip_queue, the module which let you send 
packets from kernel space to user space and vice-versa, you *should* use 
libipq instead of using raw netlink sockets, please have a look at 
libipq available in iptables source code.

regards,
Pablo
