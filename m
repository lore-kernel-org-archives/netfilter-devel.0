From: Matteo Croce <rootkit85@yahoo.it>
Subject: Re: UNWANTED state
Date: Fri, 31 Dec 2004 14:15:53 +0100
Message-ID: <200412311415.53465.rootkit85@yahoo.it>
References: <200412300042.18561.rootkit85@yahoo.it>
	<200412300139.49266.rootkit85@yahoo.it>
	<20041231055657.GA3759@alpha.home.local>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20041231055657.GA3759@alpha.home.local>
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

> In other terms, you would then do something like this :
> 
> -A INPUT -m state ESTABLISHED -j ACCEPT 
> -A INPUT -m state RELATED -p tcp --dport 113 -j REJECT --reject-with tcp-reset
> -A INPUT -m state RELATED -j ACCEPT
> ... check for new connections here then final drop ...
> -A INPUT -j DROP
> 
> A last solution would be the RECENT match. You create an entry when
> establishing the outgoing session, and you match against it in return so that
> only this address has the permission to receive a REJECT.

here is my iptables -L output:

Chain INPUT (policy ACCEPT)
target     prot opt source               destination
DROP       all  --  anywhere             anywhere            state INVALID,UNTRACKED
DROP       icmp --  anywhere             anywhere            icmp echo-request
REJECT     tcp  --  anywhere             anywhere            tcp dpt:auth reject-with icmp-port-unreachable

Chain FORWARD (policy DROP)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
DROP       tcp  --  anywhere             anywhere            tcp flags:FIN,SYN,RST,PSH,ACK,URG/RST,ACK

Add the patch that doesn't respond on closed udp ports with an ICMP, and i have
the system sthealted with only 3 rules.
But I also know that the kernel patch and the rule that drops RST/ACKs are very ugly hacks.
Don't forget that this ugly hack works even for loopback!

> You know, it's enough that you have *one* open port for an attacker to be
> able to do this, be it SMTP, HTTP, SSH, or anything else...

Yes, but in most tipical end-user systems, open ports will be only:
20 for non PASV ftp transfers
some ports for IRC's DCC transfer
some ports for P2P apps

These ports are open only when needed, and (apart for p2p)
the program that opens them accepts only one connection.
So is almost impossible being DOSsed whit traffic on port 20 or so..


> Regards,
> Willy

Regards,
Matteo

-- 
  .""`.     Matteo Croce <rootkit85@yahoo.it>
 : :"  :    proud Debian admin and user
 `. `"`
   `-  Debian - when you have better things to do than fix a system
