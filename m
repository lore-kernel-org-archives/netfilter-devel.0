From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [PATCH] conntrack-tools: add conntrackd.conf(5) manpage
Date: Thu, 19 Nov 2015 13:46:45 +0100
Message-ID: <144793710566.22054.7165429515812452375.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:40360 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757785AbbKSMq4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Nov 2015 07:46:56 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This new manpage describes all the configuration options of the conntra=
ckd.conf
file.

While at it, point conntrackd(8) to this new manpage.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---

@Pablo: I let to you how to handle existing examples under doc/

 conntrackd.8      |    6=20
 conntrackd.conf.5 | 1071 +++++++++++++++++++++++++++++++++++++++++++++=
++++++++
 2 files changed, 1074 insertions(+), 3 deletions(-)
 create mode 100644 conntrackd.conf.5

diff --git a/conntrackd.8 b/conntrackd.8
index 455f6c5..1ac96a2 100644
--- a/conntrackd.8
+++ b/conntrackd.8
@@ -1,4 +1,4 @@
-.TH CONNTRACKD 8 "Sep 25, 2014" "" ""
+.TH CONNTRACKD 8 "Nov 19, 2015" "" ""
=20
 .\" Man page written by Pablo Neira Ayuso <pablo@netfilter.org> (Dec 2=
007)
=20
@@ -77,7 +77,7 @@ Display version information.
 Display help information.
 .TP
 .BI "-C config file"
-Configuration file path.
+Configuration file path. See \fBconntrackd.conf(5)\fP for details.
 .TP
 .SH DIAGNOSTICS
 The exit code is 0 for correct function. Errors cause an exit code of =
1.
@@ -106,7 +106,7 @@ The daemon requires a Linux kernel version >=3D 2.6=
=2E26 to support kernel-space eve
 During the 0.9.9 development, some important changes in the replicatio=
n message format were introduced. Therefore, conntrackd >=3D 0.9.9 will=
 not work appropriately with conntrackd <=3D 0.9.8. This should not be =
a problem if you use the same
 conntrackd version in all the firewall replica nodes.
 .SH SEE ALSO
-.BR conntrack (8), iptables (8)
+.BR conntrack (8), iptables (8), conntrackd.conf (5)
 .br
 See
 .BR "http://conntrack-tools.netfilter.org"
