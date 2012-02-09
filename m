From: Quentin Aebischer <Quentin.Aebischer@USherbrooke.ca>
Subject: Re: [PATCH] conntrackd: basic TIPC implementation for NOTRACK mode
Date: Thu, 09 Feb 2012 15:44:09 -0500
Message-ID: <20120209154409.56706d629575wnk8@www.usherbrooke.ca>
References: <20120121085217.4272940o8fmk4v80@www.usherbrooke.ca>
 <20120122174140.GA18764@1984>
 <20120122162720.10123t2longq3zac@www.usherbrooke.ca>
 <20120123100733.GB23857@1984>
 <20120123132537.198937ydqdx1n3gg@www.usherbrooke.ca>
 <20120124010145.GA28314@1984>
 <20120124120058.234342gq75ohof6s@www.usherbrooke.ca>
 <20120126001928.GA10554@1984>
 <20120126211344.33964cmak17akti0@www.usherbrooke.ca>
 <20120126214641.82372un6d7dcc46c@www.usherbrooke.ca>
 <20120208004216.GC29189@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpi4.USherbrooke.ca ([132.210.236.3]:33448 "EHLO
	smtpi4.usherbrooke.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814Ab2BIUoZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:44:25 -0500
In-Reply-To: <20120208004216.GC29189@1984>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks for your comments Pablo,

I added a small paragraph on the conntrack-tools.tmpl like you suggeste=
d.
I understood that you wanted the default TIPC conntrackd.conf to =20
replace the TCP conntrackd.conf on the notrack directory, so that's =20
what I did.

 From : Quentin Aebischer <quentin.aebischer@usherbrooke.ca>

  - Added documentation to the conntrack-tools for the TIPC protocol =20
with NOTRACK mode.

Signed-off-by: Quentin Aebischer <quentin.aebischer@usherbrooke.ca>
---
  doc/manual/conntrack-tools.tmpl  |   17 ++++--
  doc/sync/notrack/README          |   16 ++++-
  doc/sync/notrack/conntrackd.conf |  119 +++++++++++++++++++----------=
--------
  3 files changed, 86 insertions(+), 66 deletions(-)

diff --git a/doc/manual/conntrack-tools.tmpl b/doc/manual/conntrack-too=
ls.tmpl
index 4936a76..40c331c 100644
--- a/doc/manual/conntrack-tools.tmpl
+++ b/doc/manual/conntrack-tools.tmpl
@@ -573,20 +573,27 @@ Sync {
  </sect3>

  <sect3 id=3D"sync-transport-protocol">
-<title>Using UDP, TCP or multicast for flow-state synchronization</tit=
le>
+
+<title>Using UDP, multicast, TCP or TIPC for flow-state =20
synchronization</title>

   <para>You can use up to three different transport layer protocols to
- synchronize flow-state changes between the firewalls: UDP, TCP and
- Multicast. UDP and multicast are unreliable but together with the FT-=
=46W
- mode provide partial reliable flow-state synchronization.
+ synchronize flow-state changes between the firewalls: UDP, TCP, =20
Multicast and
+TIPC. UDP and multicast are unreliable but together with the FT-FW
+ mode provide partial reliable flow-state synchronization. TIPC provid=
es a
+connectionless yet reliable message-based delivery system.
   </para>

- <para>The preferred choice is FT-FW over UDP, or multicast alternativ=
ely.
+ <para>The preferred choice is FT-FW over UDP unicast/multicast, or =20
TIPC alternatively.
   TCP introduces latency in the flow-state synchronization due to the
   congestion control. Under flow-state message are lost, the FIFO deli=
very
   becomes also a problem since the backup firewall quickly gets out of
   sync. For that reason, its use is discouraged. Note that using TCP o=
nly
   makes sense with the NOTRACK mode.
+ TIPC provides some kind of link level sequencing in order to =20
guarantee succesfull
+ delivery of messages between nodes in the cluster. Hence, it is =20
recommended to use it
+ along with NOTRACK mode to minimise protocol overhead on the =20
firewalls dedicated link.
+ Further informations on how to configure TIPC can be found in the =20
README file under
+ the doc/notrack/ directory
   </para>

  </sect3>
diff --git a/doc/sync/notrack/README b/doc/sync/notrack/README
index b064e21..e7afcc7 100644
--- a/doc/sync/notrack/README
+++ b/doc/sync/notrack/README
@@ -1,3 +1,13 @@
-This directory contains the files for the NOTRACK replication protocol=
=2E This
-protocol provides best effort delivery. Therefore, it is unreliable un=
less
-that you select TCP-based state-synchronization.
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
diff --git a/doc/sync/notrack/conntrackd.conf =20
b/doc/sync/notrack/conntrackd.conf
index 34e7b32..acfc91b 100644
--- a/doc/sync/notrack/conntrackd.conf
+++ b/doc/sync/notrack/conntrackd.conf
@@ -4,6 +4,17 @@
  Sync {
  	Mode NOTRACK {
  		#
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
  		# This parameter allows you to set an initial fixed timeout
  		# for the committed entries when this node goes from backup
  		# to primary. This mechanism provides a way to purge entries
@@ -26,14 +37,19 @@ Sync {
  		#
  		# PurgeTimeout 60

+		# Set the acknowledgement window size. If you decrease this
+		# value, the number of acknowlegdments increases. More
+		# acknowledgments means more overhead as conntrackd has to
+		# handle more control messages. On the other hand, if you
+		# increase this value, the resend queue gets more populated.
+		# This results in more overhead in the queue releasing.
+		# The following value is based on some practical experiments
+		# measuring the cycles spent by the acknowledgment handling
+		# with oprofile. If not set, default window size is 300.
  		#
-		# This clause allows you to disable the internal cache. Thus,
-		# the synchronization messages are directly send through
-		# the dedicated link. This option is set of off by default.
-		#
-		# DisableInternalCache Off
+		# ACKWindowSize 300

-		#
+		#
  		# This clause allows you to disable the external cache. Thus,
  		# the state entries are directly injected into the kernel
  		# conntrack table. As a result, you save memory in user-space
@@ -57,33 +73,33 @@ Sync {
  	#	iptables -I INPUT -d 225.0.0.50 -j ACCEPT
  	#	iptables -I OUTPUT -d 225.0.0.50 -j ACCEPT
  	#
-	Multicast {
+	# Multicast {
  		#
  		# Multicast address: The address that you use as destination
  		# in the synchronization messages. You do not have to add
  		# this IP to any of your existing interfaces. If any doubt,
  		# do not modify this value.
  		#
-		IPv4_address 225.0.0.50
+		# IPv4_address 225.0.0.50

  		#
  		# The multicast group that identifies the cluster. If any
  		# doubt, do not modify this value.
  		#
-		Group 3780
+		# Group 3780

  		#
  		# IP address of the interface that you are going to use to
  		# send the synchronization messages. Remember that you must
  		# use a dedicated link for the synchronization messages.
  		#
-		IPv4_interface 192.168.100.100
+		# IPv4_interface 192.168.100.100

  		#
  		# The name of the interface that you are going to use to
  		# send the synchronization messages.
  		#
-		Interface eth2
+		# Interface eth2

  		# The multicast sender uses a buffer to enqueue the packets
  		# that are going to be transmitted. The default size of this
@@ -94,10 +110,8 @@ Sync {
  		# notice some packet loss, you may want to increase the size
  		# of the sender buffer. The default size is usually around
  		# ~100 KBytes which is fairly small for busy firewalls.
-		# Note: This protocol is best effort, it is really recommended
-		# to increase the buffer size.
  		#
-		SndSocketBuffer 1249280
+		# SndSocketBuffer 1249280

  		# The multicast receiver uses a buffer to enqueue the packets
  		# that the socket is pending to handle. The default size of this
@@ -106,20 +120,18 @@ Sync {
  		# receiver queue. The overrun results packet loss, thus, losing
  		# state information that would have to be retransmitted. If you
  		# notice some packet loss, you may want to increase the size of
-		# of the sender buffer. The default size is usually around
+		# the receiver buffer. The default size is usually around
  		# ~100 KBytes which is fairly small for busy firewalls.
-		# Note: This protocol is best effort, it is really recommended
-		# to increase the buffer size.
  		#
-		RcvSocketBuffer 1249280
+		# RcvSocketBuffer 1249280

-		#
+		#
  		# Enable/Disable message checksumming. This is a good
  		# property to achieve fault-tolerance. In case of doubt, do
  		# not modify this value.
  		#
-		Checksum on
-	}
+		# Checksum on
+	# }
  	#
  	# You can specify more than one dedicated link. Thus, if one dedicat=
ed
  	# link fails, conntrackd can fail-over to another. Note that adding
@@ -192,60 +204,50 @@ Sync {
  		# Checksum on
  	# }

-	#
-	# You can also use Unicast TCP to propagate events. Thus, the NOTRACK
-	# mode becomes reliable.
-	#
-	# TCP {
-		#
-		# TCP address that this firewall uses to listen to events.
-		#
-		# IPv4_address 192.168.2.100
-		#
-		# or you may want to use an IPv6 address:
-		#
-		# IPv6_address fe80::215:58ff:fe28:5a27
-
+	TIPC {
  		#
-		# Destination TCP address that receives events, ie. the other
-		# firewall's dedicated link address.
+		# Name of the other TIPC port in the cluster (in the form type:insta=
nce)
  		#
-		# IPv4_Destination_Address 192.168.2.101
+		  TIPC_Destination_Name 1000:51
+
  		#
-		# or you may want to use an IPv6 address:
+		# Name of the local TIPC port (used to listen to events)
  		#
-		# IPv6_Destination_Address fe80::2d0:59ff:fe2a:775c
+		  TIPC_Name 1000:50

  		#
-		# TCP port used
+		# The name of the TIPC configured interface that you are going to us=
e
+		# to send synchronization messages.
  		#
-		# Port 3780
-
+		  Interface eth0
+
  		#
-		# The name of the interface that you are going to use to
-		# send the synchronization messages.
+		# The importance of the TIPC messages sent (the more important
+		# this is, the more packets will be enabled to queue up on the
+		# slave).
+		# This should be set to High or Critical to avoid congestion
+		# on the receiver side.
+		# (possible values : LOW, MEDIUM, HIGH, CRITICAL)
  		#
-		# Interface eth2
+		  TIPC_Message_Importance HIGH

  		#
  		# The sender socket buffer size
-		#
-		# SndSocketBuffer 1249280
+		#
+		#  SndSocketBuffer 1249280

  		#
  		# The receiver socket buffer size
  		#
-		# RcvSocketBuffer 1249280
+		#  RcvSocketBuffer 1249280

-		#
-		# Enable/Disable message checksumming.
  		#
-		# Checksum on
-	# }
+		# Current TIPC implementation doesnt allow checksumming
+	}

-	#
+	#
  	# Other unsorted options that are related to the synchronization.
-	#
+	#
  	# Options {
  		#
  		# TCP state-entries have window tracking disabled by default,
@@ -259,9 +261,9 @@ Sync {
  		# you want to enable. Default is off.
  		#
  		# ExpectationSync {
-		#       ftp
-		#       h323
-		#       sip
+		#	ftp
+		#	h323
+		#	sip
  		# }
  		#
  		# You can use this alternatively:
@@ -368,6 +370,7 @@ General {
  	#
  	# NetlinkOverrunResync On

+	#
  	# If you want reliable event reporting over Netlink, set on this
  	# option. If you set on this clause, it is a good idea to set off
  	# NetlinkOverrunResync. This option is off by default and you need


Pablo Neira Ayuso <pablo@netfilter.org> a =C3=A9crit=C2=A0:

> On Thu, Jan 26, 2012 at 09:46:41PM -0500, Quentin Aebischer wrote:
>> Sorry, forgot to add conntrackd.conf example and README files ...
>>
>> From : Quentin Aebischer <quentin.aebischer@usherbrooke.ca>
>>
>> Example file conntrackd.conf and README for TIPC implementation of
>> the conntrackd daemon.
>>
>> Signed-off-by: Quentin Aebischer <quentin.aebischer@usherbrooke.ca>
>> ---
>>  doc/sync/tipc/README          |   13 ++
>
> I'd appreciate if you can send me a patch for the
> doc/manual/conntrack-tools.tmpl instead.
>
> I suggest you to add a small paragraph at "Other configuration
> options".
>
>>  doc/sync/tipc/conntrackd.conf |  454
>> +++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 467 insertions(+), 0 deletions(-)
>>
>> diff --git a/doc/sync/tipc/README b/doc/sync/tipc/README
>> new file mode 100644
>> index 0000000..e7afcc7
>> --- /dev/null
>> +++ b/doc/sync/tipc/README
>> @@ -0,0 +1,13 @@
>> +Installation instructions :
>> +
>> +TIPC is a built-in kernel module since kernel version 2.6.35 ;
>> please make sure your using a =3D> 2.6.35 kernel with TIPC 2.0, as
>> this patch has not been tested with older versions of the protocol
>> yet.
>> +
>> +For easy and fast configuration, you must install the TIPC utilies
>> v2.0.0, available from sources here :
>> +
>> +    git://tipc.git.sourceforge.net/gitroot/tipc/tipcutils (branch
>> tipcutils2.0)
>> +
>> +or by using aptitude on debian distributions :
>> +
>> +    sudo apt-get install tipcutils
>> +
>> +For further details on installation, node and network
>> configuration, please refer to the online documentation : =20
>> http://tipc.sourceforge.net/doc/tipc_2.0_users_guide.html#installati=
on.
>> diff --git a/doc/sync/tipc/conntrackd.conf b/doc/sync/tipc/conntrack=
d.conf
>> new file mode 100644
>> index 0000000..71946ec
>> --- /dev/null
>> +++ b/doc/sync/tipc/conntrackd.conf
>> @@ -0,0 +1,454 @@
>> +#
>> +# Synchronizer settings
>> +#
>> +Sync {
>> +	Mode NOTRACK {
>
> Better, add this example to the existing notrack file.
>
> More specifically, this part below just after the commented UDP and
> Multicast examples.
>
>> +	TIPC {
>> +		#
>> +		# Name of the other TIPC port in the cluster (in the form type:in=
stance)
>
> Please, break lines at 80 char, btw.
>
>> +		#
>> +		  TIPC_Destination_Name 1000:51
>> +
>> +		#
>> +		# Name of the local TIPC port (used to listen to events)
>> +		#
>> +		  TIPC_Name 1000:50
>> +
>> +		#
>> +		# The name of the TIPC configured interface that you are going to=
 use
>> +		# to send synchronization messages.
>> +		#
>> +		  Interface eth0
>> +
>> +		#
>> +		# The importance of the TIPC messages sent (the more important
>> this is, the more packets will be enabled to queue up on the slave)
>> +		# This should be set to High or Critical to avoid congestion on
>> the receiver side.
>> +		# (possible values : TIPC_LOW_IMPORTANCE, TIPC_MEDIUM_IMPORTANCE,
>> TIPC_HIGH_IMPORTANCE, TIPC_CRITICAL_IMPROTANCE)
>> +		#
>> +		  TIPC_Message_Importance TIPC_CRITICAL_IMPORTANCE
>> +
>> +		#
>> +		# Current TIPC implementation doesnt allow checksumming
>> +	}
>
> Thanks Quentin.
>
>



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
