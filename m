From: Patrick Schaaf <bof@bof.de>
Subject: Re: target MARK in filter table?
Date: Sun, 13 Jul 2003 09:02:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030713070203.GA1284@oknodo.bof.de>
References: <Pine.LNX.3.95.1030713053210.10817A-100000@cannabis.dataforce.net> <Pine.LNX.3.95.1030713055808.11842C-100000@cannabis.dataforce.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Poltorak Serguei <poltorak@df.ru>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.3.95.1030713055808.11842C-100000@cannabis.dataforce.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> Why not to allow MARK packets in filter table? As i know it doesn't mangle
> (change) the packet, it changes only information about it on local this
> router. So, why not to use it widely in filter table?

The fwmark influences the routing decision. In the filter table, the
routing decision has already been made. This raises the following
decision problem;

- should rerouting be done when MARK is used in the filter table
- or not?

This decision problem will have different answers for different uses.
Thus, an implementation must make an arbitrary decision.

How would _you_ make that decision?

I have no idea if that is the real reason why nobody made MARK for filter,
but to me, it's a good reason not to make it. Arbitrary decisions always
bite you, later.

Traditional counterquestion: what do you want to accomplish, that lets
you look for MARK in filter?

best regards
  Patrick