diff --git a/conntrackd.conf.5 b/conntrackd.conf.5
new file mode 100644
index 0000000..83253f6
--- /dev/null
+++ b/conntrackd.conf.5
@@ -0,0 +1,1071 @@
+.\"
+.\" (C) Copyright 2015, Arturo Borrero Gonzalez <arturo.borrero.glez@g=
mail.com>
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" This is free documentation; you can redistribute it and/or
+.\" modify it under the terms of the GNU General Public License as
+.\" published by the Free Software Foundation; either version 2 of
+.\" the License, or (at your option) any later version.
+.\"
+.\" The GNU General Public License's references to "object code"
+.\" and "executables" are to be interpreted as the output of any
+.\" document formatting or typesetting system, including
+.\" intermediate and printed output.
+.\"
+.\" This manual is distributed in the hope that it will be useful,
+.\" but WITHOUT ANY WARRANTY; without even the implied warranty of
+.\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+.\" GNU General Public License for more details.
+.\"
+.\" You should have received a copy of the GNU General Public
+.\" License along with this manual; if not, see
+.\" <http://www.gnu.org/licenses/>.
+.\" %%%LICENSE_END
+.\"
+.TH CONNTRACKD.CONF 5 "Nov 19, 2015"
+
+.SH NAME
+conntrackd.conf \- configuration file for conntrackd daemon
+
+.SH DESCRIPTION
+\fBconntrackd.conf\fP is the main configuration file for the
+\fBconntrackd(8)\fP daemon. It is loaded by calling `\fIconntrackd -C
+conntrackd.conf\fP'.
+
+The format of this file is simple, using brackets for sections and
+key-value pairs for concrete configuration directives:
+
+.nf
+	section1 {
+		option1 value1
+		option2 value2
+	}
+	section2 {
+		option3 value3
+		subsection1 {
+			option4 value4
+		}
+	}
+.fi
+
+You should consider this file as case-sensitive.
+Empty lines and lines starting with the '#' character are ignored.
+
+Before starting to develop a new configuration, you may want to learn =
the
+concepts behind this technlogy at
+\fIhttp://conntrack-tools.netfilter.org/manual.html\fP.
+
+There are complete configuration examples at the end of this man page.
+
+.SH SYNC
+
+This top-level section defines how \fBconntrackd(8)\fP should handle
+synchronization with other cluster nodes.
+
+There are 3 main synchronization modes or protocols: \fBNOTRACK\fP, \f=
BALARM\fP
+and \fBFTFW\fP.
+
+There are 3 transport protocols as well: \fBTCP\fP, \fBMulticast\fP
+and \fBUDP\fP.
+
+You have to choose one synchronization mode and one transport protocol=
=2E
+
+Also, there are some general options in this section.
+
+.SS Mode FTFW
+
+This mode is based on a reliable protocol that performs message tracki=
ng.
+Thus, the protocol can recover from message loss, re-ordering and corr=
uption.
+
+In this synchronization mode you may configure \fBResendQueueSize\fP,
+\fBCommitTimeout\fP, \fBPurgeTimeout\fP, \fBACKWindowSize\fP and
+\fBDisableExternalCache\fP.
+
+.TP
+.BI "ResendQueueSize <value>"
+Size of the resend queue (in objects). This is the maximum number of o=
bjects
+that can be stored waiting to be confirmed via acknoledgment.
+If you keep this value low, the daemon will have less chances to recov=
er
+state-changes under message omission. On the other hand, if you keep t=
his value
+high, the daemon will consume more memory to store dead objects.
+
+Example: ResendQueueSize 131072
+
+Default is 131072 objects.
+
+.TP
+.BI "CommitTimeout <seconds>"
+This parameter allows you to set an initial fixed timeout for the comm=
itted
+entries when this node goes from backup to primary. This mechanism pro=
vides
+a way to purge entries that were not recovered appropriately after the
+specified fixed timeout. If you set a low value, TCP entries in Establ=
ished
+states with no traffic may hang. For example, an SSH connection withou=
t
+KeepAlive enabled.
+
+Example: CommitTimeout 180
+
+By default, this option is not set (the daemon uses an approximate tim=
eout
+value calculation mechanism).
+
+.TP
+.BI "PurgeTimeout <seconds>"
+If the firewall replica goes from primary to backup, the
+`\fIconntrackd -t command\fP' is invoked in the script. This command s=
chedules
+a flush of the table in N seconds.
+
+This is useful to purge the connection tracking table of zombie entrie=
s and
+avoid clashes with old entries if you trigger several consecutive hand=
-overs.
+
+Default is 60 seconds.
+
+.TP
+.BI "ACKWindowSize <value>"
+Set the acknowledgement window size. If you decrease this value, the n=
umber of
+acknowlegdments increases. More acknowledgments means more overhead as
+\fBconntrackd(8)\fP has to handle more control messages. On the other =
hand, if
+you increase this value, the resend queue gets more populated. This re=
sults in
+more overhead in the queue releasing.
+
+Example: ACKWindowSize 300
+
+If not set, default window size is 300 (value is based on some practic=
al
+experiments measuring the cycles spent by the acknowledgment handling
+with oprofile).
+
+.TP
+.BI "DisableExternalCache <on|off>"
+This clause allows you to disable the external cache. Thus, the state =
entries
+are directly injected into the kernel conntrack table. As a result, yo=
u save
+memory in user-space but you consume slots in the kernel conntrack tab=
le for
+backup state entries. Moreover, disabling the external cache means mor=
e CPU
+consumption. You need a \fBLinux kernel >=3D 2.6.29\fP to use this fea=
ture.
+
+If you are installing \fBconntrackd(8)\fP for first time, please read =
the user
+manual and I encourage you to consider using the fail-over scripts ins=
tead of
+enabling this option!
+
+By default, this clause is set off.
+
+.SS Mode ALARM
+
+This mode is spamming. It is based on a alarm-based protocol that peri=
odically
+re-sends the flow state to the backup firewall replicas. This protocol=
 consumes
+a lot of bandwidth but it resolves synchronization problems fast.
+
+In this synchronization mode you may configure \fBRefreshTime\fP,
+\fBCacheTimeout\fP, \fBCommitTimeout\fP and \fBPurgeTimeout\fP.
+
+.TP
+.BI "RefreshTime <seconds>"
+If a conntrack entry is not modified in <=3D N seconds, then a message=
 is
