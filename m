From: Willy Tarreau <willy@w.ods.org>
Subject: Re: UNWANTED state
Date: Fri, 31 Dec 2004 06:56:57 +0100
Message-ID: <20041231055657.GA3759@alpha.home.local>
References: <200412300042.18561.rootkit85@yahoo.it>
	<20041229235657.GA11573@linuxace.com>
	<200412300139.49266.rootkit85@yahoo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Matteo Croce <rootkit85@yahoo.it>
Content-Disposition: inline
In-Reply-To: <200412300139.49266.rootkit85@yahoo.it>
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

On Thu, Dec 30, 2004 at 01:39:48AM +0100, Matteo Croce wrote:
> > On Thu, Dec 30, 2004 at 12:42:17AM +0100, Matteo Croce wrote:
> > Perhaps you should consider using:
> >
> > --dport 113 -j REJECT --reject-with tcp-reset
> > instead of hacking the kernel to disable icmp rejects?
> >
> 
> # iptables -I INPUT 1 -p tcp --dport 4567 -j REJECT --reject-with tcp-reset
> # hping3 127.0.0.1 -p 4567 -S
> HPING 127.0.0.1 (lo 127.0.0.1): S set, 40 headers + 0 data bytes
> len=40 ip=127.0.0.1 ttl=255 DF id=0 sport=4567 flags=RA seq=0 win=0 rtt=0
> 
> 
> --reject-with tcp-reset sends RST/ACK that are dropped by my firewall

it seems to me that you forgot to add the following rule for the RST packet
to go out :

# iptables -I OUTPUT -m state --state ESTABLISHED -j ACCEPT

Regards,
willy

> > Why do you care if people get an icmp unreachable when
> > the service is down?  You aren't making the box more secure IMO by not
> > allowing the icmp error outbound.
> 
> Tryng to reduce at minimum unneeded traffic is a sort of protection against 
> DOS.

Normally, you should be able to do most of this by checking for ESTABLISHED
and RELATED states. I don't know if there is a relation between your port 113
and the service you're using, but I believe that a cleaner solution would be
to add this relation to the conntrack helper associated to your particular
service.

In other terms, you would then do something like this :

-A INPUT -m state ESTABLISHED -j ACCEPT 
-A INPUT -m state RELATED -p tcp --dport 113 -j REJECT --reject-with tcp-reset
-A INPUT -m state RELATED -j ACCEPT
... check for new connections here then final drop ...
-A INPUT -j DROP

A last solution would be the RECENT match. You create an entry when
establishing the outgoing session, and you match against it in return so that
only this address has the permission to receive a REJECT.

> Let's say i have a 4096/400 ADSL.
> Someone with a ~512kbit upload can send me an large amount of data on a closed 
> port with something like 'hping3 <IP> -S -p <PORT> --flood', and my 400kbit 
> upload
> will be unable to send 512Kbit of RST/ACKs.

You know, it's enough that you have *one* open port for an attacker to be able
to do this, be it SMTP, HTTP, SSH, or anything else...

Regards,
Willy
