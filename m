From: Quentin Aebischer <Quentin.Aebischer@USherbrooke.ca>
Subject: Re: [PATCH] conntrackd: basic TIPC implementation for NOTRACK mode
Date: Thu, 26 Jan 2012 21:46:41 -0500
Message-ID: <20120126214641.82372un6d7dcc46c@www.usherbrooke.ca>
References: <20120121085217.4272940o8fmk4v80@www.usherbrooke.ca>
 <20120122174140.GA18764@1984>
 <20120122162720.10123t2longq3zac@www.usherbrooke.ca>
 <20120123100733.GB23857@1984>
 <20120123132537.198937ydqdx1n3gg@www.usherbrooke.ca>
 <20120124010145.GA28314@1984>
 <20120124120058.234342gq75ohof6s@www.usherbrooke.ca>
 <20120126001928.GA10554@1984>
 <20120126211344.33964cmak17akti0@www.usherbrooke.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpi4.USherbrooke.ca ([132.210.236.3]:13241 "EHLO
	smtpi4.usherbrooke.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab2A0CrD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Jan 2012 21:47:03 -0500
In-Reply-To: <20120126211344.33964cmak17akti0@www.usherbrooke.ca>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sorry, forgot to add conntrackd.conf example and README files ...

 From : Quentin Aebischer <quentin.aebischer@usherbrooke.ca>

Example file conntrackd.conf and README for TIPC implementation of the =
=20
conntrackd daemon.

Signed-off-by: Quentin Aebischer <quentin.aebischer@usherbrooke.ca>
---
  doc/sync/tipc/README          |   13 ++
  doc/sync/tipc/conntrackd.conf |  454 =20
+++++++++++++++++++++++++++++++++++++++++
  2 files changed, 467 insertions(+), 0 deletions(-)

diff --git a/doc/sync/tipc/README b/doc/sync/tipc/README
new file mode 100644
index 0000000..e7afcc7
--- /dev/null
+++ b/doc/sync/tipc/README
@@ -0,0 +1,13 @@
+Installation instructions :
+
+TIPC is a built-in kernel module since kernel version 2.6.35 ; please =
=20
make sure your using a =3D> 2.6.35 kernel with TIPC 2.0, as this patch =
=20
has not been tested with older versions of the protocol yet.
+
+For easy and fast configuration, you must install the TIPC utilies =20
v2.0.0, available from sources here :
+
+    git://tipc.git.sourceforge.net/gitroot/tipc/tipcutils (branch =20
tipcutils2.0)
+
+or by using aptitude on debian distributions :
+
+    sudo apt-get install tipcutils
+
+For further details on installation, node and network configuration, =20
please refer to the online documentation : =20
http://tipc.sourceforge.net/doc/tipc_2.0_users_guide.html#installation.
diff --git a/doc/sync/tipc/conntrackd.conf b/doc/sync/tipc/conntrackd.c=
onf
new file mode 100644
index 0000000..71946ec
--- /dev/null
+++ b/doc/sync/tipc/conntrackd.conf
@@ -0,0 +1,454 @@
+#
+# Synchronizer settings
+#
+Sync {
+	Mode NOTRACK {
+		#
+		# Size of the resend queue (in objects). This is the maximum
+		# number of objects that can be stored waiting to be confirmed
+		# via acknoledgment. If you keep this value low, the daemon
+		# will have less chances to recover state-changes under message
+		# omission. On the other hand, if you keep this value high,
+		# the daemon will consume more memory to store dead objects.
+		# Default is 131072 objects.
+		#
+		# ResendQueueSize 131072
+
+		#
+		# This parameter allows you to set an initial fixed timeout
+		# for the committed entries when this node goes from backup
+		# to primary. This mechanism provides a way to purge entries
+		# that were not recovered appropriately after the specified
+		# fixed timeout. If you set a low value, TCP entries in
+		# Established states with no traffic may hang. For example,
+		# an SSH connection without KeepAlive enabled. If not set,
+		# the daemon uses an approximate timeout value calculation
+		# mechanism. By default, this option is not set.
+		#
+		# CommitTimeout 180
+
+		#
+		# If the firewall replica goes from primary to backup,
+		# the conntrackd -t command is invoked in the script.
+		# This command schedules a flush of the table in N seconds.
+		# This is useful to purge the connection tracking table of
+		# zombie entries and avoid clashes with old entries if you
+		# trigger several consecutive hand-overs. Default is 60 seconds.
+		#
+		# PurgeTimeout 60
+
+		# Set the acknowledgement window size. If you decrease this
+		# value, the number of acknowlegdments increases. More
+		# acknowledgments means more overhead as conntrackd has to
+		# handle more control messages. On the other hand, if you
+		# increase this value, the resend queue gets more populated.
+		# This results in more overhead in the queue releasing.
+		# The following value is based on some practical experiments
+		# measuring the cycles spent by the acknowledgment handling
+		# with oprofile. If not set, default window size is 300.
+		#
+		# ACKWindowSize 300
+
+		#
+		# This clause allows you to disable the external cache. Thus,
+		# the state entries are directly injected into the kernel
+		# conntrack table. As a result, you save memory in user-space
+		# but you consume slots in the kernel conntrack table for
+		# backup state entries. Moreover, disabling the external cache
+		# means more CPU consumption. You need a Linux kernel
+		# >=3D 2.6.29 to use this feature. By default, this clause is
+		# set off. If you are installing conntrackd for first time,
+		# please read the user manual and I encourage you to consider
+		# using the fail-over scripts instead of enabling this option!
+		#
+		# DisableExternalCache Off
+	}
+
+	#
+	# Multicast IP and interface where messages are
+	# broadcasted (dedicated link). IMPORTANT: Make sure
+	# that iptables accepts traffic for destination
+	# 225.0.0.50, eg:
+	#
+	#	iptables -I INPUT -d 225.0.0.50 -j ACCEPT
+	#	iptables -I OUTPUT -d 225.0.0.50 -j ACCEPT
+	#
+	# Multicast {
+		#
+		# Multicast address: The address that you use as destination
+		# in the synchronization messages. You do not have to add
+		# this IP to any of your existing interfaces. If any doubt,
+		# do not modify this value.
+		#
+		# IPv4_address 225.0.0.50
+
+		#
+		# The multicast group that identifies the cluster. If any
+		# doubt, do not modify this value.
+		#
+		# Group 3780
+
+		#
+		# IP address of the interface that you are going to use to
+		# send the synchronization messages. Remember that you must
+		# use a dedicated link for the synchronization messages.
+		#
+		# IPv4_interface 192.168.100.100
+
+		#
+		# The name of the interface that you are going to use to
+		# send the synchronization messages.
+		#
+		# Interface eth2
+
+		# The multicast sender uses a buffer to enqueue the packets
+		# that are going to be transmitted. The default size of this
+		# socket buffer is available at /proc/sys/net/core/wmem_default.
+		# This value determines the chances to have an overrun in the
+		# sender queue. The overrun results packet loss, thus, losing
+		# state information that would have to be retransmitted. If you
+		# notice some packet loss, you may want to increase the size
+		# of the sender buffer. The default size is usually around
+		# ~100 KBytes which is fairly small for busy firewalls.
+		#
+		# SndSocketBuffer 1249280
+
+		# The multicast receiver uses a buffer to enqueue the packets
+		# that the socket is pending to handle. The default size of this
+		# socket buffer is available at /proc/sys/net/core/rmem_default.
+		# This value determines the chances to have an overrun in the
+		# receiver queue. The overrun results packet loss, thus, losing
+		# state information that would have to be retransmitted. If you
+		# notice some packet loss, you may want to increase the size of
+		# the receiver buffer. The default size is usually around
+		# ~100 KBytes which is fairly small for busy firewalls.
+		#
+		# RcvSocketBuffer 1249280
+
+		#
+		# Enable/Disable message checksumming. This is a good
+		# property to achieve fault-tolerance. In case of doubt, do
+		# not modify this value.
+		#
+		# Checksum on
+	# }
+	#
+	# You can specify more than one dedicated link. Thus, if one dedicate=
d
+	# link fails, conntrackd can fail-over to another. Note that adding
+	# more than one dedicated link does not mean that state-updates will
+	# be sent to all of them. There is only one active dedicated link at
+	# a given moment. The `Default' keyword indicates that this interface
+	# will be selected as the initial dedicated link. You can have
+	# up to 4 redundant dedicated links. Note: Use different multicast
+	# groups for every redundant link.
+	#
+	# Multicast Default {
+	#	IPv4_address 225.0.0.51
+	#	Group 3781
+	#	IPv4_interface 192.168.100.101
+	#	Interface eth3
+	#	# SndSocketBuffer 1249280
+	#	# RcvSocketBuffer 1249280
+	#	Checksum on
+	# }
+
+	#
+	# You can use Unicast UDP instead of Multicast to propagate events.
+	# Note that you cannot use unicast UDP and Multicast at the same
+	# time, you can only select one.
+	#
+	# UDP {
+		#
+		# UDP address that this firewall uses to listen to events.
+		#
+		# IPv4_address 192.168.2.100
+		#
+		# or you may want to use an IPv6 address:
+		#
+		# IPv6_address fe80::215:58ff:fe28:5a27
+
+		#
+		# Destination UDP address that receives events, ie. the other
+		# firewall's dedicated link address.
+		#
+		# IPv4_Destination_Address 192.168.2.101
+		#
+		# or you may want to use an IPv6 address:
+		#
+		# IPv6_Destination_Address fe80::2d0:59ff:fe2a:775c
+
+		#
+		# UDP port used
+		#
+		# Port 3780
+
+		#
+		# The name of the interface that you are going to use to
+		# send the synchronization messages.
+		#
+		# Interface eth2
+
+		#
+		# The sender socket buffer size
+		#
+		# SndSocketBuffer 1249280
+
+		#
+		# The receiver socket buffer size
+		#
+		# RcvSocketBuffer 1249280
+
+		#
+		# Enable/Disable message checksumming.
+		#
+		# Checksum on
+	# }
+
+	TIPC {
+		#
+		# Name of the other TIPC port in the cluster (in the form type:insta=
nce)
+		#
+		  TIPC_Destination_Name 1000:51
+
+		#
+		# Name of the local TIPC port (used to listen to events)
+		#
+		  TIPC_Name 1000:50
+
+		#
+		# The name of the TIPC configured interface that you are going to us=
e
+		# to send synchronization messages.
+		#
+		  Interface eth0
+
+		#
+		# The importance of the TIPC messages sent (the more important this =
=20
is, the more packets will be enabled to queue up on the slave)
+		# This should be set to High or Critical to avoid congestion on the =
=20
receiver side.
+		# (possible values : TIPC_LOW_IMPORTANCE, TIPC_MEDIUM_IMPORTANCE, =20
TIPC_HIGH_IMPORTANCE, TIPC_CRITICAL_IMPROTANCE)
+		#
+		  TIPC_Message_Importance TIPC_CRITICAL_IMPORTANCE
+
+		#
+		# Current TIPC implementation doesnt allow checksumming
+	}
+
+	#
+	# Other unsorted options that are related to the synchronization.
+	#
+	# Options {
+		#
+		# TCP state-entries have window tracking disabled by default,
+		# you can enable it with this option. As said, default is off.
+		# This feature requires a Linux kernel >=3D 2.6.36.
+		#
+		# TCPWindowTracking Off
+
+		# Set this option on if you want to enable the synchronization
+		# of expectations. You have to specify the list of helpers that
+		# you want to enable. Default is off.
+		#
+		# ExpectationSync {
+		#	ftp
+		#	h323
+		#	sip
+		# }
+		#
+		# You can use this alternatively:
+		#
+		# ExpectationSync On
+		#
+		# If you want to synchronize expectations of all helpers.
+	# }
+}
+
+#
+# General settings
+#
+General {
+	#
+	# Set the nice value of the daemon, this value goes from -20
+	# (most favorable scheduling) to 19 (least favorable). Using a
+	# very low value reduces the chances to lose state-change events.
+	# Default is 0 but this example file sets it to most favourable
+	# scheduling as this is generally a good idea. See man nice(1) for
+	# more information.
+	#
+	Nice -20
+
+	#
+	# Select a different scheduler for the daemon, you can select between
+	# RR and FIFO and the process priority (minimum is 0, maximum is 99).
+	# See man sched_setscheduler(2) for more information. Using a RT
+	# scheduler reduces the chances to overrun the Netlink buffer.
+	#
+	# Scheduler {
+	#	Type FIFO
+	#	Priority 99
+	# }
+
+	#
+	# Number of buckets in the cache hashtable. The bigger it is,
+	# the closer it gets to O(1) at the cost of consuming more memory.
+	# Read some documents about tuning hashtables for further reference.
+	#
+	HashSize 32768
+
+	#
+	# Maximum number of conntracks, it should be double of:
+	# $ cat /proc/sys/net/netfilter/nf_conntrack_max
+	# since the daemon may keep some dead entries cached for possible
+	# retransmission during state synchronization.
+	#
+	HashLimit 131072
+
+	#
+	# Logfile: on (/var/log/conntrackd.log), off, or a filename
+	# Default: off
+	#
+	LogFile on
+
+	#
+	# Syslog: on, off or a facility name (daemon (default) or local0..7)
+	# Default: off
+	#
+	#Syslog on
+
+	#
+	# Lockfile
+	#
+	LockFile /var/lock/conntrack.lock
+
+	#
+	# Unix socket configuration
+	#
+	UNIX {
+		Path /var/run/conntrackd.ctl
+		Backlog 20
+	}
+
+	#
+	# Netlink event socket buffer size. If you do not specify this clause=
,
+	# the default buffer size value in /proc/net/core/rmem_default is
+	# used. This default value is usually around 100 Kbytes which is
+	# fairly small for busy firewalls. This leads to event message droppi=
ng
+	# and high CPU consumption. This example configuration file sets the
+	# size to 2 MBytes to avoid this sort of problems.
+	#
+	NetlinkBufferSize 2097152
+
+	#
+	# The daemon doubles the size of the netlink event socket buffer size
+	# if it detects netlink event message dropping. This clause sets the
+	# maximum buffer size growth that can be reached. This example file
+	# sets the size to 8 MBytes.
+	#
+	NetlinkBufferSizeMaxGrowth 8388608
+
+	#
+	# If the daemon detects that Netlink is dropping state-change events,
+	# it automatically schedules a resynchronization against the Kernel
+	# after 30 seconds (default value). Resynchronizations are expensive
+	# in terms of CPU consumption since the daemon has to get the full
+	# kernel state-table and purge state-entries that do not exist anymor=
e.
+	# Be careful of setting a very small value here. You have the followi=
ng
+	# choices: On (enabled, use default 30 seconds value), Off (disabled)
+	# or Value (in seconds, to set a specific amount of time). If not
+	# specified, the daemon assumes that this option is enabled.
+	#
+	# NetlinkOverrunResync On
+
+	#
+	# If you want reliable event reporting over Netlink, set on this
+	# option. If you set on this clause, it is a good idea to set off
+	# NetlinkOverrunResync. This option is off by default and you need
+	# a Linux kernel >=3D 2.6.31.
+	#
+	# NetlinkEventsReliable Off
+
+	#
+	# By default, the daemon receives state updates following an
+	# event-driven model. You can modify this behaviour by switching to
+	# polling mode with the PollSecs clause. This clause tells conntrackd
+	# to dump the states in the kernel every N seconds. With regards to
+	# synchronization mode, the polling mode can only guarantee that
+	# long-lifetime states are recovered. The main advantage of this meth=
od
+	# is the reduction in the state replication at the cost of reducing t=
he
+	# chances of recovering connections.
+	#
+	# PollSecs 15
+
+	#
+	# The daemon prioritizes the handling of state-change events coming
+	# from the core. With this clause, you can set the maximum number of
+	# state-change events (those coming from kernel-space) that the daemo=
n
+	# will handle after which it will handle other events coming from the
+	# network or userspace. A low value improves interactivity (in terms =
of
+	# real-time behaviour) at the cost of extra CPU consumption.
+	# Default (if not set) is 100.
+	#
+	# EventIterationLimit 100
+
+	#
+	# Event filtering: This clause allows you to filter certain traffic,
+	# There are currently three filter-sets: Protocol, Address and
+	# State. The filter is attached to an action that can be: Accept or
+	# Ignore. Thus, you can define the event filtering policy of the
+	# filter-sets in positive or negative logic depending on your needs.
+	# You can select if conntrackd filters the event messages from
+	# user-space or kernel-space. The kernel-space event filtering
+	# saves some CPU cycles by avoiding the copy of the event message
+	# from kernel-space to user-space. The kernel-space event filtering
+	# is prefered, however, you require a Linux kernel >=3D 2.6.29 to
+	# filter from kernel-space. If you want to select kernel-space
+	# event filtering, use the keyword 'Kernelspace' instead of
+	# 'Userspace'.
+	#
+	Filter From Userspace {
+		#
+		# Accept only certain protocols: You may want to replicate
+		# the state of flows depending on their layer 4 protocol.
+		#
+		Protocol Accept {
+			TCP
+			SCTP
+			DCCP
+			# UDP
+			# ICMP # This requires a Linux kernel >=3D 2.6.31
+			# IPv6-ICMP # This requires a Linux kernel >=3D 2.6.31
+		}
+
+		#
+		# Ignore traffic for a certain set of IP's: Usually all the
+		# IP assigned to the firewall since local traffic must be
+		# ignored, only forwarded connections are worth to replicate.
+		# Note that these values depends on the local IPs that are
+		# assigned to the firewall.
+		#
+		Address Ignore {
+			IPv4_address 127.0.0.1 # loopback
+			IPv4_address 192.168.0.100 # virtual IP 1
+			IPv4_address 192.168.1.100 # virtual IP 2
+			IPv4_address 192.168.0.1
+			IPv4_address 192.168.1.1
+			IPv4_address 192.168.100.100 # dedicated link ip
+			#
+			# You can also specify networks in format IP/cidr.
+			# IPv4_address 192.168.0.0/24
+			#
+			# You can also specify an IPv6 address
+			# IPv6_address ::1
+		}
+
+		#
+		# Uncomment this line below if you want to filter by flow state.
+		# This option introduces a trade-off in the replication: it
+		# reduces CPU consumption at the cost of having lazy backup
+		# firewall replicas. The existing TCP states are: SYN_SENT,
+		# SYN_RECV, ESTABLISHED, FIN_WAIT, CLOSE_WAIT, LAST_ACK,
+		# TIME_WAIT, CLOSED, LISTEN.
+		#
+		# State Accept {
+		#	ESTABLISHED CLOSED TIME_WAIT CLOSE_WAIT for TCP
+		# }
+	}
+}


