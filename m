From: Lukas Ruf <ruf@rawip.org>
Subject: iptables 1.2.11 and kernel 2.6.7
Date: Fri, 2 Jul 2004 15:51:47 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040702135147.GC11721@tik.ee.ethz.ch>
Reply-To: PLEASE REPLY TO THE LIST <dev_null@rawip.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; x-action=pgp-signed
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter development <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
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

Today, I realized two problems: with kernel 2.6.7 when builing iptables
1.2.11 for ipv4 and ipv6:

In the files:
    include/libiptc/libip6tc.h
    include/libiptc/libiptc.h

1. : __user is not known as found in both
    include/linux/netfilter_ipv6/ip6_tables.h:261
    include/linux/netfilter_ipv4/ip_tables.h:255

2. : DECLARE_MUTEX() is not known outside of the kernel for both
    DECLARE_MUTEX(ip6t_mutex) and DECLARE_MUTEX(ipt_mutex)
    as defined in the same files:
    include/linux/netfilter_ipv6/ip6_tables.h
    include/linux/netfilter_ipv4/ip_tables.h

I fixed the problems by #define'ing __user ifndef before in the
libiptc files, and moving DECLARE_MUTEX() into the #ifdef __KERNEL__
statement in the ip_tables.h files.

Has anyone experienced the same problems?  I could not find any answer
in the archive.

If anyone would be interested in patch, please indicate and I will
create one.

Thanks.

wbr,
Lukas
- -- 
Lukas Ruf           | Wanna know anything about raw |
<http://www.lpr.ch> | IP? -> <http://www.rawip.org> |
eMail Style Guide: <http://www.rawip.org/style.html>|
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA5WhzXf8zDoH8+EURAmg/AJsGzGy1CNvVLJrKPn+ppDehZS4f9gCglLc0
1zCWo4Icb8oHec7iHq7kESk=
=GY2R
-----END PGP SIGNATURE-----