+broadcasted. For example, this mechanism may be used to resynchronize =
nodes
+that just joined the multicast group.
+
+Example: RefreshTime 15
+
+.TP
+.BI "CacheTimeout <seconds>"
+If we don't receive a notification about the state of an entry in the
+external cache after N seconds, then remove it.
+
+Example: CacheTimeout 180
+
+.TP
+.BI "CommitTimeout <seconds>"
+Same as in \fBFTFW\fP mode.
+
+.TP
+.BI "PurgeTimeout <seconds>"
+Same as in \fBFTFW\fP mode.
+
+.SS Mode NOTRACK
+
+Is the most simple mode as it is based on a best effort replication pr=
otocol,
+ie. unreliable protocol. This protocol sends and receives the state in=
formation
+without performing any specific checking.
+
+In this synchronization mode you may configure \fBDisableInternalCache=
\fP,
+\fBDisableExternalCache\fP, \fBCommitTimeout\fP and \fBPurgeTimeout\fP=
=2E
+
+.TP
+.BI "DisableInternalCache <on|off>"
+This clause allows you to disable the internal cache. Thus, the synchr=
onization
+messages are directly sent through the dedicated link.
+
+This option is set off by default.
+
+.TP
+.BI "DisableExternalCache <on|off>"
+Same as in \fBFTFW\fP mode.
+
+.TP
+.BI "CommitTimeout <seconds>"
+Same as in \fBFTFW\fP mode.
+
+.TP
+.BI "PurgeTimeout <seconds>"
+Same as in \fBFTFW\fP mode.
+
+.SS MULTICAST
+
+This section indicates to \fBconntrackd(8)\fP to use multicast as tran=
sport
+mechanism between nodes of the firewall cluster.
+
+Please note you can specify more than one dedicated link. Thus, if one
+dedicated link fails, the daemon can fail-over to another. Note that a=
dding
+more than one dedicated link does not mean that state-updates will be =
sent to
+all of them. There is only one active dedicated link at a given moment=
=2E
+
+The \fIDefault\fP keyword indicates that this interface will be select=
ed as the
+initial dedicated link. You can have up to 4 redundant dedicated links=
=2E
+
+Note: use different multicast groups for every redundant link.
+
+Example:
+.nf
+	Multicast Default {
+		IPv4_address 225.0.0.51
+		Group 3781
+		IPv4_interface 192.168.100.101
+		Interface eth3
+		SndSocketBuffer 1249280
+		RcvSocketBuffer 1249280
+		Checksum on
+	}
+	Multicast {
+		IPv4_address 225.0.0.51
+		Group 3782
+		IPv4_interface 192.168.100.102
+		Interface eth4
+		SndSocketBuffer 1249280
+		RcvSocketBuffer 1249280
+		Checksum on
+	}
+.fi
+
+.TP
+.BI "IPv4_address <address>"
+Multicast address: The address that you use as destination in the
+synchronization messages. You do not have to add this IP to any of you=
r
+existing interfaces.
+
+Example: IPv4_address 255.0.0.50
+
+.TP
+.BI "Group <number>"
+The multicast group that identifies the cluster.
+
+Example: Group 3780
+
+If any doubt, do not modify this value.
+
+.TP
+.BI "IPv4_interface <address>"
+IP address of the interface that you are going to use to
+send the synchronization messages. Remember that you must
+use a dedicated link for the synchronization messages.
+
+Example:  IPv4_interface 192.168.100.100
+
+.TP
+.BI "Interface <name>"
+The name of the interface that you are going to use to send the synchr=
onization
+messages.
+
+Example: Interface eth2
+
+.TP
+.BI "SndSocketBuffer <number>"
+This transport protocol sender uses a buffer to enqueue the packets
+that are going to be transmitted. The default size of this socket buff=
er is
+available at \fB/proc/sys/net/core/wmem_default\fP.
+
+This value determines the chances to have an overrun in the sender que=
ue. The
+overrun results in packet loss, thus, losing state information that wo=
uld have
+to be retransmitted. If you notice some packet loss, you may want to i=
ncrease
+the size of the buffer. The system default size is usually around
+~100 KBytes which is fairly small for busy firewalls.
+
+Note: The \fBNOTRACK\fP protocol is best effort, it is really recommen=
ded
+to increase the buffer size.
+
+Example: SndSocketBuffer 1249280
+
+.TP
+.BI "RcvSocketBuffer <number>"
+This transport protocol receiver uses a buffer to enqueue the
+packets that the socket is pending to handle. The default size of this=
 socket
+buffer is available at \fB/proc/sys/net/core/rmem_default\fP.
+
+This value determines the chances to have an overrun in the receiver q=
ueue.
+The overrun results in packet loss, thus, losing state information tha=
t would
+have to be retransmitted. If you notice some packet loss, you may want=
 to
