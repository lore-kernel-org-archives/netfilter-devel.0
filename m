From: Patrick Schaaf <bof@bof.de>
Subject: Re: PATCH: extra conntrack stats
Date: Fri, 25 Apr 2003 10:23:42 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030425082342.GF6439@oknodo.bof.de>
References: <200304192142.h3JLg1S03466@fokkensr.vertis.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rolf Fokkens <fokkensr@fokkensr.vertis.nl>
Content-Disposition: inline
In-Reply-To: <200304192142.h3JLg1S03466@fokkensr.vertis.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Rolf,

first of all: thanks for doing that work!

> This patch adds a little statistical information to the connection tracking:
> the number of packets and bytes that have gone throught each connection.
> 
> We've been using the connection tracking info so far to count concurrently
> connected users on an Oracle environment. Now our customer would like us to
> measure the size of print jobs and the nunmber of print jobs - this patch may
> be an option for us. Of course one can also measure other kinds of traffic.
> 
> It might even be possible now to limit the amount of data that has gone 
> throught a connection by implementing other targets.

It could be useful if you add a suitable minimal match, for demonstration.

> Well, it's a small patch that may not do any harm and please some people.

I don't think the normal processing takes a WRITE_LOCK(&ip_conntrack_lock)
for each and every packet. Thus, your patch will have a performance
impact under high packet load.

Another pitfall is the 'unsigned long' nbytes: I'm sure I'm not the
only one who has TCP connections transporting more than 4GB, so that
counter will overflow in practise. It would be better to make it
64 bit from the start. 'unsigned long long' and '%Lu' work in the
kernel, as far as I know.

That aside: nice work, nice minimal addition. I urge the core team
to evaluate this (and earlier) approaches. The general idea to have
per-conntrack usage information, is very powerful.

Teaser: "log me the first five packets of each HTTP connection".

best regards
  Patrick
