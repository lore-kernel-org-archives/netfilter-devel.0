From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: performance issues (nat / conntrack)
Date: Tue, 25 Jun 2002 10:00:47 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15640.41407.432907.402311@isis.cs3-inc.com>
References: <20020625151007.980D14140@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
In-Reply-To: <20020625151007.980D14140@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

 > From: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
 > I suppose that due to the load, packets are dropped not because of conntrack
 > but because they simply can't be processed, and thus conntrack misses packets
 > of existing connections (such as FIN, RST) and can't thus recover due to its 
 > timeouts.

But I believe that conntrack is exactly what's causing the load.  If
the machine is busy creating connections then it's clearly going to
lose packets.  I imagine that the packets that are dropped are those
arriving at full queues.  So fin's and rst's could very well be
dropped if they arrive on interfaces that are receiving lots of other
stuff while the cpu is busy building conntrack records.

 > From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
 > > We don't even need to have a full table to get into troubles. If at one
 > > point, the vast majority of the conntrack entries are unused, but still
 > > in hash, then you get more and more collisions, which decreases the
 > > hash efficiency.
 > 
 > What kind of collisions? Do you mean, that we end up in the same hash
 > entry and the linked list in the entry becomes too long? There is not much
 > wizardy we can do about it:

Not true.  See my proposed bucket size limit.  I hope to find some
formulae to post on this later.

 > - increase the hash size (i.e buy more RAM) if the hash is small
 > - create better hash function, if one can deliberately hit the same entry.
 > 
 > By the way, so far nobody has ever proved that the hash function is
 > not good enough.

I suspect the hash function is fine.  I propose to insert code that
does printk whenever a bucket size exceeds some threshold and then
invite all the readers of this list to try it and report their
results.  Obviously an attacker can arrange to attack one bucket,
but I think the solution is limiting the size of each bucket.
He still has no way of attacking a particular client/server pair or
a particular client or particular server.

 > > There's another side effect: when the system get's loaded (because of
 > > hash exhaustion or hash collisions), it can't process all packets arriving
 > > which means that conntrack will not see some FIN or RST packets allowing
 > > it to recover... This is a kind of 'vicious circle', or point of failure.
 > 
 > This is not true. If those FIN/RST packets belong to already existing
 > connections, then those are in the conntrack hash and data can be updated.
 > If those packets do not belong to an existing connection, then either they
 > can create a new entry and we are fine, or conntrack is full and the
 > packets will be dropped - we are fine again.

I think what happens is that it's not hash collisions but conntrack
record creation that takes a long time, and that pretty much all
packets are likely to be lost when the cpu is saturated with that
activity.  In that case it's true that connections are not garbage
collected as fast as they should be.

 > From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
 > If conntrack missed packets such a way, then the destination would miss as
 > well and the sender should resend them. No problem.

Other than the delay.  And if there's a high probability of drop then
you get multiple delays, with each delay being longer than the last.