+increase the size of the buffer. The system default size is usually
+around ~100 KBytes which is fairly small for busy firewalls.
+
+Note: The \fBNOTRACK\fP protocol is best effort, it is really recommen=
ded
+to increase the buffer size.
+
+Example: RcvSocketBuffer 1249280
+
+.TP
+.BI "Checksum <on|off>"
+Enable/Disable message checksumming. This is a good property to achiev=
e
+fault-tolerance. In case of doubt, use it.
+
+.SS UDP
+This section indicates to \fBconntrackd(8)\fP to use UDP as transport
+mechanism between nodes of the firewall cluster.
+
+As in the \fBMulticast\fP configuration, you may especify several fail=
-over
+dedicated links using the \fIDefault\fP keyword.
+
+Example:
+.nf
+	UDP {
+		IPv4_address 172.16.0.1
+		IPv4_Destination_Address 172.16.0.2
+		Port 3781
+		Interface eth3
+		SndSocketBuffer 1249280
+		RcvSocketBuffer 1249280
+		Checksum on
+	}
+.fi
+
+.TP
+.BI "IPv4_address <address>"
+UDP IPv4 address that this firewall uses to listen to events.
+
+Example: IPv4_address 192.168.2.100
+
+.TP
+.BI "IPv6_address <address>"
+UDP IPv6 address that this firewall uses to listen to events.
+
+Example: IPv6_address fe80::215:58ff:fe28:5a27
+
+.TP
+.BI "IPv4_Destination_Address <address>"
+Destination IPv4 UDP address that receives events, ie. the other firew=
all's
+dedicated link address.
+
+Example: IPv4_Destination_Address 192.168.2.101
+
+.TP
+.BI "IPv6_Destionation_Address <address>"
+Destination IPv6 UDP address that receives events, ie. the other firew=
all's
+dedicated link address.
+
+Example: IPv6_Destination_Address fe80::2d0:59ff:fe2a:775c
+
+.TP
+.BI "Port <number>"
+UDP port used
+
+Example: Port 3780
+
+.TP
+.BI "Interface <name>"
+Same as in the \fBMulticast\fP transport protocol configuration.
+
+.TP
+.BI "SndSocketBuffer <number>"
+Same as in the \fBMulticast\fP transport protocol configuration.
+
+.TP
+.BI "RcvSocketBuffer <number>"
+Same as in the \fBMulticast\fP transport protocol configuration.
+
+.TP
+.BI "Checksum <on|off>"
+Same as in the \fBMulticast\fP transport protocol configuration.
+
+
+.SS TCP
+You can also use Unicast TCP to propagate events.
+
+If you combine this transport with the \fBNOTRACK\fP mode, it becomes =
reliable.
+
+The TCP transport protocol can be configured in exactly the same way a=
s
+the \fBUDP\fP transport protocol.
+
+As in the \fBMulticast\fP configuration, you may especify several fail=
-over
+dedicated links using the \fIDefault\fP keyword.
+
+Example:
+.nf
+	TCP {
+		IPv6_address fe80::215:58ff:fe28:5a27
+		IPv6_Destination_Address fe80::215:58ff:fe28:5a27
+		Port 3781
+		Interface eth2
+		SndSocketBuffer 1249280
+		RcvSocketBuffer 1249280
+		Checksum on
+	}
+.fi
+
+.SS OPTIONS
+
+Other unsorted options that are related to the synchronization protoco=
l
+or transport mechanism.
+
+.TP
+.BI "TCPWindowTracking <on|off>"
+TCP state-entries have window tracking disabled by default, you can en=
able it
+with this option. As said, default is off.
+This feature requires a \fBLinux kernel >=3D 2.6.36\fP.
+
+.TP
+.BI "ExpectationSync <on|{ list }>"
+Set this option on if you want to enable the synchronization of expect=
ations.
+You have to specify the list of helpers that you want to enable.
+
+This feature requires a \fBLinux kernel >=3D 3.5\fP.
+
+Example, sync all expectations:
+.nf
+	ExpectationSync on
+.fi
+
+Example, sync given expectations:
+.nf
+	ExpectationSync {
+		ftp
+		ras
+		q.931
+		h.245
+		sip
+	}
+.fi
+
+By default, this option is disabled.
+
+.SH GENERAL
+
+This top-level section contains generic configuration directives for t=
he
+\fBconntrackd(8)\fP daemon.
+
+.TP
+.BI "Systemd <on|off>"
+Enable \fBsystemd(1)\fP runtime support if \fBconntrackd(8)\fP is comp=
iled
+with the proper configuration. Then you can use a service unit of
+\fIType=3Dnotify\fP.
+
+Obviusly, this requires the init systemd of your system to be \fBsyste=
md(1)\fP.
+
+Note: \fBsystemd(1)\fP watchdog is supported as well.
+
+Example: Systemd off
+
+By default runtime support is activated.
+
+.TP
+.BI "Nice <value>"
+Set the \fBnice(1)\fP value of the daemon, this value goes from -20 (m=
ost
+favorable scheduling) to 19 (least favorable). Using a very low value =
reduces
+the chances to lose state-change events.
+
+Example: Nice -20
+
+Default is 0 but this example sets it to most favourable scheduling as
+this is generally a good idea.
+
+.TP
+.BI "HashSize <value>"
+Number of buckets in the cache hashtable. The bigger it is, the closer=
 it gets
