From: "Nicolas Bouliane" <nib@cookinglinux.org>
Subject: Re: [testsuite] ipt_tos
Date: Mon, 20 Dec 2004 01:20:26 -0500 (EST)
Message-ID: <33003.66.11.161.14.1103523626.squirrel@66.11.161.14>
References: <32914.66.11.161.14.1103516524.squirrel@66.11.161.14>
Mime-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20041220012026_31529"
Cc: netfilter-devel@lists.netfilter.org, sjean@cookinglinux.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <32914.66.11.161.14.1103516524.squirrel@66.11.161.14>
To: rusty@rustcorp.com.au
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

------=_20041220012026_31529
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Since libipt_tos works well, I kick the sim out from 'expected-failure'
and did some clean-up. Its life was kinda short, eh! :-)

Cheers

- acidfu
------=_20041220012026_31529
Content-Type: text/x-patch; name="23ipt_tos-bad-args.sim.patch"
Content-Disposition: attachment; filename="23ipt_tos-bad-args.sim.patch"
Content-Transfer-Encoding: quoted-printable

--- 23ipt_tos-bad-args.sim.old	2004-12-20 00:44:10.000000000 -0500
+++ 23ipt_tos-bad-args.sim	2004-12-20 00:47:58.000000000 -0500
@@ -3,10 +3,6 @@
 iptables -A INPUT -m tos --tos 1
=20
 # Check if inputing the same option twice overwrite previous one.
-# This should ring the bell, but doesn't now.
-# I sent a patch to nf-devel.
-# someone can apply it please ?. thanks.
-# https://lists.netfilter.org/pipermail/netfilter-devel/2004-December/01=
7824.html
 expect iptables iptables: command failed
 iptables -A INPUT -m tos --tos 2 --tos 4
=20
------=_20041220012026_31529
Content-Type: text/x-patch; name="expected-failures.patch"
Content-Disposition: attachment; filename="expected-failures.patch"
Content-Transfer-Encoding: quoted-printable

--- expected-failures.old	2004-12-20 00:50:20.000000000 -0500
+++ expected-failures	2004-12-20 00:50:32.000000000 -0500
@@ -26,4 +26,3 @@
 linux:2.6.10*:03NAT/21loopback.sim
 iptables:*:01iptables/26ipt_ttl-out-of-range.sim
 iptables:1.2*:01iptables/36ipt_multiport-bad-args-complain.sim
-iptables:*:01iptables/23ipt_tos-bad-args.sim
------=_20041220012026_31529--
