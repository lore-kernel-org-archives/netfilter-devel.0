From: Ilguiz Latypov <ilatypov@infradead.org>
Subject: Re: Transparent broadband network connectivity (IP PnP)
Date: Thu, 13 Mar 2003 13:18:28 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0303131312340.30700-100000@localhost.localdomain>
References: <20030313090821.GA7053@naboo.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: dragon_nlt@yahoo.com,
    Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030313090821.GA7053@naboo.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


On Thu, 13 Mar 2003, Harald Welte wrote:

> A broken setup like you describe breaks about any of the fundamental
> assumptions of a working IP network. (and of layering in a network)

Not to start a flame war, but I think the only missing part in that
"broken" network topology was the automatic addition/removal of host
routes on the gateway pointing to eth0 for any packets destined to the
clients' IP addresses.

SNAT-ting would still be required, as it was shown in the original
message.

--
Ilguiz Latypov
Net Integration Technologies, Inc

tel. +1 (514) 281 9191 x 117