+to \fIO(1)\fP at the cost of consuming more memory. Read some document=
s about
+tuning hashtables for further reference.
+
+Example: HashSize 32768
+
+.TP
+.BI "HashLimit <value>"
+Maximum number of conntracks, it should be double of
+\fB/proc/sys/net/netfilter/nf_conntrack_max\fP since the daemon may ke=
ep some
+dead entries cached for possible retransmission during state synchroni=
zation.
+
+Example: HashLimit 131072
+
+.TP
+.BI "LogFile <on|off|filename>"
+Enable \fBconntrackd(8)\fP to log to a file.
+
+Example: LogFile on
+
+Default is off. The default logfile is \fB/var/log/conntrackd.log\fP.
+
+.TP
+.BI "Syslog <on|off|facility>"
+Enable connection logging via Syslog. If you set the facility, use the=
 same as
+in the \fBStats\fP section, otherwise you'll get a warning message.
+
+Example: Syslog local0
+
+Default is off.
+
+.TP
+.BI "Lockfile <filename>"
+Lockfile to be used by \fBconntrackd(8)\fP (absolute path).
+
+Example: LockFile /var/lock/conntrack.lock
+
+Default is \fB/var/lock/conntrack.lock\fP.
+
+.TP
+.BI "NetlinkBufferSize <value>"
+Netlink event socket buffer size. If you do not specify this clause, t=
he
+default buffer size value in \fB/proc/net/core/rmem_default\fP is used=
=2E This
+default value is usually around \fB100 Kbytes\fP which is fairly small=
 for
+busy firewalls. This leads to event message dropping and high CPU cons=
umption.
+
+Example: NetlinkBufferSize 2097152
+
+.TP
+.BI "NetlinkBufferSizeMaxGrowth <value>"
+The daemon doubles the size of the netlink event socket buffer size if=
 it
+detects netlink event message dropping. This clause sets the maximum b=
uffer
+size growth that can be reached.
+
+Example:  NetlinkBufferSizeMaxGrowth 8388608
+
+.TP
+.BI "NetlinkOverrunResync <on|off|value>"
+If the daemon detects that Netlink is dropping state-change events, it
+automatically schedules a resynchronization against the Kernel after 3=
0 seconds
+(default value). Resynchronizations are expensive in terms of CPU cons=
umption
+since the daemon has to get the full kernel state-table and purge stat=
e-entries
+that do not exist anymore.
+
+Note: Be careful of setting a very small value here.
+
+Example: NetlinkOverrunResync on
+
+The default value is \fB30\fP seconds.
+If not specified, the daemon assumes that this option is enabled and u=
ses the
+default value.
+
+.TP
+.BI "NetlinkEventsReliable <on|off>"
+If you want reliable event reporting over Netlink, set on this option.=
 If you
+set on this clause, it is a good idea to set off \fBNetlinkOverrunResy=
nc\fP.
+
+You need \fBLinux Kernel >=3D 2.6.31\fP for this option to work.
+
+Example: NetlinkEventsReliable on
+
+This option is off by default.
+
+.TP
+.BI "PollSecs <seconds>"
+By default, the daemon receives state updates following an event-drive=
n model.
+You can modify this behaviour by switching to polling mode with this c=
lause.
+
+This clause tells \fBconntrackd(8)\fP to dump the states in the kernel=
 every N
+seconds. With regards to synchronization mode, the polling mode can on=
ly
+guarantee that long-lifetime states are recovered. The main advantage =
of this
+method is the reduction in the state replication at the cost of reduci=
ng the
+chances of recovering connections.
+
+Example: PollSecs 15
+
+.TP
+.BI "EventIterationLimit <value>"
+The daemon prioritizes the handling of state-change events coming from=
 the
+core. With this clause, you can set the maximum number of state-change=
 events
