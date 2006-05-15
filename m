From: Amin Azez <azez@ufomechanic.net>
Subject: iptables modules efficiency, caching in conntrack
Date: Mon, 15 May 2006 16:22:30 +0100
Message-ID: <e4a6bo$evh$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

I've done work with a few iptables modules, conntrack, ipt_recent,
ipt_account (recently) and others.

The design usually consists of a module specific storage using some
aspects of the connection or packet as a key to the storage.

For each packet, each module calculates the key, fetches and locks the
storage record, makes decisions and updates, unlocks and continues.

I also notice a similarity between many modules, ipt_set, ipt_recent,
ipt_account, and think how much space and time is used less efficiently
when more than one of these are used together.

This is tending me to merge functionality. I have just merged connrate
with ipt_account. (Expect patches soon.)

Arguably rate limiting is a function of per-ip accounting, arguably it
is not; however my point is this:

The one main storage element which is already looked up is conntrack.
If the conntrack record had an array of extra (ref-counted pointers)
then other modules would just need calculate keys and create/lookup
records from their own storage once, and keep a reference in the conntrack.

Slots in this conntrack array would be allocated, so a module might get
to keep slot 0, and the next module to request a slot would get slot 1, etc.

Let these slots be dynamicly growable, or use some other means, it
doesn't matter as long as it is faster than each module looking up its
storage the long way around.

This gives us faster storage lookups for other modules, which is important.

Its a small step from there to provide callbacks for each module when
the conntrack is destroyed, in case the associated per-module structure
needs destroying.

If beneficial, its also a small step for one module to tag extra data on
to another modules storage too; ipt_account is practically a superset of
ipt_set anyway (except in the meaningful way of actually saying if an ip
is in the set, but its nearly there...)

Currently the closest we get to this is hard-wired if-def's to add slots
to a conntrack so that they CAN be used at runtime if needed.

So this suggestion would speed up many modules, as well as potentially
reduce the size of the conntrack struct.

Comments?

Sam
