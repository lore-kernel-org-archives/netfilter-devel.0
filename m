From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH] tcp window tracking patch with SACK support
Date: Fri, 18 Oct 2002 13:09:43 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0210181255170.10340-100000@blackhole.kfki.hu>
References: <20021017163909.GO344@pc.ilinx>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20021017163909.GO344@pc.ilinx>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

As it was reported several times on the mailing list, the tcp window
tracking patch could cause long SMTP delays in some cases.

After dumping a lot of traffic and replaying the streams it turned
out that the book-keeping inside the patch could go out of sync when SACK
was used. In another words, SACK was not supported by the patch and it
could cause legitimate packets to be blocked.

I have committed the new tcp-window-tracking.patch with SACK support in
the cvs.

It'd be very helpful if sites which experienced the long SMTP delays could
give a try to the new version of the patch and then send a report: 'yeah,
it's seems to be OK' or 'nope, still bad'. :-)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
