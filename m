From: Patrick Schaaf <bof@bof.de>
Subject: Re: Bug (?) in ipt_reject doesn't follow policy routing (2.4.x)
Date: Mon, 14 Apr 2003 09:59:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030414075933.GJ18520@oknodo.bof.de>
References: <Pine.LNX.4.21.0304132035370.31823-100000@debian.besselink>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Leen Besselink <leen@wirehub.nl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.21.0304132035370.31823-100000@debian.besselink>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

HiHo,

> OK, first the situation...
> 
> I use policy routing to decide (based on the from-address) on what
> out-interface to send a packet (and thus a different sender IP-address and
> gateway).
> 
> But... when I use reject-with tcp-reset, for a port on a host on the
> network behind my firewall, the tcp-reset-packet goes over the wrong
> interface.

I don't understand that description fully. Let's be more specific.
You have an outside host O, a policy router P, and an inside target T.
Further assume that O sends in packets on P.eth0, and T sits on P.eth1.

1) when O sends a packet to P, P will see a source-NATted address Q, right?
   If not, what did you mean with 'thus a different sender IP-address'?

2) is the reject-with-tcp-reset rule on P or T?

3) in the situation you describe, O tries to send to T?

4) when the RST goes out the wrong interface, what interface is that,
   and on what interface did the packet come in?

5) how do the source and destination IP addresses of that RST packet
   look at PREROUTING?

6) how do the source and destination IP addresses of that RST packet
   look at POSTROUTING / on the outgoing wire?

Maybe, if you can answer these questions, we'll be able to understand
your problem. Maybe somebody can do that even without those answers,
but the silence you received up to now indicates that's unlikely.

best regards
  Patrick
