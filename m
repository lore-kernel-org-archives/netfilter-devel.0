From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [PATCH] Netfilter transparent proxying support
Date: Wed, 07 Apr 2004 09:48:19 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1081324098.1192.8.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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

  While preparing for an upcoming release of version 2.0 of the
transparent proxying patch, we're trying to prepare for inclusion in
Netfilter. However, the current version of the transparent proxying
patch modifies the Netfilter conntrack and NAT core, and has some
modifications in the IP stack as well. I think some of these addons may
be generally useful, and possibly could be merged in Netfilter, if that
is acceptable for the developers.

  To make it easier to understand those core changes, I've prepared a
patchtree (both for Linux 2.4 and 2.6), which contains the changes in a
broken-out form, along with some comments for each patch.

  The tarballs contain two directories:

01-nat_reservations: this directory contains the already submitted NAT
  reservations patch, plus an extra patch which exports three more
  functions used by the iptable_tproxy module.

02-tproxy: this is the transparent proxying patch in a broken-out form,
  eg. the core changes plus the new files (in the last patch file).
  The changes are split in three groups:

  - patches which modify the IP core:
    - 01-net-protocol_callbacks.patch: adds two hooks to the UDP and TCP
        protocol implementation, making implicit unassign operations when
        closing an assigned socket possible. These are really ugly, but
	seem to be the only possible solution.
    - 02-net-export_local_port_range.patch: this patch exports the 
        sysctl_local_port_range variable, thus makes it possible for
        tproxy to allocate port numbers from the range specified through
        sysctl. (Not present in the patchtree for Linux 2.6, since 2.6
        exports this variable.)
    - 03-net-ip_sockglue.patch: implements the IP_RECVORIGADDRS socket
        option, and the IP_ORIGADDRS cmsg for recvmsg(). This makes
        receiving an UDP packet's original source/destination address
	before the NAT translations.
  - patches which modify parts of the Netfilter core:
    - 04-netfilter-export_manip_pkt.patch: renames manip_pkt() to
        ip_nat_manip_pkt(), and exports the function. This is needed
        to be able to handle UDP "session" specially. A more detailed
        description of handling of UDP sessions can be found in the
        README file of the tproxy tarball. (Available at
        http://www.balabit.com/downloads/tproxy/linux-2.4/)
    - 05-netfilter-ip_nat_setup_info_flags.patch: this changes
        ip_nat_setup_info() to accept a new argument, flags. This can
        be used to specify special flags, which may modify the operation
        of the function. Currently, the IP_NAT_BYPASS_HELPERS flag is
        implemented, which causes to skip assigning the helpers.
    - 06-netfilter-export_nat_lock.patch: exports the NAT lock, which is
        needed by iptable_tproxy to be able to use ip_nat_setup_info().
    - 07-netfilter-extend_conntrack_struct.patch: this patch extends the
        ip_conntrack structure, adding an extra list_head, and specifying
        two new bits in the status field. The list_head is used by tproxy
        to make fast deletion of conntrack entries possible, which is
        needed in some cases when unassigning/closing a socket.
  - patches which contain the transparent proxying module and related files:
    - 08-config_and_makefile.patch: adds the necessary Config.in and
        Makefile entries
    - 09-tproxy.patch: adds new files

  Some of these patches (the ip_nat_setup_info()-related, or the
manip_pkt() related one) could be useful for other purposes as well, so
maybe incorporating these changes into the Netfilter code would be
useful. The networking core related changes we've tried to minimize, if
any of you have some ideas which could decrease the footprint of the
patch, you're welcome.

  We're open to any suggestions, especially regarding the core-related
parts.

  The patchtrees are available for download at the following addresses:
http://people.balabit.hu/hidden/tproxy-1.9.3-linux-2.4-split.tar.gz
http://people.balabit.hu/hidden/tproxy-1.9.3-linux-2.6-split.tar.gz

-- 
 Regards,
   Krisztian KOVACS
