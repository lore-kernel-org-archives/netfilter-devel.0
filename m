From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: [RFC] Additional TCP Flags in the tcp module.
Date: Wed, 7 May 2003 17:20:06 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0305071710280.18335@dns.toxicfilms.tv>
References: <Pine.LNX.4.51.0305071216370.14343@dns.toxicfilms.tv>
 <20030507145852.GM6702@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20030507145852.GM6702@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> Not sure whether it would be useful. But I don't think that there is any
> danger associated with it (other than people use it in a wrong way, but
> then that's their problem).
:) Yes, the same as with the ecn match.

> However, we already have an ecn match, that matches IP and TCP flags...
Yes I know. I was just thinking of giving the tcp match full tcp-flags
matching capabilities as they are possible.

If someone wants to just account packets initiating ECN connections he
would:
# iptables ... -p tcp --syn -m ecn --ecn-tcp-cwr --ecn-tcp-ece -j ACCEPT

Which i think causes more overhead than:

# iptables ... -p tcp --tcp-flags ECN,CWR,SYN ECN,CWR,SYN -j ACCEPT

Because another matching module's match() is called.

Regards,
Maciej