Quentin Aebischer <Quentin.Aebischer@USherbrooke.ca> a =C3=A9crit=C2=A0=
:

> Ok, time for an other try !
>
> From : Quentin Aebischer <quentin.aebischer@usherbrooke.ca>
>
> Basic implementation of a TIPC channel for the conntrackd daemon =20
> (successfully tested in NOTRACK and FTFW modes).
>
> TIPC is a protocol that allows applications in a cluster-based =20
> environment to communicate quickly and reliably with other =20
> applications in the cluster.
> It allows both unicast and multicast, reliable/unreliable and =20
> datagram/stream oriented communications.
>
> One of its main feature's of interest here is to provide sockets =20
> that communicates in a connectionless, yet reliable manner that =20
> guarantees delivery of every message sent over the network.
> This can be useful in the context of high-available, cluster-based =20
> firewalls where states propagation has to be both fast and reliable.
>
> So far, the results are encouraging, though more tests have to =20
> performed on different setups to enhance the implementation and =20
> track any bugs.
>
> An example config file can be found in the doc/sync/tipc directory =20
> of the conntrack-tools, along with a README file providing basic =20
> installation instructions.
>
> Signed-off-by: Quentin Aebischer <quentin.aebischer@usherbrooke.ca>
> ---
>  include/Makefile.am   |    2 +-
>  include/channel.h     |   10 ++-
>  include/tipc.h        |   59 ++++++++++++
>  src/Makefile.am       |    2 +-
>  src/channel.c         |    2 +
>  src/channel_tipc.c    |  144 ++++++++++++++++++++++++++++
>  src/read_config_lex.l |    7 ++
>  src/read_config_yy.y  |  107 +++++++++++++++++++--
>  src/tipc.c            |  252 =20
> +++++++++++++++++++++++++++++++++++++++++++++++++
>  9 files changed, 573 insertions(+), 12 deletions(-)
>
> diff --git a/include/Makefile.am b/include/Makefile.am
> index cbbca6b..6147d6b 100644
> --- a/include/Makefile.am
> +++ b/include/Makefile.am
> @@ -1,6 +1,6 @@
>
>  noinst_HEADERS =3D alarm.h jhash.h cache.h linux_list.h linux_rbtree=
=2Eh \
> -		 sync.h conntrackd.h local.h udp.h tcp.h \
> +		 sync.h conntrackd.h local.h udp.h tcp.h tipc.h \
>  		 debug.h log.h hash.h mcast.h conntrack.h \
>  		 network.h filter.h queue.h vector.h cidr.h \
>  		 traffic_stats.h netlink.h fds.h event.h bitops.h channel.h \
> diff --git a/include/channel.h b/include/channel.h
> index 9b5fad8..704d384 100644
> --- a/include/channel.h
> +++ b/include/channel.h
> @@ -4,6 +4,7 @@
>  #include "mcast.h"
>  #include "udp.h"
>  #include "tcp.h"
> +#include "tipc.h"
>
>  struct channel;
>  struct nethdr;
> @@ -13,6 +14,7 @@ enum {
>  	CHANNEL_MCAST,
>  	CHANNEL_UDP,
>  	CHANNEL_TCP,
> +	CHANNEL_TIPC,
>  	CHANNEL_MAX,
>  };
>
> @@ -31,6 +33,11 @@ struct tcp_channel {
>  	struct tcp_sock *server;
>  };
>
> +struct tipc_channel {
> +	struct tipc_sock *client;
> +	struct tipc_sock *server;
> +};
> +
>  #define CHANNEL_F_DEFAULT	(1 << 0)
>  #define CHANNEL_F_BUFFERED	(1 << 1)
>  #define CHANNEL_F_STREAM	(1 << 2)
> @@ -41,6 +48,7 @@ union channel_type_conf {
>  	struct mcast_conf mcast;
>  	struct udp_conf udp;
>  	struct tcp_conf tcp;
> +	struct tipc_conf tipc;
>  };
>
>  struct channel_conf {
> @@ -97,7 +105,7 @@ void channel_stats(struct channel *c, int fd);
>  void channel_stats_extended(struct channel *c, int active,
>  			    struct nlif_handle *h, int fd);
>
> -#define MULTICHANNEL_MAX	4
> +#define MULTICHANNEL_MAX	5
>
>  struct multichannel {
>  	int		channel_num;
> diff --git a/include/tipc.h b/include/tipc.h
> new file mode 100644
> index 0000000..840eae0
> --- /dev/null
> +++ b/include/tipc.h
> @@ -0,0 +1,59 @@
> +#ifndef _TIPC_H_
> +#define _TIPC_H_
> +
> +#include <stdint.h>
> +#include <netinet/in.h>
> +#include <net/if.h>
> +#include <linux/tipc.h>
> +
> +/* TODO: no buffer tuning supported. */
> +
> +struct tipc_conf {
> +	int ipproto;
> +	int msgImportance;
> +	struct {
> +		uint32_t type;
> +		uint32_t instance;
> +	} client;
> +	struct {
> +		uint32_t type;
> +		uint32_t instance;
> +	} server;
> +};
> +
> +struct tipc_stats {
> +#ifdef CTD_TIPC_DEBUG
> +	uint64_t returned_messages; /* used for debug purposes */
> +#endif
> +	uint64_t bytes;
> +	uint64_t messages;
> +	uint64_t error;
> +};
> +
> +struct tipc_sock {
> +	int fd;
> +	struct sockaddr_tipc addr;
> +	socklen_t sockaddr_len;
> +	struct tipc_stats stats;
> +};
> +
> +struct tipc_sock *tipc_server_create(struct tipc_conf *conf);
> +void tipc_server_destroy(struct tipc_sock *m);
> +
> +struct tipc_sock *tipc_client_create(struct tipc_conf *conf);
> +void tipc_client_destroy(struct tipc_sock *m);
> +
> +ssize_t tipc_send(struct tipc_sock *m, const void *data, int size);
> +ssize_t tipc_recv(struct tipc_sock *m, void *data, int size);
> +
> +int tipc_get_fd(struct tipc_sock *m);
> +int tipc_isset(struct tipc_sock *m, fd_set *readfds);
> +
> +int tipc_snprintf_stats(char *buf, size_t buflen, char *ifname,
> +		       struct tipc_stats *s, struct tipc_stats *r);
> +
> +int tipc_snprintf_stats2(char *buf, size_t buflen, const char *ifnam=
e,
> +			const char *status, int active,
> +			struct tipc_stats *s, struct tipc_stats *r);
> +
> +#endif
> diff --git a/src/Makefile.am b/src/Makefile.am
> index 7d7b2ac..995912f 100644
> --- a/src/Makefile.am
> +++ b/src/Makefile.am
> @@ -18,7 +18,7 @@ conntrackd_SOURCES =3D alarm.c main.c run.c hash.c =
=20
> queue.c rbtree.c \
>  		    traffic_stats.c stats-mode.c \
>  		    network.c cidr.c \
>  		    build.c parse.c \
> -		    channel.c multichannel.c channel_mcast.c channel_udp.c \
> +		    channel.c multichannel.c channel_mcast.c channel_udp.c tipc.c =
=20
> channel_tipc.c \
>  		    tcp.c channel_tcp.c \
>  		    external_cache.c external_inject.c \
>  		    internal_cache.c internal_bypass.c \
> diff --git a/src/channel.c b/src/channel.c
> index 818bb01..f362af7 100644
> --- a/src/channel.c
> +++ b/src/channel.c
> @@ -24,6 +24,7 @@ static struct channel_ops *ops[CHANNEL_MAX];
>  extern struct channel_ops channel_mcast;
>  extern struct channel_ops channel_udp;
>  extern struct channel_ops channel_tcp;
> +extern struct channel_ops channel_tipc;
>
>  static struct queue *errorq;
>
> @@ -32,6 +33,7 @@ int channel_init(void)
>  	ops[CHANNEL_MCAST] =3D &channel_mcast;
>  	ops[CHANNEL_UDP] =3D &channel_udp;
>  	ops[CHANNEL_TCP] =3D &channel_tcp;
> +	ops[CHANNEL_TIPC] =3D &channel_tipc;
>
>  	errorq =3D queue_create("errorq", CONFIG(channelc).error_queue_leng=
th, 0);
>  	if (errorq =3D=3D NULL) {
> diff --git a/src/channel_tipc.c b/src/channel_tipc.c
> new file mode 100644
> index 0000000..71e3607
> --- /dev/null
> +++ b/src/channel_tipc.c
> @@ -0,0 +1,144 @@
> +/*
> + * (C) 2012 by Quentin Aebischer <quentin.aebicher@usherbrooke.ca>
> + *
> + * Derived work based on channel_mcast.c from:
> + *
> + * (C) 2006-2009 by Pablo Neira Ayuso <pablo@netfilter.org>
> + * (C) 2009 by Pablo Neira Ayuso <pablo@netfilter.org>
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License as published=
 by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <stdlib.h>
> +#include <libnfnetlink/libnfnetlink.h>
> +
> +#include "channel.h"
> +#include "tipc.h"
> +
> +static void
> +*channel_tipc_open(void *conf)
> +{
> +	struct tipc_channel *m;
> +	struct tipc_conf *c =3D conf;
> +
> +	m =3D calloc(sizeof(struct tipc_channel), 1);
> +	if (m =3D=3D NULL)
> +		return NULL;
> +
> +	m->client =3D tipc_client_create(c);
> +	if (m->client =3D=3D NULL) {
> +		free(m);
> +		return NULL;
> +	}
> +
> +	m->server =3D tipc_server_create(c);
> +	if (m->server =3D=3D NULL) {
> +		tipc_client_destroy(m->client);
> +		free(m);
> +		return NULL;
> +	}
> +	return m;
> +}
> +
> +static int
> +channel_tipc_send(void *channel, const void *data, int len)
> +{
> +	struct tipc_channel *m =3D channel;
> +	return tipc_send(m->client, data, len);
> +}
> +
> +static int
> +channel_tipc_recv(void *channel, char *buf, int size)
> +{
> +	struct tipc_channel *m =3D channel;
> +	return tipc_recv(m->server, buf, size);
> +}
> +
> +static void
> +channel_tipc_close(void *channel)
> +{
> +	struct tipc_channel *m =3D channel;
> +	tipc_client_destroy(m->client);
> +	tipc_server_destroy(m->server);
> +	free(m);
> +}
> +
> +static int
> +channel_tipc_get_fd(void *channel)
> +{
> +	struct tipc_channel *m =3D channel;
> +	return tipc_get_fd(m->server);
> +}
> +
> +static void
> +channel_tipc_stats(struct channel *c, int fd)
> +{
> +	struct tipc_channel *m =3D c->data;
> +	char ifname[IFNAMSIZ], buf[512];
> +	int size;
> +
> +	if_indextoname(c->channel_ifindex, ifname);
> +	size =3D tipc_snprintf_stats(buf, sizeof(buf), ifname,
> +				    &m->client->stats, &m->server->stats);
> +	send(fd, buf, size, 0);
> +}
> +
> +static void
> +channel_tipc_stats_extended(struct channel *c, int active,
> +			     struct nlif_handle *h, int fd)
> +{
> +	struct tipc_channel *m =3D c->data;
> +	char ifname[IFNAMSIZ], buf[512];
> +	const char *status;
> +	unsigned int flags;
> +	int size;
> +
> +	if_indextoname(c->channel_ifindex, ifname);
> +	nlif_get_ifflags(h, c->channel_ifindex, &flags);
> +	/*
> +	 * IFF_UP shows administrative status
> +	 * IFF_RUNNING shows carrier status
> +	 */
> +	if (flags & IFF_UP) {
> +		if (!(flags & IFF_RUNNING))
> +			status =3D "NO-CARRIER";
> +		else
> +			status =3D "RUNNING";
> +	} else {
> +		status =3D "DOWN";
> +	}
> +	size =3D tipc_snprintf_stats2(buf, sizeof(buf),
> +				     ifname, status, active,
> +				     &m->client->stats,
> +				     &m->server->stats);
> +	send(fd, buf, size, 0);
> +}
> +
> +static int
> +channel_tipc_isset(struct channel *c, fd_set *readfds)
> +{
> +	struct tipc_channel *m =3D c->data;
> +	return tipc_isset(m->server, readfds);
> +}
> +
> +static int
> +channel_tipc_accept_isset(struct channel *c, fd_set *readfds)
> +{
> +	return 0;
> +}
> +
> +struct channel_ops channel_tipc =3D {
> +	.headersiz	=3D 60, /* IP header (20 bytes) + tipc unicast name =20
> message header 40 (bytes) (see =20
> http://tipc.sourceforge.net/doc/tipc_message_formats.html for =20
> details) */
> +	.open		=3D channel_tipc_open,
> +	.close		=3D channel_tipc_close,
> +	.send		=3D channel_tipc_send,
> +	.recv		=3D channel_tipc_recv,
> +	.get_fd		=3D channel_tipc_get_fd,
> +	.isset		=3D channel_tipc_isset,
> +	.accept_isset	=3D channel_tipc_accept_isset,
> +	.stats		=3D channel_tipc_stats,
> +	.stats_extended =3D channel_tipc_stats_extended,
> +};
> diff --git a/src/read_config_lex.l b/src/read_config_lex.l
> index 01fe4fc..ad37600 100644
> --- a/src/read_config_lex.l
> +++ b/src/read_config_lex.l
> @@ -47,6 +47,7 @@ ip6_part	{hex_255}":"?
>  ip6_form1	{ip6_part}{0,16}"::"{ip6_part}{0,16}
>  ip6_form2	({hex_255}":"){16}{hex_255}
>  ip6		{ip6_form1}{ip6_cidr}?|{ip6_form2}{ip6_cidr}?
> +tipc_name	{integer}":"{integer}
>  string		[a-zA-Z][a-zA-Z0-9\.\-]*
>  persistent	[P|p][E|e][R|r][S|s][I|i][S|s][T|t][E|e][N|n][T|T]
>  nack		[N|n][A|a][C|c][K|k]
> @@ -63,9 +64,13 @@ notrack		[N|n][O|o][T|t][R|r][A|a][C|c][K|k]
>  "IPv4_interface"		{ return T_IPV4_IFACE; }
>  "IPv6_interface"		{ return T_IPV6_IFACE; }
>  "Interface"			{ return T_IFACE; }
> +"TIPC_Destination_Name" 	{ return T_TIPC_DEST_NAME; }
> +"TIPC_Name"			{ return T_TIPC_NAME; }
> +"TIPC_Message_Importance"	{ return T_TIPC_MESSAGE_IMPORTANCE; }
>  "Multicast"			{ return T_MULTICAST; }
>  "UDP"				{ return T_UDP; }
>  "TCP"				{ return T_TCP; }
> +"TIPC"                          { return T_TIPC; }
>  "HashSize"			{ return T_HASHSIZE; }
>  "RefreshTime"			{ return T_REFRESH; }
>  "CacheTimeout"			{ return T_EXPIRE; }
> @@ -149,6 +154,8 @@ notrack		[N|n][O|o][T|t][R|r][A|a][C|c][K|k]
>  {signed_integer}	{ yylval.val =3D atoi(yytext); return T_SIGNED_NUMB=
ER; }
>  {ip4}			{ yylval.string =3D strdup(yytext); return T_IP; }
>  {ip6}			{ yylval.string =3D strdup(yytext); return T_IP; }
> +{tipc_name}		{ yylval.string =3D strdup(yytext); return T_TIPC_NAME_=
VAL; }
> +
>  {path}			{ yylval.string =3D strdup(yytext); return T_PATH_VAL; }
>  {alarm}			{ return T_ALARM; }
>  {persistent}		{ fprintf(stderr, "\nWARNING: Now `persistent' mode "
> diff --git a/src/read_config_yy.y b/src/read_config_yy.y
> index b22784c..21d1c20 100644
> --- a/src/read_config_yy.y
> +++ b/src/read_config_yy.y
> @@ -30,6 +30,7 @@
>  #include "cidr.h"
>  #include <syslog.h>
>  #include <sched.h>
> +#include <linux/tipc.h>
>  #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
>  #include <libnetfilter_conntrack/libnetfilter_conntrack_tcp.h>
>
> @@ -74,8 +75,9 @@ static void __max_dedicated_links_reached(void);
>  %token T_SCHEDULER T_TYPE T_PRIO T_NETLINK_EVENTS_RELIABLE
>  %token T_DISABLE_INTERNAL_CACHE T_DISABLE_EXTERNAL_CACHE =20
> T_ERROR_QUEUE_LENGTH
>  %token T_OPTIONS T_TCP_WINDOW_TRACKING T_EXPECT_SYNC
> +%token T_TIPC T_TIPC_DEST_NAME T_TIPC_NAME T_TIPC_MESSAGE_IMPORTANCE
>
> -%token <string> T_IP T_PATH_VAL
> +%token <string> T_IP T_PATH_VAL T_TIPC_NAME_VAL
>  %token <val> T_NUMBER
>  %token <val> T_SIGNED_NUMBER
>  %token <string> T_STRING
> @@ -150,7 +152,7 @@ syslog_facility : T_SYSLOG T_STRING
>
>  	if (conf.stats.syslog_facility !=3D -1 &&
>  	    conf.syslog_facility !=3D conf.stats.syslog_facility)
> -	    	print_err(CTD_CFG_WARN, "conflicting Syslog facility "
> +		print_err(CTD_CFG_WARN, "conflicting Syslog facility "
>  					"values, defaulting to General");
>  };
>
> @@ -309,7 +311,7 @@ multicast_option : T_IPV4_ADDR T_IP
>  		break;
>  	}
>
> -        if (conf.channel[conf.channel_num].u.mcast.ipproto =3D=3D AF=
_INET6) {
> +	if (conf.channel[conf.channel_num].u.mcast.ipproto =3D=3D AF_INET6)=
 {
>  		print_err(CTD_CFG_WARN, "your multicast address is IPv4 but "
>  					"is binded to an IPv6 interface? "
>  					"Surely, this is not what you want");
> @@ -368,7 +370,7 @@ multicast_option : T_IPV4_IFACE T_IP
>  		break;
>  	}
>
> -        if (conf.channel[conf.channel_num].u.mcast.ipproto =3D=3D AF=
_INET6) {
> +	if (conf.channel[conf.channel_num].u.mcast.ipproto =3D=3D AF_INET6)=
 {
>  		print_err(CTD_CFG_WARN, "your multicast interface is IPv4 but "
>  					"is binded to an IPv6 interface? "
>  					"Surely, this is not what you want");
> @@ -381,7 +383,7 @@ multicast_option : T_IPV4_IFACE T_IP
>  multicast_option : T_IPV6_IFACE T_IP
>  {
>  	print_err(CTD_CFG_WARN, "`IPv6_interface' not required, ignoring");
> -}
> +};
>
>  multicast_option : T_IFACE T_STRING
>  {
> @@ -440,6 +442,92 @@ multicast_option: T_CHECKSUM T_OFF
>  	conf.channel[conf.channel_num].u.mcast.checksum =3D 1;
>  };
>
> +tipc_line : T_TIPC '{' tipc_options '}'
> +{
> +	if (conf.channel_type_global !=3D CHANNEL_NONE &&
> +	    conf.channel_type_global !=3D CHANNEL_TIPC) {
> +		print_err(CTD_CFG_ERROR, "cannot use `TIPC' with other "
> +					 "dedicated link protocols!");
> +		exit(EXIT_FAILURE);
> +	}
> +	conf.channel_type_global =3D CHANNEL_TIPC;
> +	conf.channel[conf.channel_num].channel_type =3D CHANNEL_TIPC;
> +	conf.channel[conf.channel_num].channel_flags =3D CHANNEL_F_BUFFERED=
;
> +	conf.channel_num++;
> +};
> +
> +tipc_line : T_TIPC T_DEFAULT '{' tipc_options '}'
> +{
> +	if (conf.channel_type_global !=3D CHANNEL_NONE &&
> +	    conf.channel_type_global !=3D CHANNEL_TIPC) {
> +		print_err(CTD_CFG_ERROR, "cannot use `TIPC' with other "
> +					 "dedicated link protocols!");
> +		exit(EXIT_FAILURE);
> +	}
> +	conf.channel_type_global =3D CHANNEL_TIPC;
> +	conf.channel[conf.channel_num].channel_type =3D CHANNEL_TIPC;
> +	conf.channel[conf.channel_num].channel_flags =3D CHANNEL_F_DEFAULT =
|
> +						       CHANNEL_F_BUFFERED;
> +	conf.channel_default =3D conf.channel_num;
> +	conf.channel_num++;
> +};
> +
> +tipc_options :
> +	     | tipc_options tipc_option;
> +
> +tipc_option : T_TIPC_DEST_NAME T_TIPC_NAME_VAL
> +{
> +	__max_dedicated_links_reached();
> +
> +	if(sscanf($2, "%d:%d", =20
> &conf.channel[conf.channel_num].u.tipc.client.type, =20
> &conf.channel[conf.channel_num].u.tipc.client.instance) !=3D 2) {
> +		print_err(CTD_CFG_WARN, "Please enter TIPC name in the form =20
> type:instance (ex: 1000:50)");
> +		break;
> +	}
> +	conf.channel[conf.channel_num].u.tipc.ipproto =3D AF_TIPC;
> +};
> +
> +tipc_option : T_TIPC_NAME T_TIPC_NAME_VAL
> +{
> +	__max_dedicated_links_reached();
> +
> +	if(sscanf($2, "%d:%d", =20
> &conf.channel[conf.channel_num].u.tipc.server.type, =20
> &conf.channel[conf.channel_num].u.tipc.server.instance) !=3D 2) {
> +		print_err(CTD_CFG_WARN, "Please enter TIPC name in the form =20
> type:instance (ex: 1000:50)");
> +		break;
> +	}
> +	conf.channel[conf.channel_num].u.tipc.ipproto =3D AF_TIPC;
> +};
> +
> +tipc_option : T_IFACE T_STRING
> +{
> +	unsigned int idx;
> +
> +	__max_dedicated_links_reached();
> +
> +	strncpy(conf.channel[conf.channel_num].channel_ifname, $2, IFNAMSIZ=
);
> +
> +	idx =3D if_nametoindex($2);
> +	if (!idx) {
> +		print_err(CTD_CFG_WARN, "%s is an invalid interface", $2);
> +		break;
> +	}
> +};
> +
> +tipc_option : T_TIPC_MESSAGE_IMPORTANCE T_STRING
> +{
> +	if(!strcmp("LOW", $2))
> +		conf.channel[conf.channel_num].u.tipc.msgImportance =3D TIPC_LOW_I=
MPORTANCE;
> +	if(!strcmp("MEDIUM", $2))
> +		conf.channel[conf.channel_num].u.tipc.msgImportance =3D =20
> TIPC_MEDIUM_IMPORTANCE;
> +	if(!strcmp("HIGH", $2))
> +		conf.channel[conf.channel_num].u.tipc.msgImportance =3D =20
> TIPC_HIGH_IMPORTANCE;
> +	if(!strcmp("CRITICAL", $2))
> +		conf.channel[conf.channel_num].u.tipc.msgImportance =3D =20
> TIPC_CRITICAL_IMPORTANCE;
> +	if(conf.channel[conf.channel_num].u.tipc.msgImportance < =20
> TIPC_LOW_IMPORTANCE || =20
> conf.channel[conf.channel_num].u.tipc.msgImportance > =20
> TIPC_CRITICAL_IMPORTANCE) {
> +		print_err(CTD_CFG_WARN, "%s is an invalid message importance =20
> level (defaulting to TIPC_HIGH_IMPORTANCE)", $2);
> +		conf.channel[conf.channel_num].u.tipc.msgImportance =3D =20
> TIPC_HIGH_IMPORTANCE;
> +	}
> +};
> +
>  udp_line : T_UDP '{' udp_options '}'
>  {
>  	if (conf.channel_type_global !=3D CHANNEL_NONE &&
> @@ -800,6 +888,7 @@ sync_line: refreshtime
>  	 | multicast_line
>  	 | udp_line
>  	 | tcp_line
> +	 | tipc_line
>  	 | relax_transitions
>  	 | delay_destroy_msgs
>  	 | sync_mode_alarm
> @@ -861,7 +950,7 @@ option: T_EXPECT_SYNC '{' expect_list '}'
>  };
>
>  expect_list:
> -            | expect_list expect_item ;
> +	    | expect_list expect_item ;
>
>  expect_item: T_STRING
>  {
> @@ -887,8 +976,8 @@ sync_mode_alarm_list:
>  	      | sync_mode_alarm_list sync_mode_alarm_line;
>
>  sync_mode_alarm_line: refreshtime
> -              		 | expiretime
> -	     		 | timeout
> +			 | expiretime
> +			 | timeout
>  			 | purge
>  			 | relax_transitions
>  			 | delay_destroy_msgs
> @@ -1020,7 +1109,7 @@ tcp_state: T_ESTABLISHED
>  			    TCP_CONNTRACK_ESTABLISHED);
>
>  	__kernel_filter_add_state(TCP_CONNTRACK_ESTABLISHED);
> -};
> +}
>  tcp_state: T_FIN_WAIT
>  {
>  	ct_filter_add_state(STATE(us_filter),
> diff --git a/src/tipc.c b/src/tipc.c
> new file mode 100644
> index 0000000..37f6128
> --- /dev/null
> +++ b/src/tipc.c
> @@ -0,0 +1,252 @@
> +/*
> + *
> + * (C) 2012 by Quentin Aebischer <quentin.aebicher@usherbrooke.ca>
> + *
> + * Derived work based on mcast.c from:
> + *
> + * (C) 2006-2009 by Pablo Neira Ayuso <pablo@netfilter.org>
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License as published=
 by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + *
> + * Description: tipc socket library
> + */
> +
> +
> +#include "tipc.h"
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <arpa/inet.h>
> +#include <unistd.h>
> +#include <string.h>
> +#include <sys/ioctl.h>
> +#include <net/if.h>
> +#include <errno.h>
> +#include <limits.h>
> +#include <libnfnetlink/libnfnetlink.h>
> +
> +#ifdef CTD_TIPC_DEBUG
> +#include <fcntl.h> /* used for debug purposes */
> +#endif
> +
> +struct tipc_sock *tipc_server_create(struct tipc_conf *conf)
> +{
> +	struct tipc_sock *m;
> +
> +#ifdef CTD_TIPC_DEBUG
> +	int val =3D 0;
> +#endif
> +
> +	m =3D (struct tipc_sock *) malloc(sizeof(struct tipc_sock));
> +	if (!m)
> +		return NULL;
> +	memset(m, 0, sizeof(struct tipc_sock));
> +	m->sockaddr_len =3D sizeof(struct sockaddr_tipc);
> +
> +	m->addr.family =3D AF_TIPC;
> +	m->addr.addrtype =3D TIPC_ADDR_NAME;
> +	m->addr.scope =3D TIPC_CLUSTER_SCOPE;
> +	m->addr.addr.name.name.type =3D conf->server.type;
> +	m->addr.addr.name.name.instance =3D conf->server.instance;
> +
> +	if ((m->fd =3D socket(AF_TIPC, SOCK_RDM, 0)) =3D=3D -1) {
> +		free(m);
> +		return NULL;
> +	}
> +
> +#ifdef CTD_TIPC_DEBUG
> +	setsockopt(m->fd, SOL_TIPC, TIPC_DEST_DROPPABLE, &val, =20
> sizeof(val)); /*used for debug purposes */
> +#endif
> +	if (bind(m->fd, (struct sockaddr *) &m->addr, m->sockaddr_len) =3D=3D=
 -1) {
> +		close(m->fd);
> +		free(m);
> +		return NULL;
> +	}
> +
> +	return m;
> +}
> +
> +void tipc_server_destroy(struct tipc_sock *m)
> +{
> +	close(m->fd);
> +	free(m);
> +}
> +
> +struct tipc_sock *tipc_client_create(struct tipc_conf *conf)
> +{
> +	struct tipc_sock *m;
> +
> +	m =3D (struct tipc_sock *) malloc(sizeof(struct tipc_sock));
> +	if (!m)
> +		return NULL;
> +	memset(m, 0, sizeof(struct tipc_sock));
> +
> +	m->addr.family =3D AF_TIPC;
> +	m->addr.addrtype =3D TIPC_ADDR_NAME;
> +	m->addr.addr.name.name.type =3D conf->client.type;
> +	m->addr.addr.name.name.instance =3D conf->client.instance;
> +	m->addr.addr.name.domain =3D 0;
> +	m->sockaddr_len =3D sizeof(struct sockaddr_tipc);
> +
> +	if ((m->fd =3D socket(AF_TIPC, SOCK_RDM, 0)) =3D=3D -1) {
> +		free(m);
> +		return NULL;
> +	}
> +
> +#ifdef CTD_TIPC_DEBUG
> +	setsockopt(m->fd, SOL_TIPC, TIPC_DEST_DROPPABLE, &val, sizeof(val))=
;
> +	fcntl(m->fd, F_SETFL, O_NONBLOCK);
> +#endif
> +	setsockopt(m->fd, SOL_TIPC, TIPC_IMPORTANCE,  =20
> &conf->msgImportance, sizeof(conf->msgImportance));
> +
> +	return m;
> +}
> +
> +void tipc_client_destroy(struct tipc_sock *m)
> +{
> +	close(m->fd);
> +	free(m);
> +}
> +
> +ssize_t tipc_send(struct tipc_sock *m, const void *data, int size)
> +{
> +	ssize_t ret;
> +#ifdef CTD_TIPC_DEBUG
> +	char buf[50];
> +#endif
> +
> +	ret =3D sendto(m->fd,
> +		     data,
> +		     size,
> +		     0,
> +		     (struct sockaddr *) &m->addr,
> +		     m->sockaddr_len);
> +	if (ret =3D=3D -1) {
> +		m->stats.error++;
> +		return ret;
> +	}
> +
> +#ifdef CTD_TIPC_DEBUG
> +	if(!recv(m->fd,buf,sizeof(buf),0))
> +		m->stats.returned_messages++;
> +#endif
> +
> +	m->stats.bytes +=3D ret;
> +	m->stats.messages++;
> +
> +	return ret;
> +}
> +
> +ssize_t tipc_recv(struct tipc_sock *m, void *data, int size)
> +{
> +	ssize_t ret;
> +	socklen_t sin_size =3D sizeof(struct sockaddr_in);
> +
> +	ret =3D recvfrom(m->fd,
> +		       data,
> +		       size,
> +		       0,
> +		       (struct sockaddr *)&m->addr,
> +		       &sin_size);
> +	if (ret =3D=3D -1) {
> +		if (errno !=3D EAGAIN)
> +			m->stats.error++;
> +		return ret;
> +	}
> +
> +#ifdef CTD_TIPC_DEBUG
> +	if (!ret)
> +		m->stats.returned_messages++;
> +#endif
> +
> +	m->stats.bytes +=3D ret;
> +	m->stats.messages++;
> +
> +	return ret;
> +}
> +
> +int tipc_get_fd(struct tipc_sock *m)
> +{
> +	return m->fd;
> +}
> +
> +int tipc_isset(struct tipc_sock *m, fd_set *readfds)
> +{
> +	return FD_ISSET(m->fd, readfds);
> +}
> +
> +int
> +tipc_snprintf_stats(char *buf, size_t buflen, char *ifname,
> +		     struct tipc_stats *s, struct tipc_stats *r)
> +{
> +	size_t size;
> +
> +	size =3D snprintf(buf, buflen, "tipc traffic (active device=3D%s):\=
n"
> +				     "%20llu Bytes sent "
> +				     "%20llu Bytes recv\n"
> +				     "%20llu Pckts sent "
> +				     "%20llu Pckts recv\n"
> +				     "%20llu Error send "
> +				     "%20llu Error recv\n",
> +#ifdef CTD_TIPC_DEBUG
> +				     "%20llu Returned messages\n\n",
> +#endif
> +				     ifname,
> +				     (unsigned long long)s->bytes,
> +				     (unsigned long long)r->bytes,
> +				     (unsigned long long)s->messages,
> +				     (unsigned long long)r->messages,
> +				     (unsigned long long)s->error,
> +				     (unsigned long long)r->error)
> +#ifdef CTD_TIPC_DEBUG
> +				     (unsigned long long)s->returned_messages);
> +#else
> +				     ;
> +#endif
> +	return size;
> +}
> +
> +int
> +tipc_snprintf_stats2(char *buf, size_t buflen, const char *ifname,
> +		      const char *status, int active,
> +		      struct tipc_stats *s, struct tipc_stats *r)
> +{
> +	size_t size;
> +
> +	size =3D snprintf(buf, buflen,
> +			"tipc traffic device=3D%s status=3D%s role=3D%s:\n"
> +			"%20llu Bytes sent "
> +			"%20llu Bytes recv\n"
> +			"%20llu Pckts sent "
> +			"%20llu Pckts recv\n"
> +			"%20llu Error send "
> +			"%20llu Error recv\n",
> +#ifdef CTD_TIPC_DEBUG
> +			"%20llu Returned messages\n\n",
> +#endif
> +			ifname, status, active ? "ACTIVE" : "BACKUP",
> +			(unsigned long long)s->bytes,
> +			(unsigned long long)r->bytes,
> +			(unsigned long long)s->messages,
> +			(unsigned long long)r->messages,
> +			(unsigned long long)s->error,
> +			(unsigned long long)r->error);
> +#ifdef CTD_TIPC_DEBUG
> +			(unsigned long long)s->returned_messages);
> +#else
> +			;
> +#endif
> +	return size;
> +}
>
> Pablo Neira Ayuso <pablo@netfilter.org> a =C3=A9crit=C2=A0:
>
>> On Tue, Jan 24, 2012 at 12:00:58PM -0500, Quentin Aebischer wrote:
>>>> I think there are other flags that are useful in case you use TIPC=
 in
>>>> stream mode:
>>>>
>>>> CHANNEL_F_STREAM
>>>> CHANNEL_F_ERRORS
>>>>
>>>> BTW, does your patch support selecting what communication semantic=
s you
>>>> want to use for TIPC? In other words, what TIPC working mode are w=
e
>>>> using with your patch? (sorry, I'm lazy to look at your original p=
atch
>>>> to see it by myself). Please, justify.
>>>
>>> We are not using stream mode at the moment. We are using TIPC
>>> SOCK_RDM, which is like SOCK_DGRAM, but guarantees that every
>>> messages sent over the network is properly delivered to its
>>> destination node.
>>>
>>> There's no flow control mechanism when using SOCK_RDM in
>>> connectionless mode though (which is our case here), so if packets
>>> are not consumed fast enough on the receiver node side, they are
>>> queued up until we reach the maximum number of allowed messages in
>>> the queue. This maximum number is defined by the importance level o=
f
>>> the TIPC messages sent by the sender (which is now a custom
>>> parameter in conntrackd.conf like you suggested).
>>> When we hit the limit, we then enter congestion mode on the receivi=
ng node.
>>
>> Interesting. Please, in your follow-up patch, don't forget to extend
>> the example files under doc/sync/ to include some examples on how to
>> configure conntrackd with TIPC.
>>
>>> Here, depending on the value of SRC_DEST_DROPPABLE, we either
>>> silently drop the packets, or return them with an error code (which
>>> we can detect on the sender side by looking for the return value of
>>> rcv(), that's what I tried to implement for my debug operations).
>>
>> Thanks, very precise. It would be interesting to account those dropp=
ed
>> packets and to show them in the statistics (conntrackd -s).
>>
>>> So yeah, basically I don't know what CHANNEL_BUFFER does :X.
>>
>> if you activate CHANNEL_F_BUFFER, conntrackd may accumulate several
>> state-change messages in one packet. This reduces the pressure in th=
e
>> tx path since less packets are transmitted (in datagram mode, you se=
nd
>> one datagram per send system call). It's similar to TCP Nagle but it
>> is controled by conntrackd, instead of the underlying protocol stack=
=2E
>>
>> If you're using TIPC in datagram mode, this batching can be useful
>> to reduce CPU consumption. My suggestion is to enable it.
>> --
>> To unsubscribe from this list: send the line "unsubscribe =20
>> netfilter-devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
