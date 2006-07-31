From: benjamin wagrocki <benjamin.wagrocki@gmx.de>
Subject: getting wrong ports from tcph->dest
Date: Mon, 31 Jul 2006 19:13:29 +0200
Message-ID: <44CE3A39.5050405@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

Hello,

I am hoping, that this is the right place for asking this question. If 
not, please tell my, where I can find help for my problem.

I am writing a kernel modul, which connects to the netfilter hooks . 
This modul is ought to take over the firewalling. I am doing this just 
for educational purpose.  My  problem  now is; I am not getting the  
correct  tcp/udp  destination and  source ports.  For instance when I 
start "wget localhost" my kernel modul is showing the right ports. If I 
do that  from a remote host, the kernel modul shows always dport=48 
independent of the real  dport  the remote host is trying to connect to  
(port 80 or 81...)

Here is what my kernel modul displays to /var/log/messages:

wget localhost:
-------------------

DROPPED: SRC: 127.0.0.1 : 55732  DST: 127.0.0.1 : 80  IPv: 4  Prot: 6  
Frag: 64 TTL: 64 TOT_LEN: 44
DROPPED: SRC: 127.0.0.1 : 17664  DST: 127.0.0.1 : 44  IPv: 4  Prot: 6  
Frag: 64 TTL: 64 TOT_LEN: 44
DROPPED: SRC: 127.0.0.1 : 80  DST: 127.0.0.1 : 55732  IPv: 4  Prot: 6  
Frag: 64 TTL: 64 TOT_LEN: 40
DROPPED: SRC: 127.0.0.1 : 17664  DST: 127.0.0.1 : 40  IPv: 4  Prot: 6  
Frag: 64 TTL: 64 TOT_LEN: 40

//I am also not unterstanding, why four packets have been generated and 
not just two?

remote (winxp-firefox connecting to port 80):
DROPPED: SRC: 192.168.198.97 : 17664  DST: 192.168.198.1 : 48  IPv: 4  
Prot: 6  Frag: 64 TTL: 128 TOT_LEN: 48

remote (connecting to port 443):
DROPPED: SRC: 192.168.198.97 : 17664  DST: 192.168.198.1 : 48  IPv: 4  
Prot: 6  Frag: 64 TTL: 128 TOT_LEN: 48

There is no difference and the ports are wrong, why?

My kernel modul is running on Fedora 4, could this be the reason? I 
already turned off the SELinux extension, but this didn't help.

Here some relevant code parts:
struct sk_buff *skb = *skb_p;
struct tcphdr *tcph = skb->h.th;
unsigned int sport;
unsigned int dport;
...
sport = convert_port(tcph->source);
dport = convert_port(tcph->dest);
...
printk("\033[31m DROPPED: SRC: %u.%u.%u.%u : %u  DST: %u.%u.%u.%u : %u  
IPv: %u  Prot: %u  Frag: %u TTL: %u TOT_LEN: %u \033[30m \n"
       
,saddr.ipbyte[0],saddr.ipbyte[1],saddr.ipbyte[2],saddr.ipbyte[3], sport, 
daddr.ipbyte[0],daddr.ipbyte[1],daddr.ipbyte[2],daddr.ipbyte[3],
       dport, iph->version, iph->protocol, iph->frag_off, iph->ttl, 
totallength);

-- 
Best regards,
-Benjamin Wagrocki-
