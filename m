From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] pom-ng new release
Date: Tue, 4 May 2004 12:28:17 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405041202330.26840-100000@blackhole.kfki.hu>
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

I'm happy to announce the new pom-ng release!

There are numerous internal changes:

- object-oriented internal API instead of the functional one:
  more consistent, easier to extend, but function prototypeing is lost
- complete control over version dependency via name encoding and
  version requirements in info files
- complete dependency checking: when a patch is dependent on other
  patches and neither one is specified, shadow tree is created to
  check wether the patch could really be applied
- special updates/ directory for full project-version patches and bugfixes
  introduced
- reported bugs and improvements fixed/incorporated:
    - dependency clashing did not work (Jim Gifford)

      [Could any Perl guru explain in plain English while the code

      for my $dep (@{$$patchlet{info}{depends}}) {
		$dep =~ s/^!//;
      }

      modifies the content of array $patchlet{info}{depends} too??]

    - broken out patches are supported (KOVACS Krisztian)
    - ignore case in runme (syrius.ml)

Please check out and try the new code. Bugreports, suggestion for
improvements are welcomed!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
