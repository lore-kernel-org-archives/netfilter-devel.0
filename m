From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: [RESEND] [PATCH] Additional Check to Unclean module
Date: Tue, 14 Jan 2003 19:55:27 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0301141954130.1451@dns.toxicfilms.tv>
References: <Pine.LNX.4.21.0208062014170.20336-200000@dns.toxicfilms.tv>
 <Pine.LNX.4.21.0208081943090.6794-200000@dns.toxicfilms.tv>
 <20030114163725.GD18686@sunbeam.de.gnumonks.org> <20030114170531.GE18686@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20030114170531.GE18686@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> erm, no need for this patch.  The IP version is already checked in the
> core IPv4 stack, and ip_tables would never receive a non-ipv4 packet
> anyway.
Yes, routers and hosts should discard it silently. But it would if the
packet originated from the host.
I had matches of these packets and logged them.
But that was 6months ago, or so. I would have to check that again.

Maciej
