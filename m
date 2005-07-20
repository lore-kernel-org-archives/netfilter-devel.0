From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: SACK out of window segments?
Date: Wed, 20 Jul 2005 12:34:02 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0507201213110.25054@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Miller <davem@davemloft.net>
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

Hi Dave,

There had been a long thread on netfilter-devel recently with the subject
[PATCH] TCP window tracking patch backported from the 2.6 tree:

https://lists.netfilter.org/pipermail/netfilter-devel/2005-June/020281.html
https://lists.netfilter.org/pipermail/netfilter-devel/2005-June/020279.html
https://lists.netfilter.org/pipermail/netfilter-devel/2005-June/020317.html
https://lists.netfilter.org/pipermail/netfilter-devel/2005-July/020292.html
https://lists.netfilter.org/pipermail/netfilter-devel/2005-July/020349.html
https://lists.netfilter.org/pipermail/netfilter-devel/2005-July/020350.html

It seems that at least Linux 2.4.25 accepts and (S)ACKs segments which
otherwise looks to be out of window ones. In order to cope with that I had
to add code to the TCP connection tracking part of netfilter.

The question is wether that was a SACK bug in 2.4.25? Or there's something
in the RFCs we overlook and what looks like a violation is actually an RFC
conformant feature?

Thank you your help,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
