From: Gregor Maier <gregor@net.in.tum.de>
Subject: libnetfilter_queue large packets problem
Date: Thu, 23 Feb 2006 23:44:24 +0100
Message-ID: <43FE3AC8.7000809@net.in.tum.de>
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

I think I encountered a problem when using libnetfilter_queue with
packets larger than the recv buffer specified when recv()-ing from the
socket of the queue.

The kernel truncates(*) the packet delivered to userspace an thus
nfnl_handle_packet() returns -1 (**), since there's a mismatch between
the length of the buffer and the recorded length in struct nlmsghdr.
This means that the callback function is never called an therefore we
are never able to issue a verdict for the packet and the packet is stuck
forever.

I think the best solution would be, if the callback would be called and
informed about the truncation, so that the callback can deside about the
fate of the packet.


A workaround is to make the buffer large enough for any possible packet
(i.e. 65535 + x for IP, with x being the number of bytes occupied by the
 netlink data structures)


This is almost certainly the cause of bug
https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=404


(*) when I use recvmsg then the MSG_TRUNC flag is set for such packets
and peek in the netlink code asserted this.


(**)if (nlh->nlmsg_len < sizeof(struct nlmsghdr)
                    || len < nlh->nlmsg_len)
                        return -1;


cu
Gregor
- --
Gregor Maier                                      Lehrstuhl Informatik 8
gregor@net.in.tum.de                              Tel: +49 89  289-18010
http://www.net.in.tum.de                                     TU Muenchen
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (Darwin)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFD/jrIdGiwgbikMYMRAobwAJ43bEBBs2FOEeFCjPRILln1XChZNgCbBysE
FKmJXJQGe2A6jaTnC8xGlEM=
=YQIG
-----END PGP SIGNATURE-----
