From: Eduardo Costa <ecosta@tpk.com.br>
Subject: using libipq to create a router
Date: Tue, 23 Sep 2003 22:25:10 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F70C846.3090201@tpk.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi, there !

I want to create a little program to route connections with libipq and 
nat table.

Something like that: client connects with master server, but it will 
only route this connection to another computer.

Pretty simple, but I need this info to create something bigger. I tried 
to change the IP header packet, but somehow it only worked with ICMP. I 
guess it's a problem with nat/conntrack, but there's no example mixing 
conntrack and libipq.

BTW, I don't want to make a kernel module and a libipt_XXX.so, because I 
think it's a solution bigger than the problem.

Thanks in advance,
Eduardo Costa
