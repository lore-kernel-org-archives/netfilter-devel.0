From: c0g <c0g@wp.pl>
Subject: "ip_conntrack_core: Frag of proto 17." error
Date: Thu, 18 Sep 2003 17:32:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F69CFF6.1060505@wp.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi
I'm getting lots of these errors. I read in ip_conntrack_core.c it
should "never happen" (so it's kind of assertion). Why does this
assertion fail?

I'm using 2.4.22 kernel with CVS p-o-m 20030907. I'm using only
following major netfilter patches:

TCPLAG.patch
ipt_REJECT-fake-source.patch
raw.patch

and some minor:

39_ip_conntrack-proc.patch
40_nf-log.patch
54_ip_nat-macro-args.patch
58-ip_conntrack-macro-args.patch
59_ip_nat_h-unused-var.patch
60_nat_tftp-remove-warning.patch
61-remove-memsets.patch
63_getorigdst-tuple-zero.patch
74_nat-range-fix.patch
ip_ct_refresh_optimization.patch

- --
c0g@wp.pl

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQE/ac/2PqmVt5WhbA8RAm7oAJ9W+KUw6f4su9mpKUjMCbieracD+wCdHfut
3A++Y9/gobZCg/EwTCAlZhQ=
=zvIJ
-----END PGP SIGNATURE-----
