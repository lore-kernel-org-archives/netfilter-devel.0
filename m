From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH] nf-log and raw patch fixes
Date: Mon, 29 Sep 2003 11:54:35 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0309291130280.2237-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald,

I have committed the new nf-log and raw patches in the cvs.

pending/40_nf-log.patch:
	- It hasn't got an userspace part anymore.

userspace/raw.patch:
	- The userspace part can safely be applied, the patched source
	  will compile even with non-raw kernels.
	- The fragmentation bug with untracked packets reported on
	  netfilter-devel is solved by forcing defragmentation when
	  the NOTRACK target is in use. The NOTRACK target depends
	  on ip_conntrack (already did), and ip_conntrack_in is split
	  into two parts: defragging and connection tracking. For
	  the defragging part of conntrack a new priority is introduced,
	  which precedes the raw table. Thus in the raw table (when
	  conntrack/NOTRACK is used) we see full packets only.
	- I removed the checking for already existing connections
	  in the NOTRACK target.
	- The handling of TRACEd packets is improved, so that there is
	  no performance penalty just by compiling in the support.
	  It required introducing two new fields in ip[6]t_entry for
	  storing the pointer to the chainname and a rulenum value.
	  I think this makes the target really useful. Until now
	  the general suggestion was not to compile in the TRACE target
	  into an in-production kernel due to the overhead, but that
	  prevented the checking of real life rules. From now on one
	  can compile in, switch on/off tracing without performance
	  penalty (not counting producing the logs, but that's
	  unavoidable).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
