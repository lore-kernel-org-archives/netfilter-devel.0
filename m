From: James Morris <jmorris@intercode.com.au>
Subject: [SECURITY] Local Netfilter / IPTables IP Queue PID Wrap Flaw
Date: Tue, 3 Dec 2002 21:57:45 +1100 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Mutt.LNX.4.44.0212032155570.27990-100000@blackbird.intercode.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.samba.org, <netfilter@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-announce@lists.netfilter.org
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


                  Netfilter Core Team Security Advisory
                  
Subject:

  Local Netfilter / IPTables IP Queue PID Wrap Flaw

Released:

  December 3, 2002.

Effects:

  Under limited circumstances, an unprivileged local user may be able
  to read a limited amount of arbitrary IPv4 or IPv6 traffic.

Estimated Severity:

  Low.

Remotely Exploitable:

  No.
  
Systems Affected:

  Linux 2.4 kernels up to and including 2.4.19, and Linux 2.5 kernels
  up to and including 2.5.31, where Netfilter / IPTables is enabled,
  and where either of the experimental IP queuing modules (ip_queue,
  ip6_queue) are in use.

Solution:

  Upgrade to Linux kernels 2.4.20 (stable), and 2.5.32 (development).

Details:

  Under Linux 2.4 and 2.5, an experimental IP packet queuing feature is
  available as part of Netfilter / IPTables.  This consists of kernel
  modules and a userspace library which allow userspace mediation and
  modification of IPv4 and IPv6 packets.

  A userspace mediation process must normally be privileged (requiring
  NET_ADMIN capability) to process packets from the kernel.  To commence
  mediating packets, a userspace process typically sends a Netlink message
  to the associated kernel module, specifying queuing parameters. The
  kernel module captures the Unix process ID (PID) of the process to ensure
  reliable queuing and delivery of packets.

  If the privileged mediation process exits, an unprivileged process
  re-using the same PID may be able to receive a limited amount of
  network traffic.

  This would only occur if no network traffic was queued between the exit
  of the privileged process and the establishment of the unprivileged
  process, as the kernel module will reset the queuing session upon
  transmission error to userspace.

  The kernel module will only transmit a limited number of packets to
  the userspace process without acknowledgment.  As all transmissions
  from userspace to the kernel module require NET_ADMIN capability,
  the unprivileged process will not be able to acknowledge packets.
  Thus, the maximum number of packets that the unprivileged process
  can read is limited to the queue length (default 1024 packets).
  The unprivileged process can also only read packets which have been
  selected for queuing via IPTables by a privileged process.

  This flaw is theorized to be difficult and somewhat invasive to exploit,
  probably requiring a combined use of DoS attacks.  It was discovered by
  the author of the code, and no exploits are known to exist.

  Fixing the flaw involved implementing a reliable mechanism for detecting
  when the Netlink control socket of a privileged mediation process is
  closed, and resetting the kernel queuing session state upon such events.

Credits:
  The fix was implemented by the Netfilter Core Team, with contributions
  from Jamal Hadi Salim and Alexey Kuznetsov.

Contact:
  coreteam@netfilter.org

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE97I4yKVbBrEQtqycRAmlnAJwN5ifTaixuLhi3qv8FVicmaNpYagCffdOu
Mc8UiYh/FUhiZbjXctyaoxg=
=nnt5
-----END PGP SIGNATURE-----
