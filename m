From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH] Per bucket conntrack hash locking patch in p-o-m
Date: Fri, 21 Nov 2003 12:43:00 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0311211226580.9127-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: jamal <hadi@cyberus.ca>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

I have added three patches to patch-o-matic/extra:

conntrack_arefcount.patch:
	The revision of the refcounting/locking in conntrack. First, the
	original methods was not perfect at all (see Patrick's efforts in
	cleaning it up...), secondly it did not make possible to
	introduce per bucket lockings at all.
	As an outcome of the revision, init_conntrack could be made a
	little bit faster (read-lock against expectations instead of
	write-locking).

conntrack_locking.patch:
	The patch implements per bucket locking in the conntrack
	hash. The only task remained for the ip_conntrack lock is
	to protect the protocol/helper lists :-).

conntrack_nonat.patch:
	The patch implements an optimization in the per bucket
	locking for the case when there is no NAT support compiled
	into the code.

Any comments are highly welcomed.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
