From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] netbios broadcast connection tracking module
Date: Tue, 26 Oct 2004 12:03:07 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0410261155500.18582@tux.rsn.bth.se>
References: <1098175785.6562.60.camel@greebo.homeip.net>
	<1098206621.1108.105.camel@tux.rsn.bth.se>
	<1098214482.6562.125.camel@greebo.homeip.net>
	<20041022105504.GC3551@sunbeam.de.gnumonks.org>
	<1098782757.6562.310.camel@greebo.homeip.net>
	<20041026094205.GM18934@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20041026094205.GM18934@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 26 Oct 2004, Harald Welte wrote:

> expectations are on a connection level, not on a per-packet level.
> However, broadcast packets don't have connections, since you send
> packets to .255 and receive them back from inidividual ip addresses.
> Since you don't know how many clients in the broadcast domain will
> reply, you need to re-create the expectation every time it is confirmed
> (via expectfn).

The reason I didn't suggest this is that it's racy on SMP machines.
It's a very small race but it does exist. Packets may get recieved
on another cpu between the expectation matching and it beeing re-created.

/Martin
