From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Deprecated header file(s)
Date: Sun, 13 Mar 2005 21:24:00 +0200
Message-ID: <42349350.7080500@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

There's a header file in

include/linux/netfilter_logging.h

that declares functions that were found in 2.4. In 2.6, they seem to be
defined in

include/linux/netfilter.h

instead, and taking different arguments.

Also, the header files

include/linux/netfilter_ipv4/ip_logging.h
include/linux/netfilter_ipv6/ip6_logging.h

include the seemingly deprecated netfilter_logging.h file and defines IPv4
and IPv6-specific macros for easier use of the functions.

Luckily the three *_logging.h header files were not in use anywhere in the
kernel sources, and since the functions are now defined according to
netfilter.h prototypes instead, I guess the *_logging.h files should be
removed, or possibly updated to work with the new interface in netfilter.h
instead.

For example ipt_LOG.c and ipt_ULOG.c in 2.4.28 used ip_logging.h, but have
been changed since to use the new interface from netfilter.h instead, and
thus don't make use of the "helper" macros anymore.

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCNJNMxyF48ZTvn+4RAto7AJ9CPQ+l0Zt99zWfna7tvvag7fKLXgCfSsk0
OlhfL/yFOthL74c6TRmWPC8=
=tgq7
-----END PGP SIGNATURE-----