+(those coming from kernel-space) that the daemon will handle after whi=
ch it
+will handle other events coming from the network or userspace.
+
+A low value improves interactivity (in terms of real-time behaviour) a=
t the
+cost of extra CPU consumption.
+
+Example: EventIterationLimit 100
+
+Default (if not set) is 100.
+
+.SS UNIX
+Unix socket configuration. This socket is used by \fBconntrackd(8)\fP =
to listen
+to external commands like `\fIconntrackd -k\fP' or `\fIconntrackd -n\f=
P'.
+
+Example:
+.nf
+	UNIX {
+		Path /var/run/conntrackd.ctl
+		Backlog 20
+	}
+.fi
+
+.TP
+.BI "Path <filename>"
+Absolute path to the Unix socket.
+
+Example: Path /var/run/conntrackd.ctl
+
+.TP
+.BI "Backlog <value>"
+Number of items in the backlog.
+
+Example: Backlog 20
+
+.SS FILTER
+Event filtering. This clause allows you to filter certain traffic.
+
+There are currently three filter-sets: \fBProtocol\fP, \fBAddress\fP a=
nd
+\fBState\fP. The filter is attached to an action that can be: \fBAccep=
t\fP or
+\fBIgnore\fP. Thus, you can define the event filtering policy of the
+filter-sets in positive or negative logic depending on your needs.
+
+You can select if \fBconntrackd(8)\fP filters the event messages from
+user-space or kernel-space. The kernel-space event filtering saves som=
e CPU
+cycles by avoiding the copy of the event message from kernel-space to
+user-space. The kernel-space event filtering is prefered, however, you=
 require
+a \fBLinux kernel >=3D 2.6.29\fP to filter from kernel-space.
+
+The syntax for this section is: \fBFilter From <from> { }\fP.
+
+If you want to select kernel-space event filtering, use the keyword
+\fBKernelspace\fP instead of \fBUserspace\fP.
+
+Example:
+.nf
+	Filter From Userspace {
+		Protocol Accept {
+			TCP
+			SCTP
+			DCCP
+		}
+		Address Ignore {
+			IPv4_address 127.0.0.1
+			IPv6_address ::1
+		}
+		State Accept {
+			ESTABLISHED CLOSED TIME_WAIT CLOSE_WAIT
+		}
+	}
+.fi
+
+.TP
+.BI "Protocol <policy> { <protocols list> }"
+Accept only certain protocols: You may want to replicate the state of =
flows
+depending on their layer 4 protocol.
+
+Policy is one of \fBAccept\fP or \fBIgnore\fP.
+
+Protocols are: \fBTCP\fP, \fBSCTP\fP, \fBDCCP\fP, \fBUDP\fP, \fBICMP\f=
P and
+\fBIPv6-ICMP\fP.
+
+The \fBICMP\fP and \fBIPv6-ICMP\fP protocols require a
+\fBLinux kernel >=3D 2.6.31\fP.
+
+Example:
+.nf
+	Protocol Accept {
+		TCP
+		SCTP
+		DCCP
+	}
+.fi
+
+.TP
+.BI "Address <policy> { <addresses list> }"
+Ignore traffic for a certain set of IP's: Usually all the IP assigned =
to the
+firewall since local traffic must be ignored, only forwarded connectio=
ns are
+worth to replicate.
+
+Note that these values depends on the local IPs that are assigned to t=
he
+firewall.
+
+You may specify several \fBIPv4_address\fP and/or \fBIPv6_address\fP
+directives. You can also specify networks in CIDR format.
+
+Policy is one of \fBAccept\fP or \fBIgnore\fP.
+
+Example:
+.nf
+	Address Ignore {
+		IPv4_address 127.0.0.1 # loopback
+		IPv4_address 192.168.0.100 # virtual IP 1
+		IPv4_address 192.168.1.100 # virtual IP 2
+		IPv4_address 192.168.100.100 # dedicated link ip
+		IPv4_address 192.168.0.0/24
+		IPv6_address ::1
+	}
+.fi
+
+.TP
+.BI "State <policy> { <states list> }"
+Filter by flow state.  This option introduces a trade-off in the repli=
cation:
+it reduces CPU consumption at the cost of having lazy backup firewall =
replicas.
+
+Note: only affects TCP flows.
+
+The existing TCP states are: \fBSYN_SENT\fP, \fBSYN_RECV\fP, \fBESTABL=
ISHED\fP,
+\fBFIN_WAIT\fP, \fBCLOSE_WAIT\fP, \fBLAST_ACK\fP, \fBTIME_WAIT\fP,
+\fBCLOSED\fP and \fBLISTEN\fP.
+
+Policy is one of \fBAccept\fP or \fBIgnore\fP.
+
+Example:
+.nf
+	State Accept {
+		ESTABLISHED CLOSED TIME_WAIT CLOSE_WAIT
+	}
+.fi
+
+.SS SCHEDULER
+Select a different scheduler for the daemon, you can select between \f=
BRR\fP
+and \fBFIFO\fP and the process priority.
+
+See \fBsched_setscheduler(2)\fP for more information. Using a RT sched=
uler
+reduces the chances to overrun the Netlink buffer.
+
+Example:
+.nf
+	Scheduler {
+		Type FIFO
+		Priority 99
+	}
+.fi
+
+.TP
+.BI "Type <type>"
+Supported values are \fBRR\fP or \fBFIFO\fP.
+
+.TP
+.BI "Priority <value>"
+Value of the scheduler priority.
+
+Minimum is 0, maximum is 99.
+
+.SH STATS
+This top-level section indicates \fBconntrackd(8)\fP to work as a stat=
istic
+collector for the nf_conntrack linux kernel subsystem.
+
+.TP
+.BI "LogFile <on|off|filename>"
+If you enable this option, the daemon writes the information about des=
troyed
+connections to a logfile.
+
+Default is off. Default filename is \fB/var/log/conntrackd-stats.log\f=
P.
+
+.TP
+.BI "NetlinkEventsReliable <on|off>"
+If you want reliable event reporting over Netlink, set on this option.=
 If
