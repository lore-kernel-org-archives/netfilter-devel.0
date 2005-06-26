From: John Que <qwejohn@gmail.com>
Subject: Checksum of IP header
Date: Sun, 26 Jun 2005 07:18:35 -0400
Message-ID: <ada605fb050626041856c71794@mail.gmail.com>
Reply-To: John Que <qwejohn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
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

Hello, 

I have the following problem

 I am developing a server with filtering capabilities.

       I had written a driver an I am using the netfilter API,
       using the nf_register_hook() and nf_unregister_hook() methods.

       In certain occasions , when getting UDP packets on certain ports,
       I change the IP address of the destination in the iphdr of the socket
       buffer. (sk_buff)

       Namely, what I change is :
               skb->nh.iph->daddr = newIPAddress (in u32 ).

       Everything works OK and the packets are sent to the new
       destination as I can see with the sniffer; except foo the csum.

       I see in the sniffer that the csum of the ip header is wrong.

       I tried to look in the /net/core and /net/ipv4/netfilter
folders  to see which
 csum methods to use.
       There are plenty of methods: just for example , in skbuff.c there is
skb_checksum(),
       skb_copy_and_csum_bits(),skb_copy_and_csum_dev(),
 and more; in ip_nat_core there is
ip_fast_csum(),csum_partial(),ip_compute_csum(),
 and more. So I am quite confused.

 I am not an expert on csum and nat , but this seems to me a task
that had been
 done somewhere in the nat code (because as I understand part of what nat
 does is change the source ip addresses).

 I made some tries but did not find a solution - all my tries ended in seeing a
 wrong csum in the ip header with the sniffer.

(I know that I can set the csum to 0 but I don't want to do it ).

 Any ideas ?

 Regards,
 John

  ReplyForward
		
		
YOSHIFUJI Hideaki / 吉藤英明 	
: > I see in the sniffer that the csum of the ip header is wrong. : > I made ...
	 	  4:59 am (2 hours ago)
		
John Que 	
to YOSHIFUJI Hide., netdev
	 More options	  5:55 am (1 hour ago)
Thnks;

  As I said I am sure that in the code somewhere there is
a method which does this but I cannot locate it because there
are many csum methods.

 If anybody knows a scenario like mine and can advice me
as to which methods to use it will be helpful.

John
