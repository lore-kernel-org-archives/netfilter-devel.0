From: LAAROUCHI Youssef <laarouchi_yous@yahoo.fr>
Subject: Iptables and kernel modules
Date: Fri, 1 Jul 2005 02:41:15 +0200 (CEST)
Message-ID: <20050701004115.34697.qmail@web26507.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: laarouch@enseirb.fr
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi,

I've created a kernel module to modify the format of
exchanged IP packets... This module is correctly inserted
into the kernel. I then want to make this module receive
the packets by using the following command :

#iptables -t mangle -A INPUT -p icmp --icmp-type 38 -j 
puzClient

This command returns an error asking for .so file... The
problem is that I don't know the format of .so files.. I
have generated one .so file by adding -shared in the link
command, but it doesn't solve the problem. I have undefined
symbols error.

So can you specify to me how the .so files are generated ?
and what is the necessary format to generate a ipt_target
so file. And eventually, can we make iptables working
directly  with kernel modules without using .so files  ? ? 

Thanks,

Youssef


	

	
		
___________________________________________________________________________ 
Appel audio GRATUIT partout dans le monde avec le nouveau Yahoo! Messenger 
Téléchargez cette version sur http://fr.messenger.yahoo.com