+you set on this clause, it is a good idea to set off
+\fBNetlinkOverrunResync\fP. This requires \fBLinux kernel >=3D 2.6.31\=
fP.
+
+Default is off.
+
+.TP
+.BI "Syslog <on|off|facility>"
+Enable connection logging via Syslog.
+If you set the facility, use the same as in the \fBGeneral\fP section,
+otherwise you'll get a warning message.
+
+Example: Syslog local0
+
+Default is off.
+
+.SH HELPER
+Note: this configuration is very advanced and has nothing to do with
+synchronization or stats collection.
+
+This top-level section indicates \fBconntrackd(8)\fP to inject user-sp=
ace
+helpers into the nf_conntrack linux kernel subsystem.
+It will result in the nf_conntrack engine sending connections to users=
pace
+for further processing.
+
+Before this, you have to make sure you have registered the given user-=
space
+helper stub.
+
+Example:
+.nf
+	% nfct add helper ftp inet tcp
+.fi
+
+Each user-space helper should be registered using a Type section, whic=
h
+are named this way:
+.nf
+	\fBType <name> <af> <transport>\fP
+.fi
+
+Examples:
+
+.nf
+Helper {
+	Type ftp inet tcp {
+		QueueNum 0
+		QueueLen 10240
+		Policy ftp {
+			ExpectMax 1
+			ExpectTimeout 300
+		}
+	}
+	Type rpc inet tcp {
+		QueueNum 1
+		QueueLen 10240
+		Policy rpc {
+			ExpectMax 1
+			ExpectTimeout 300
+		}
+	}
+	Type rpc inet udp {
+		QueueNum 2
+		QueueLen 10240
+		Policy rpc {
+			ExpectMax 1
+			ExpectTimeout 300
+		}
+	}
+	Type tns inet tcp {
+		QueueNum 3
+		QueueLen 10240
+		Policy tns {
+			ExpectMax 1
+			ExpectTimeout 300
+		}
+	}
+	Type dhcpv6 inet6 udp {
+		QueueNum 4
+		QueueLen 10240
+		Policy dhcpv6 {
+			ExpectMax 1
+			ExpectTimeout 300
+		}
+	}
+	Type ssdp inet udp {
+		QueueNum 5
+		QueueLen 10240
+		Policy ssdp {
+			ExpectMax 1
+			ExpectTimeout 300
+		}
+	}
+}
+.fi
+
+Parameters inside the \fBType\fP section:
+
+.TP
+.BI "QueueNum <number>"
+Set NFQUEUE number you want to use to receive traffic from the kernel.
+
+Example: QueueNum 0
+
+.TP
+.BI "QueueLen <number>"
+Maximum number of packets waiting in the queue to receive a verdict fr=
om
+user-space.
+
+Rise value if you hit the following error message:
+.nf
+	"nf_queue: full at X entries, dropping packet(s)"
+.fi
+
+Default is 1024.
+
+Example: QueueLen 10240
+
+.TP
+.BI "Policy <name> { }"
+Set the expectation policy for the given helper.
+
+This sub-section contains 2 directives:
+\fBExpectMax <number>\fP (maximum number of simultaneous expectations)
+and \fBExpecTimeout <seconds>\fP (maximum living time for one expectat=
ion).
+
+.SH COMPLETE EXAMPLES
+Find below some real-life working examples.
+
+.SS STATS EXAMPLE
+This configuration example tells \fBconntrackd(8)\fP to work as a stat=
s
+collector.
+
+.nf
+Stats {
+	LogFile on
+	NetlinkEventsReliable Off
+	Syslog off
+}
+General {
+	Systemd on
+	Nice -1
+	HashSize 8192
+	HashLimit 65535
+	Syslog on
+	LockFile /var/lock/conntrack.lock
+	UNIX {
+		Path /var/run/conntrackd.ctl
+		Backlog 20
+	}
+	NetlinkBufferSize 262142
+	NetlinkBufferSizeMaxGrowth 655355
+	Filter {
+		Protocol Accept {
+			TCP
+			UDP
+		}
+		Address Ignore {
+			IPv4_address 127.0.0.1
+			IPv6_address ::1
+		}
+	}
+}
+.fi
+
+.SS SYNC EXAMPLE 1
+This example configures synchronization in \fBFTFW\fP mode with \fBMul=
ticast\fP
+transport.
+
+It includes common general configuration as well.
+
+Note: this is one of the recommended setups for \fBconntrackd(8)\fP in=
 a
