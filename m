From: Frank 'xraz' Fricke <xraz@rwxr-xr-x.de>
Subject: ip6t_ROUTE target
Date: Fri, 16 May 2003 22:16:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030516221652.3d86c00a.xraz@rwxr-xr-x.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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

Hi Folks!

I've written a ip6tables target for mangle/POSTROUTING to force
sending of packets with a specified interface. This makes
source-routing and multihoming without provider-transits possible
(at least at my site).

This was my first netfilter/kernel-work an was all done from
scratch - maybe it's alls wrong, but it really seem to do it's
job.
It's not working as a module because it uses rt6_lookup wich is not
exported - but i found it suitable for this case.

Could someone please review it?

Patches against stock 2.4.20 and iptables-1.2.8 are at:
http://duensch.org/xr/coding/linux-kernel/ip6t_ROUTE/

    ...Frank

- -- 
http://www.gnupg.org         |         http://xraz.de/gpg.key
Fingerpint: C1E1 0A5C 3733 F4F1 D59B 14F7 57C6 1784 8F78 8A2B
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE+xUc0V8YXhI94iisRAko+AKCRQJO1JR4r7+6j53rG/ty1UVx9/gCaA1vQ
N/zfmjHst7H7+Zyglf/4JZI=
=5/rD
-----END PGP SIGNATURE-----
