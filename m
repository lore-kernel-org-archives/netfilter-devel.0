From: Patrick Schaaf <bof@bof.de>
Subject: Re: target MARK in filter table?
Date: Tue, 15 Jul 2003 07:16:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030715051650.GA6710@oknodo.bof.de>
References: <20030714080503.GE6538@naboo> <Pine.LNX.3.95.1030715080541.10486A-100000@cannabis.dataforce.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Poltorak Serguei <poltorak@df.ru>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.3.95.1030715080541.10486A-100000@cannabis.dataforce.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jul 15, 2003 at 08:26:17AM +0400, Poltorak Serguei wrote:
> ;The idea is to have targets for filtering in the filter table - and
> ;anything that modifies the packet [or potentially affect other kernel
> ;subsystems such as policy routing] in 'mangle'.
> And if I'm using fwmark mechanism not to change packet, but to
> mark it and remember that this one I need to treat differantly.
> 
> May be you know a better way to do it...

The workaround that I used in some situations, was to create suitable
classification chains at mangle/PREROUTING, which set MARK values,
and then consistently match these marks in the filter table, instead
of using various criteria directly.

It is a bad workaround, because it complicates the ruleset by one layer.
In the filter table, I can no longer locally see _when_ something is done,
only _what_ is done; for the full picture, I have to jump back and forth
between reading filter and mangle chains.

This is bearable, but not really nice.

> I think fwmark is very usefull not only with routing and qos to tell what
> to change/mangle/nat/... It makes iptables more programmable :)

Exactly my feeling.

best regards
  Patrick