+firewall cluster environment.
+
+.nf
+Sync {
+	Mode FTFW {
+		ResendQueueSize 131072
+		PurgeTimeout 60
+		ACKWindowSize 300
+		DisableExternalCache Off
+	}
+	Multicast {
+		IPv4_address 225.0.0.50
+		Group 3780
+		IPv4_interface 192.168.100.100
+		Interface eth2
+		SndSocketBuffer 1249280
+		RcvSocketBuffer 1249280
+		Checksum on
+	}
+	Multicast Default {
+		IPv4_address 225.0.0.51
+		Group 3781
+		IPv4_interface 192.168.100.101
+		Interface eth3
+		SndSocketBuffer 1249280
+		RcvSocketBuffer 1249280
+		Checksum on
+	}
+	Options {
+		TCPWindowTracking Off
+		ExpectationSync On
+	}
+}
+General {
+	Systemd on
+	Nice -20
+	Scheduler {
+		Type FIFO
+		Priority 99
+	}
+	HashSize 32768
+	HashLimit 131072
+	LogFile on
+	Syslog off
+	LockFile /var/lock/conntrack.lock
+	UNIX {
+		Path /var/run/conntrackd.ctl
+		Backlog 20
+	}
+	NetlinkBufferSize 2097152
+	NetlinkBufferSizeMaxGrowth 8388608
+	NetlinkOverrunResync On
+	NetlinkEventsReliable Off
+	EventIterationLimit 100
+	Filter From Userspace {
+		Protocol Accept {
+			TCP
+			SCTP
+			DCCP
+		}
+		Address Ignore {
+			IPv4_address 127.0.0.1
+			IPv4_address 192.168.100.0/24
+			IPv6_address ::1
+		}
+	}
+}
+.fi
+
+.SS SYNC EXAMPLE 2
+
+This example configures synchronization in \fBNOTRACK\fP mode with \fB=
TCP\fP
+transport.
+
+It includes common general configuration as well.
+
+.nf
+Sync {
+	Mode NOTRACK {
+		DisableInternalCache on
+		DisableExternalCache on
+	}
+	TCP {
+		IPv4_address 192.168.2.100
+		IPv4_Destination_Address 192.168.2.101
+		Port 3780
+		Interface eth2
+		SndSocketBuffer 1249280
+		RcvSocketBuffer 1249280
+		Checksum on
+	}
+	Options {
+		TCPWindowTracking Off
+		ExpectationSync On
+	}
+}
+General {
+	Systemd on
+	Nice -20
+	Scheduler {
+		Type FIFO
+		Priority 99
+	}
+	HashSize 32768
+	HashLimit 131072
+	LogFile on
+	Syslog off
+	LockFile /var/lock/conntrack.lock
+	UNIX {
+		Path /var/run/conntrackd.ctl
+		Backlog 20
+	}
+	NetlinkBufferSize 2097152
+	NetlinkBufferSizeMaxGrowth 8388608
+	NetlinkOverrunResync On
+	NetlinkEventsReliable Off
+	EventIterationLimit 100
+	Filter From Userspace {
+		Protocol Accept {
+			TCP
+			SCTP
+			DCCP
+		}
+		Address Ignore {
+			IPv4_address 127.0.0.1
+			IPv4_address 192.168.0.0/16
+			IPv6_address ::1
+		}
+		State Accept {
+			ESTABLISHED CLOSED TIME_WAIT CLOSE_WAIT
+		}
+	}
+}
+.fi
+
+
+.SH SEE ALSO
+.BR conntrackd(8),
+.BR conntrack(8),
+.BR nfct(8),
+.BR http://conntrack-tools.netfilter.org/manual.html
+
+.SH AUTHOR
+This manual page was written by Arturo Borrero Gonz=C3=A1lez
+<arturo.borrero.glez@gmail.com> based on the conntrackd tarball config
+examples.
+
+It's free/libre documentation (GPL-2+).

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
