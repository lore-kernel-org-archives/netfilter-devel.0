From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH]: invaild TCP/UDP matching when ipv6 extension header exists
Date: Sat, 31 Jan 2004 15:49:32 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401310649.PAA00050@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
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


Hi,

tcp_match() and udp_match() in ip6tables.c assume that previous header
of TCP/UDP header is IPv6 Header. So, for example, 1st of fragmented UDP
packet, AHed packets can't correctly match the rules which use
"--sport" and so on.

This patch use ipv6_skip_exthdr() . But this function has the bug which
access invalid memory area when found Fragment Header.
So this patch includes the change for that, too.

Regards,

----------------------------------------
Yasuyuki KOZAKAI

Communication Platform Laboratory,
Corporate Research & Development Center,
Toshiba Corporation

yasuyuki.kozakai@toshiba.co.jp
----------------------------------------

Subject: (usagi-users 02784) about fragment (ip6tables)
From: ques_hiro@hotmail.com
Date: Tue, 27 Jan 2004 01:12:45 +0000

> Hello Users Group,
> 
> >From contents which are asked here, although it may not be, I need your 
> help well.
> 
> There is a question about the filtering method of fragment pachet using 
> ip6tables.
> 
> A and B prepare two PCs, the command of ip6tables of the following [ B ] is 
> 
> struck, 
> and 4000 bytes of UDP packet (address port number 1025) is sent from A to 
> B.
> 
> (PC_B) %ip6tables -A INPUT -p udp -m frag --dport 1025 -j DROP
> 
> In this environment, since MTU was 1500 bytes, the packet was 
> fragmentation-ized by  three, and all the packets reached and 
> carried out to B.
> 
> Then, although it is a question, since there is information on a port 
> number in the 
> first fragmentation-ized packet, although it thinks that it is filtered and 
> 
> two of  succession pass, why is it?
> 
> Is it the specification which cannot use the frag option and the port 
> option together?
> 
> If there is a person who knows, I will advice-wish-do.
> 
> _________________________________________________________________
