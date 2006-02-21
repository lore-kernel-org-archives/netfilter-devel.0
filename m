From: Gregor Maier <gregor@net.in.tum.de>
Subject: libnetfilter_queue: get link layer header
Date: Tue, 21 Feb 2006 18:10:33 +0100
Message-ID: <43FB4989.7070901@net.in.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi,

I was wondering if it's somehow possible to aquire the complete link
level header in libnetfilter_queue. I can get the HW Protocol
(Ethertype) and the SRC MAC but it is also possible to get the DST MAC.

I know that for outgoing packets the information is only available after
the arp lookup (so in/after POSTROUTING) but for INPUT / FORWARD packets
the DST Mac is always available. Maybe it would be a solution to set the
DST MAC to all zeros if it's not yet known and then add a mechanism to
pass the DST Mac to the userspace app listeing on the queue.

cu
gregor
- --
Gregor Maier                                      Lehrstuhl Informatik 8
gregor@net.in.tum.de                              Tel: +49 89  289-18010
http://www.net.in.tum.de                                     TU Muenchen
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (Darwin)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFD+0mIdGiwgbikMYMRAgzZAKCjSvZq0gxe3ZtxX+CfnHX+cYG7hgCfXL40
QYqK7Jyt1gbbtmNKi1mP+YQ=
=QoqI
-----END PGP SIGNATURE-----
