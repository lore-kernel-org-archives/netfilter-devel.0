From: "Costa Tsaousis" <costa@tsaousis.gr>
Subject: Re: Corruption on mangle/INPUT when MARKing packets
Date: Mon, 6 Jan 2003 15:13:22 +0200 (EET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <36676.195.97.5.193.1041858802.squirrel@fs.tsaousis.gr>
References: <37584.195.97.5.193.1041644841.squirrel@fs.tsaousis.gr>
        <20030106125230.GE9467@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-7
Content-Transfer-Encoding: 8bit
Cc: <laforge@gnumonks.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20030106125230.GE9467@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Harald Welte said:
> This is really strange.  I can perfectly reproduce the bug, but I cannot
> see how this happens.  the whole net/ipv4/icmp.c code doesn't do
> anything with the nfmark of the original skb.
>
> I'll have to investigate this further. Stay tuned.

Well, I don't think this is a problem in net/ipv4/icmp.c
If it was, setting the mark in PREROUTING should have the same effect, but
it does not.

So, my guess is that something is happenning in mangle/INPUT handling, or
due to the fact that the packet has changed after the routing decision, or
... (keep in mind that I have never seen the iptables code, so this is
really a guess out of nowhere...).

Kind regards

-- 
Costa Tsaousis

Author of
FireHOL (http://firehol.sf.net)
-------------------------------
An iptables stateful firewall generator,
that allows you to configure your firewall...
...the way you think of it!
