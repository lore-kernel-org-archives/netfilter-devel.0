From: "Haitao Yu" <yuht@th-dascom.com.cn>
Subject: Re: FTP and connection tracking
Date: Tue, 17 Dec 2002 16:9:32 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200212171600984.SM01312@yht>
Mime-Version: 1.0
Content-Type: text/plain;
      charset="GB2312"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Hans Jorgensen <jorgensenhans@hotmail.com>,
 netfilter-devel@lists.netfilter.org <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

As I think, ftp nat's expected function is called twice when the first expected packet is in PREROUTING chain and POSTROUTING chain.

>Dear list
>
>I am currently developing an application which is using DNAT and 
>masquerading. First an incoming packet is DNAT'ed to have as specific dest. 
>ip. The it is masquerading when it is leaving the decided interface.
>
>This works fine, but when I use FTP, the following shows up in the kernel 
>log:
>
><4>ip_conntrack_in: related packet for c3a22310
><4>nat_expected: We have a connection!
><4>nat_expected: PASV cmd. 192.168.1.254->192.168.4.1
><4>nat_expected: IP to 192.168.4.1
><4>Found best for tuple c3d69db8: 6 10.0.0.8:1026 -> 192.168.4.1:11697
><4>nat_expected: We have a connection!
><4>nat_expected: PASV cmd. 192.168.1.254->192.168.4.1
><4>nat_expected: IP to 192.168.1.254
><4>Found best for tuple c3d69cf0: 6 192.168.1.254:1026 -> 192.168.4.1:11697
><4>Altering reply tuple of c3a22310 to tuple c3d69cd0: 6 192.168.4.1:11697 
>-> 192.168.1.254:1026
><4>Mangling c3ad4140: SRC to 192.168.1.254 1026
><4>Confirming conntrack c3a22310
>
>My question is:
>Why does: "We have a connection!" and the following lines show up two times? 
>Is the connection data traversing the same chain twice?
>
>Does anybody know where I can find more information on how the code in 
>connection tracking and NAT works?
>
>Thanks in advance.
>
>/Hans
>
>
>_________________________________________________________________
>STOP MORE SPAM with the new MSN 8 and get 2 months FREE* 
>http://join.msn.com/?page=features/junkmail

= = = = = = = = = = = = = = = = = = = =
			

				 
               Haitao Yu
               yuht@th-dascom.com.cn
					2002-12-17 
