From: Willy Tarreau <willy@w.ods.org>
Subject: Re: [PATCH] modification in current protocol helper API to handle error/unclean packets
Date: Tue, 22 Jun 2004 18:18:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040622161829.GA22966@alpha.home.local>
References: <20040622043928.GA21406@alpha.home.local> <Pine.LNX.4.33.0406221440450.2546-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Henrik Nordstrom <hno@marasystems.com>, Pablo Neira <pablo@eurodev.net>,
   Martin Josefsson <gandalf@wlug.westbo.se>,
   Patrick McHardy <kaber@trash.net>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0406221440450.2546-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Jozsef,

On Tue, Jun 22, 2004 at 03:17:55PM +0200, Jozsef Kadlecsik wrote:
 
> In the second and third case you are unable to override the decision of
> conntrack on how it treated the packet. If you let trough the second
> category of the packet, it won't hurt. However, if the SYNs in the third
> case are dropped by your rule, then conntrack's attempt to do its job
> properly is defeated. In all case conntrack can log the packets.
> 
> What would be the purpose of the extension you propose? Logging is already
> supported if one wish to monitor such packets.

There are several uses to this :
  - being able to log *every* ignored packet with the same mechanism as the
    other ones (LOG, ULOG, QUEUE, ...). For that, the cleanest solution for
    the administrator would be a match. But indeed, it might not need to be
    a state match, but sort of a sub-state. Something like "ok, the packet
    is valid, but here are some precisions : it has been ignored".

  - being able to send a TCP RST for packets which don't belong to any
    session, and/or for those with invalid flags for the session state,
    but not for those which belong to a known session with bad sequence
    numbers. This would allow the firewall to help some hosts to close
    dead sessions without revealing anything about the configuration.

Something such as the following might sometimes be helpful :

----

# only log ignored SYNs but not ignored RSTs
iptables -A FORWARD -m state --state ESTABLISHED --reason IGNORED \
    -p tcp --syn -j LOG --log-prefix "Ignoring this SYN: "
# send an RST for session-less packets
iptables -A FORWARD -p tcp --flags RST NONE -m state --state INVALID \
    --reason NOSESSION -j send_reset
# send an RST for out-of-sync SYN/ACK packets
iptables -A FORWARD -p tcp --flags ALL SYN,ACK -m state --state INVALID \
    --reason BADFLAGS -j send_reset
# send an RST for out-of-sync ACK packets in SYN_SENT/SYN_RECV state
iptables -A FORWARD -p tcp --flags SYN,ACK,FIN,RST ACK -m state \
    --state INVALID --reason BADFLAGS -j send_reset
iptables -A send_reset -m limit --limit 100/s -j REJECT --reject-with tcp-reset
iptables -A send_reset -m limit --limit 10/s -j LOG --log-prefix "possible scan or old packet "
iptables -A send_reset -j DROP

----

These are all cases I encounter in production at a rate of about ten times a
second at the peak, and which could be greatly reduced if I had the ability
to tell the client that it's worthless retransmitting.

I know what Linus says, talk is cheap, show me the code... I have no code
for this, but since I have had this idea in mind now for a long time, I
might come up one day with a few lines, and I'd like to do it cleanly.

Regards,
Willy
