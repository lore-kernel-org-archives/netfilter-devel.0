From: Patrick McHardy <kaber@trash.net>
Subject: Re: libipq NAT causes RSTs
Date: Thu, 13 Dec 2007 18:26:48 +0100
Message-ID: <47616B58.1000300@trash.net>
References: <47614E80.9050504@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Thomas Egerer <thomas.Egerer@secunet.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <47614E80.9050504@secunet.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Thomas Egerer wrote:
> I'm currently (trying) to write a transparent proxy application, using
> libipq to capture packets + iptables' redirect mechanism.
> The basic idea works as follows:
> +---+      +---+      +---+
> | S |<---->| P |<---->| D |
> +---+ (1)  +---+  (2) +---+
> 
> (1) uses iptables' REDIRECT target; the received data is then forwarded,
>     using another socket connection (2)
> (2) uses libipq to do some kind of SNAT and change the local source
>     address to S's address and vice versa for the incoming packets
>     from D
> 
> So far the theory. The application works fine, as long, as I do not
> remap the source port (destination port, respectively) from P to D (2). Once
> I enable the port remapping I get
> a) syslog messages like the following:
>    [ 7742.939471] ip_rt_bug: [S' IP] -> [P's IP at (2)], ?
> b) RST packets from P towards D, using exactly all the correct TCP
>    settings, except for the destination port, (being 1, sometimes 2, or 3,
>    I couldn't figure out, why)
> 
> The three-way-handshake works fine, the RSTs are generated
> for the _first_ packet to contain a _TCP-payload_. Also netstat tells me,
> there is an established connection between P and D, but somehow (I
> assume that this might be the trouble) looking for the corresponding
> socket connection on P fails.
> I'm totally puzzled why that happens. libipq reinjects the packets with
> properly changed checksums and whatnot, yet the RSTs are generated.
> I've also tried NF_REPEAT, instead of the NF_ACCEPT verdict. The
> behavior remains identically.
> 
> Any ideas, anyone?


Most likely you're changing the source to a non-local address in
LOCAL_OUT, causing rerouting of the packet and resulting in an
input route instead of an output one. When dst_output is called
you hit ip_rt_bug, dropping the packet. When this is the first
packet of a connection, the connection tracking entry and
NAT mappings are destroyed. Not sure whats causing the RSTs
then, but its probably related to that.

Does changing:

         return ip_route_me_harder(skb, RTN_UNSPEC);

to

         return ip_route_me_harder(skb, RTN_LOCAL);

in net/ipv4/netfilter.c:nf_ip_reroute have any effect?
