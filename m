From: Patrick Schaaf <bof@bof.de>
Subject: Re: icmp hdr incorrect in skbuff
Date: Mon, 11 Nov 2002 09:14:35 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021111081435.GA336@oknodo.bof.de>
References: <20021111074147.GA29344@fork.triblock.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20021111074147.GA29344@fork.triblock.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> (*skb)->h.icmph->type

Where did you get the idea that h.icmph would be set sensibly
inside netfilter hooks? What hook, exactly, are you talking
about? Your description doesn't say that clearly, and it could
be crucial to know.

My gut guess would be that h.icmph would only be set correctly when
the icmp parts of the Linux network stack had their hands on the
skbuff under inspection.

In other words, I would expect it to be valid only for echo replies
sent by the machine itself.

Conceptually, to me, the netfilter hooks used by iptables sit
at the IP layer. Access to other layers must be implemented
locally in iptables match/target code, by working up from
the IP header (or down, to get at L2 framing, if that exists).

Hope this helps. If I'm not talking sense, somebody shoot the argument.

best regards
  Patrick
