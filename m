From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: RFC: conntrack hash function comparison II
Date: Wed, 19 Feb 2003 12:40:56 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0302191233330.10818-100000@blackhole.kfki.hu>
References: <Pine.LNX.4.33.0301201113510.17671-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.33.0301201113510.17671-100000@blackhole.kfki.hu>
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

I have finished my second try to compare the candidate hash functions for
conntrack. The very short summary of my findings:

The best hashes are the jenkinks ones and the abcd64 hash. However

- the jenkins hashes work reliably for even hash sizes as well while
  the abcd64 hash doesn't
- the jenkins2b hash is a little bit faster than the abcd64 hash
- the strength of the abcd family is in the random coefficients
  while the strength of the jenkins family is in the algorithm. In
  another words, in the case of abcd hashes we should have to solve
  the problem of rehashing while there is no such thing for the
  jenkins hashes.

In my opinion we should adopt the jenkins2b hash for conntrack.

All the graphs and results can be found at

http://www.kfki.hu/~kadlec/sw/netfilter/ct2

The cttest package has been updated with the new hashes and the script
which created all the graphs and pages was added to the package as well.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
