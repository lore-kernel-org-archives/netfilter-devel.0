From: netfilter-devel@rtij.nl
Subject: Re: blocking/allowing particular protocol
Date: Wed, 17 Mar 2004 12:18:07 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <courier.405833EF.000032F7@ma.rtij.nl>
References: <0C674B14EAEBD61196D900B0D03DB49F01C1EA52@blrw502w.blr.infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: "'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <0C674B14EAEBD61196D900B0D03DB49F01C1EA52@blrw502w.blr.infineon.com>
To: "Kumar Shobhit (IFIN DC COM)" <Shobhit.Kumar@infineon.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Kumar Shobhit (IFIN DC COM) writes: 

> Hi,
> I am pretty new to all this stuff. I want to know if it is possible to
> block/allow a particular 
> protocol. For example, HTTP can work on various ports, So instead of
> blocking/allowing a particular port
> can I allow/block HTTP itself i.e to allow HTTP traffic on any port. 
> If yes, then please let me know the way to do it. I may have missed
> something in the iptables tutorial
> so any pointers will be a great help.

This is inherently a layer 7 problem, solving it at layers 3/4 may work 
somewhat but never reliably. Remember that iptables operates at the packet 
level, not at the stream level (which is the least you need for this). And 
even then, this is difficult to impossible. 

Think about it this way, when are you sure it is HTTP trafic? Not at 
connection setup, so you must allow the connection to be setup. Normally the 
first packet after that will contain some http command, but you cannot be 
sure of that. 

To allow http traffic, and nothing else, on a certain port one could use a 
transparent proxy. Squid can do this. To disallow http traffic, I probably 
would try to use snort with flexresp, make it abort the connection on well 
known http commands (but whatch out for false positives, it is not as easy 
as it sounds!) 

The only way to really do this sort of thing reliably is to set up a 
transparent proxy for every protocol you allow, possibly minus some trusted 
traffic (smtp to a smarthost f.i, when you trust either the source or the 
destination to only talk the correct protocol on that port). 

On a related note, even on traffic you do allow, lots of things can be 
tunnelled. My ISP even runs a sshd on some well known ports to facilitate 
those behind a proxy. Even if the proxy would check for an ssl handshake 
after a connect command (the start of https before it becomes encrypted), it 
is trivial to set up a ssl tunnel. IP-tunnels can even be build on DNS 
traffic! Disallowing specific protocols is a /hard/ problem. 

Anyhow, if you must solve this with iptables, have a look at the string 
match, but think very hard about false positives. A mail with a description 
of the http protocol ("client sends 'GET www.example.com/ HTTP/1.1'") should 
not be blocked but the same as a http request should. 

HTH,
Martijn Lievaart 
