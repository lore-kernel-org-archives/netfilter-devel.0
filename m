From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Per bucket locking patches updated
Date: Tue, 1 Jun 2004 11:02:11 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406011021290.4755-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

The per bucket locking patches (conntrack_[arefcount|locking|nonat]) in
patch-o-matic-ng cvs has been updated: a nasty NAT related bug has been
fixed in arefcount and the nonat case has been revised. Thanks to Willy
for the NAT bugreport and to Patrick for pointing out the problems with
the nonat patch.

A short summary of the features, modifications in the patches:

- The refcount patch prepares the introduction of
  per bucket conntrack locking by separating expectation
  locking completely off from conntrack locking. That means
  a new global lock is introduced (ip_conntrack_expect_lock)
  which protects the global and local expectation lists
  and entries. When ip_conntrack_expect_lock is read-locked,
  the ip_conntrack_expect_tuple_lock is used to protect the
  tuples in the expectations, because the tuples may be changed
  by NAT.
  Besides the new lock, reference counting is formalized so that
  an expectation holds a reference count on its creator, and an
  expected connection holds a reference count on the expect.
  The former was missing from conntrack, which made life much
  harder when deleting conntrack entries. (See the fixes
  sent to the list by Pablo and others just because of this...)

- The locking patch introduces per bucket locking. Because
  conntrack entries are added to the conntrack hash in both
  directions, we have to apply double-locking, in a strict
  order. Couple of inline functions are added to simplify
  locking based on a given conntrack entry or a given key.
  In order to avoid hash key recalculations, the keys are
  added to the conntrack structure.

- The nonat patch is an optimization on top of locking patch
  for the conntrack-only case, when the tuples of a conntrack
  don't change. It adds a conntrack entry to the hash only
  once by calculating the hash key independently of the direction,
  which means the number of the entries in the hash is halfed and
  single bucket-locking is enough. ip_conntrack_expect_tuple_lock
  is also completely removed in the optimization.

The patches are based on Rusty's conntrack related patches and Patrick
Schaaf's patches, suggestions.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
