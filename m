From: Pablo Neira <pablo@eurodev.net>
Subject: Re: problem with conntrack utility and kernel 2.6.14
Date: Tue, 01 Nov 2005 21:07:58 +0100
Message-ID: <4367CB1E.8080407@eurodev.net>
References: <4361EAAB.1090206@fliegl.de> <4361F6DF.3050106@eurodev.net>
	<43621028.40705@fliegl.de> <43627A8F.9060307@eurodev.net>
	<436281BB.2010100@fliegl.de> <436373E8.7040606@eurodev.net>
	<436398C7.4070402@fliegl.de> <4365A097.1080001@eurodev.net>
	<Pine.LNX.4.62.0510310911090.9468@bizon.gios.gov.pl>
	<4366C031.6020504@eurodev.net>
	<Pine.LNX.4.63.0511011116550.3512@bizon.gios.gov.pl>
	<436773EB.6000608@eurodev.net>
	<Pine.LNX.4.63.0511011605010.12220@bizon.gios.gov.pl>
	<43679A3B.6070009@eurodev.net>
	<Pine.LNX.4.63.0511011747370.15256@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080504020208050703080203"
Cc: Deti Fliegl <deti@fliegl.de>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.63.0511011747370.15256@bizon.gios.gov.pl>
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

This is a multi-part message in MIME format.
--------------080504020208050703080203
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Krzysztof Oledzki wrote:
>> That is what it currently does, are you observing a different behaviour?
> 
> Unfortunately :(
> 
>> # conntrack -D --orig-src 1.1.1.1 --orig-dst 2.2.2.2 -p tcp 
>> --orig-port-src 2005 --orig-port-dst 21
>> NFNETLINK answers: No such file or directory
>> Operation failed: such conntrack doesn't exist
> 
> # conntrack -L -i|grep 192.168.130.123
> udp      17 20 src=192.168.0.33 dst=192.168.130.123 sport=123 dport=123 
> packets=1 bytes=76 src=192.168.130.123 dst=192.168.0.33 sport=123 
> dport=123 packets=1 bytes=76 mark=0 use=1 id=13157
> 
> root@olemx:~# conntrack -D --orig-src 192.168.0.33 --orig-dst 
> 192.168.130.123 -p udp --orig-port-src 123 --orig-port-dst 123 -i 90909

Fixed in SVN.

> # conntrack -L -i|grep 192.168.130.123
> (empty)
> 
> # conntrack -D --orig-src 192.168.0.33 --orig-dst 192.168.130.123 -p udp 
> --orig-port-src 123 --orig-port-dst 123 -i 90909
> NFNETLINK answers: No such file or directory
> Operation failed: sorry, you must be root or get CAP_NET_ADMIN 
> capability to do this

This error message is related with libnfnetlink, give a try to the patch 
attached. It fixes it. I'll pass it to Harald.

-- 
Pablo

--------------080504020208050703080203
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: src/libnfnetlink.c
===================================================================
--- src/libnfnetlink.c	(revision 4416)
+++ src/libnfnetlink.c	(working copy)
@@ -462,7 +462,7 @@
 					}
 					perror("NFNETLINK answers");
 				}
-				return -1;
+				return err->error;
 			}
 			if (answer) {
 				memcpy(answer, h, h->nlmsg_len);

--------------080504020208050703080203--
