From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: Re:help
Date: Sun, 09 Mar 2003 09:59:28 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200303082359.h28NxVd08405@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <kalpesh@kalupurbank.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


The other thing you may be missing is ident ....


----- Original Message -----
>From: <kalpesh@kalupurbank.com>
>To: <netfilter-devel@lists.netfilter.org>
>Subject:  help
>Date: Sat, 08 Mar 2003 11:40:17 +0530
>
> help
> 
> Slow respose after using IPTABLES
> 
> Hi all,
> My mail server is runnig on Redhat 7.2 with Sendmail.
> Now I want to use IPTABLES for the Security Point of view. For this I made
> test server and implemented IPTABLES on it. But after using IPTABLES
> respose from the server is SLOW  when i use POP3 clients but it works.
> 
> I am using following script.
> 
> # Deny All
> 
> /sbin/iptables -P INPUT DROP
> /sbin/iptables -P FORWARD DROP
> /sbin/iptables -P OUTPUT DROP
> 
> # Local host
> 
> /sbin/iptables -A INPUT -s localhost -d localhost -j ACCEPT
> /sbin/iptables -A OUTPUT -s localhost -d localhost -j ACCEPT
> 
> # ICMP
> 
> /sbin/iptables -A INPUT -s $INTRANET  -d $MYHOST -p icmp -j ACCEPT
> /sbin/iptables -A OUTPUT -s $MYHOST -d $INTRANET  -p icmp -j ACCEPT
> 
> 
> # SMTP
> 
> /sbin/iptables -A INPUT -s $INTRANET -d $MYHOST -p tcp --dport smtp    -j
> ACCEPT
> /sbin/iptables -A OUTPUT -s $MYHOST -d $INTRANET -p tcp --sport smtp   -j
> ACCEPT
> 
> # POP3
> 
> /sbin/iptables -A INPUT -s $INTRANET -d $MYHOST -p tcp --dport pop3    -j
> ACCEPT
> /sbin/iptables -A OUTPUT -s $MYHOST -d $INTRANET -p tcp --sport  pop3   -j
>   ACCEPT
> 
> Any suggestions ? help ? Please
> 
> with warm regards
> 
> kalpesh
> 
> 
> 
> 

--
Ian Latter
Internet and Networking Security Officer
Macquarie University
