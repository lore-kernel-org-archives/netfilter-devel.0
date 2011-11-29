From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: doc: Secure use of iptables and connection tracking helpers
Date: Tue, 29 Nov 2011 01:55:56 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1111290131470.408@frira.zrqbmnf.qr>
References: <1322501576.20587.22.camel@tiger.regit.org>  <alpine.LNX.2.01.1111282118430.27238@frira.zrqbmnf.qr> <1322521080.24083.1.camel@tiger.regit.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:47283 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab1K2Az6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Nov 2011 19:55:58 -0500
In-Reply-To: <1322521080.24083.1.camel@tiger.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2011-11-28 23:58, Eric Leblond wrote:
>> >HTML version: http://home.regit.org/netfilter-en/secure-use-of-helpers/
>> >PDF version:
>> >http://home.regit.org/wp-content/uploads/2011/11/helper-recommandation.pdf
>
>I've just setup a github repository to host the file. It is available
>here:
>	https://github.com/regit/secure-conntrack-helpers


>"This system lays on parsing of data coming or from the user or from
>the server."
>
>"we put protocol features which lead to have the user to choose some
>parameters."

lay/put is inaccurate here; what was the origin French words
you thought of here?

>"Linux provides a routing based implementation of reverse path
>filtering." ... "There is at the time of the writing no
>routing-based implementation of `rp_filter` in the Linux kernel."

These statements seem to contradict themselves.


Here's a patch so far.

parent 290cb9996fb87876dd73d9b066320c42ea395810 ()
commit e169ba81c02d42e9d1987b18ad89c7c023aff229
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Nov 29 01:52:05 2011 +0100

Grammar and spelling fixes
---
 secure-conntrack-helpers.rst |  123 ++++++++++++++++++----------------
 1 files changed, 64 insertions(+), 59 deletions(-)

diff --git a/secure-conntrack-helpers.rst b/secure-conntrack-helpers.rst
index bfc6228..9bb9cd3 100644
--- a/secure-conntrack-helpers.rst
+++ b/secure-conntrack-helpers.rst
@@ -10,10 +10,11 @@ Principle of helpers
 --------------------
 
 Some protocols use different flows for signalling and data tranfers.  This is
-the case of FTP, SIP and H.323 among many others. In the setup stage, it is
-common that the the signalling flow is used to negociate the configuration
-parameters for the establishment of the data flow, ie. the IP and port that
-are used to establish the data flow. This sort of protocols are particularly
+the case for FTP, SIP and H.323 among many others. In the setup stage, it is
+common that the the signalling flow is used to negotiate the configuration
+parameters for the establishment of the data flow,
+i.e. the IP address and port that
+are used to establish the data flow. These sort of protocols are particularly
 harder to filter by firewalls since they violate layering by introducing OSI
 layer 3/4 parameters in the OSI layer 7.
 
@@ -21,13 +22,14 @@ In order to overcome this situation in the iptables firewall, Netfilter
 provides the Connection Tracking helpers, which are modules that are able
 to assist the firewall in tracking these protocols.  These helpers create
 the so-called expectations, as defined by the Netfilter project jargon.
-An expectation is similar to a connection tracking entry but it is stored in
-a separate table and as generally a limited duration. Expectation are used to
+An expectation is similar to a connection tracking entry, but it is stored in
+a separate table and generally with a limited duration.
+Expectations are used to
 signal the kernel that in the coming seconds, if a packet with corresponding
-parameters reach the firewall, then this packet is RELATED to the previous
+parameters reaches the firewall, then this packet is RELATED to the previous
 connection.
 
-These kind of packets can then be authorized thanks to module like state or
+These kind of packets can then be authorized thanks to modules like state or
 conntrack which can match RELATED packets.
 
 This system lays on parsing of data coming or from the user or from the server.
@@ -37,25 +39,26 @@ when using connection tracking helpers.
 Connection Tracking helpers default configuration
 -------------------------------------------------
 
-Due to protocol constraints, all helper are not equals. For example, the FTP
-helper will create an expectation where IP parameters are the two peers. The
-IRC helper create expectation where destination address is the client address
+Due to protocol constraints, not all helpers are equal. For example, the FTP
+helper will create an expectation whose IP parameters are the two peers. The
+IRC helper creates expectations whose destination address is the client address
 and source address is any address. This is due to the protocol: we do not know
-the IP adress of the person who is target of the DCC.
+the IP address of the person who is the target of the DCC.
 
-The degree of freedom due to connection tracking helpers are thus dependant of
-the natur of the protocol. Some protocols have dangerous extensions and this
-ones are disabled by defaut by Netfilter. Under the dangerous term, we put
-protocols features which lead to have the user to choose some parameters.
-For example, FTP protocol can let the user choose to have the target server
-connect to an other arbitrary server. This could lead to hole in DMZ and it
-is thus desactivated by default.
+The degree of freedom due to connection tracking helpers are thus dependent on
+the nature of the protocol. Some protocols have dangerous extensions, and these
+are disabled by defaut by Netfilter. Under these dangerous conditions, we put
+protocol features which lead to have the user to choose some parameters.
+For example, the FTP protocol can let the user choose to have the target server
+connect to another arbitrary server. This could lead to a hole in the
+DMZ and it
+is thus deactivated by default.
 
-The following list describes the differents connection tracking helpers
+The following list describes the different connection tracking helper
 modules and their associated degree of freedom.
 
 ==============  ==============  ===========  ===================  ================  ========  ===================================
-Module          Source address  Port Source  Destination address  Destination port  Protocol  Option
+Module          Source address  Source Port  Destination address  Destination port  Protocol  Option
 --------------  --------------  -----------  -------------------  ----------------  --------  -----------------------------------
 amanda          Fixed           0-65535      Fixed                In CMD            TCP 
 ftp             Fixed           0-65535      In CMD               In CMD            TCP       loose = 1 (default)
@@ -75,21 +78,21 @@ tftp            Fixed           0-65535      Fixed                In Packet
 
 The following keywords are used:
 
- - Fixed: Value of a connection tracking attribute is used. This is not a candidate to forgery.
- - In CMD: Value is fetch from the payload. This is a candidate to forgery.
+ - Fixed: Value of a connection tracking attribute is used. This is not a candidate for forgery.
+ - In CMD: Value is fetched from the payload. This is a candidate for forgery.
 
-The option are module loading option. They permit to activate the
+The options are module loading options. They permit to activate the
 extended but dangerous features of some protocols.
 
 Secure use of Connection Tracking Helpers
 =========================================
 
-Following the preceedings remarks, it appears that it is necessary to not
+Following the preceeding remarks, it appears that it is necessary to not
 blindly use helpers. You must take into account the topology of your network
-when setting parameters linked with helper.
+when setting parameters linked to a helper.
 
-For each helper, you must open carefully the RELATED flow. All iptables line
-using " -m state --state RELATED" should be used in conjonction with the
+For each helper, you must carefully open the RELATED flow. All iptables lines
+using "-m state --state RELATED" should be used in conjunction with the
 choice of a helper.  Doing that, you will be able to describe how the helper
 must be used with respect to your network and information system architecture.
 
@@ -102,7 +105,7 @@ For example, if you run an FTP server, you can setup ::
  	--helper ftp -d $MY_FTP_SERVER -p tcp \
 	--dport 1024: -j ACCEPT
 
-If your clients are authorized to access to FTP outside of your network you
+If your clients are authorized to access FTP outside of your network, you
 can add ::
 
  iptables -A FORWARD -m state --state RELATED -m helper \
@@ -124,8 +127,8 @@ The same syntax applies to IPV6 ::
 Example: SIP helper
 -------------------
 
-You should limit the connection RELATED due to the SIP helper by restricting
-the destination address to the RTP servers farm of your provider ::
+You should limit the RELATED connection due to the SIP helper by restricting
+the destination address to the RTP server farm of your provider ::
 
  iptables -A FORWARD -m state --state RELATED -m helper \
  	--helper sip -d $ISP_RTP_SERVER -p udp -j ACCEPT
@@ -134,39 +137,39 @@ Example: h323 helper
 --------------------
 
 The issue is the same as the one described for SIP, you should limit the
-opening of the RELATED connection to the RTP servers address of your VOIP
+opening of the RELATED connection to the RTP server addresses of your VOIP
 provider.
 
 Securing the signalling flow
 ----------------------------
 
 You will also need to build carefully crafted rules for the authorization
-of flow involving connection tracking helpers. And in particular, you have
+of flows involving connection tracking helpers. In particular, you have
 to do a strict antispoofing (has described below) to avoid traffic injection
 from other interfaces.
 
 
-Use CT target to refine security
-================================
+Using the CT target to refine security
+======================================
 
 Introduction
 ------------
 
-One classical problem with helpers is the fact that helpers listen on
+One classic problem with helpers is the fact that helpers listen on
 predefined ports.  If a service does not run on standard port, it is
 necessary to declare it. Before 2.6.34, the only method to do so was
 to use a module option. This was resulting in having a systematic
 parsing of the added port by the choosen helper. This was clearly
 suboptimal and the CT target has been introduced in 2.6.34. It allows
 to specify what helper to use for a specific flow.  For exemple, let's
-say we have a FTP server at IP 1.2.3.4 running on port 2121.
+say we have a FTP server at IP address 1.2.3.4 running on port 2121.
 
-To declare it we can simply do ::
+To declare it, we can simply do ::
  
  iptables -A PREROUTING -t raw -p tcp --dport 2121 \
  	-d 1.2.3.4 -j CT --helper ftp
 
-We thus recommand NOT to use module option anymore and use the CT target
+We thus recommand NOT to use module options anymore, and use the CT target
 instead.
 
 Disable helper by default
@@ -174,20 +177,21 @@ Disable helper by default
 Principle
 ~~~~~~~~~
 
-Once an helper is loaded, it will treat the packet for a given port and all IP.
-As explained before this is not optimal and is even a security risk. A better
-solution is to load the module helper and desactivate their parsing by default.
+Once a helper is loaded, it will treat packets for a given port and all IP
+addresses.
+As explained before, this is not optimal and is even a security risk. A better
+solution is to load the module helper and deactivate their parsing by default.
 Each wanted helper use is then set by using a call to the CT target.
 
 Method
 ~~~~~~
 
 It is possible to obtain this behaviour for most connection tracking helper
-module by setting to 0 the port number for the module. For example ::
+modules by setting the port number to 0 for the module. For example ::
 
  modprobe nf_conntrack_$PROTO ports=0
 
-The following modules will be desactivated on all flows by default by doing
+The following modules will be deactivated on all flows by default by doing
 this:
 
  - ftp
@@ -196,7 +200,7 @@ this:
  - sip
  - tftp
 
-Some modules will no work dut to the abscence of ports parameter:
+Some modules will not work due to the abscence of ports parameter:
 
  - amanda
  - h323
@@ -211,8 +215,8 @@ Helpers and antispoofing
 ------------------------
 
 Helper lays on the parsing of data that come from client or from server. It
-is thus important to limit spoofing attack that could be used to feed the
-helpers with forged datas. Helpers are IP only and are not doing, as the
+is thus important to limit spoofing attacks that could be used to feed the
+helpers with forged data. Helpers are IP only and are not doing, as the
 rest of the connection tracking, any coherence check on the network
 architecture.
 
@@ -220,8 +224,8 @@ Using rp_filter
 ---------------
 
 Linux provides a routing based implementation of reverse path filtering.
-This is available for IPv4.  To activate it you need to ensure that the
-`/proc/sys/net/ipv4/conf/*/rp_filter` files contains 1.  The complete
+This is available for IPv4.  To activate it, you need to ensure that the
+`/proc/sys/net/ipv4/conf/*/rp_filter` files contain 1.  The complete
 documentation about `rp_filter` is available in the file `ip-sysctl.txt`
 in the `Documentation/networking/` directory of the Linux tree.
 
@@ -233,13 +237,13 @@ The documentation at the time of the writing is reproduced here ::
         Reverse Path. Each incoming packet is
         tested against the FIB and if the interface
         is not the best reverse path the packet
-        check will fail. By default failed packets
+        check will fail. By default, failed packets
         are discarded.
     2 - Loose mode as defined in RFC3704 Loose
         Reverse Path. Each incoming packet's source
         address is also tested against the FIB
         and if the source address is not reachable
-        via any interface the packet check will fail.
+        via any interface, the packet check will fail.
 
     Current recommended practice in RFC3704 is to
     enable strict mode to prevent IP spoofing from
@@ -261,17 +265,18 @@ is thus needed.
 Manual anti-spoofing
 --------------------
 
-The best way to do anit-spoofing is to use filtering rules in the RAW table.
+The best way to do anti-spoofing is to use filtering rules in the RAW table.
 This has the great advantage of shortcutting the connection tracking. This
-help to reduce the load that could be created by some flooding.
+helps to reduce the load that could be created by some flooding.
 
-The antispoofing must be done a a per-interface way. For each interface,
-we must list the authorized network on the interface. There is an exception
+The antispoofing must be done on a per-interface basis. For each interface,
+we must list the authorized network on the interface. There is an exception,
 which is the interface with the default route where an inverted logic must
-be used. In our example, let's take eth1 which is a LAN interface and have
-eth0 the interface with the default route. Let's also have $NET_ETH1 being
+be used. In our example, let's take eth1, which is a LAN interface, and have
+eth0 being the interface with the default route.
+Let's also have $NET_ETH1 being
 the network connected to $ETH1 and $ROUTED_VIA_ETH1 a network routed by this
-interface. With that setup, we can do antispoofing with the following rules ::
+interface. With this setup, we can do antispoofing with the following rules ::
 
  iptables -A PREROUTING -t raw -i eth0 -s $NET_ETH1 -j DROP
  iptables -A PREROUTING -t raw -i eth0 -s $ROUTED_VIA_ETH1 -j DROP
@@ -283,6 +288,6 @@ The IPv6 case is similar if we omit the case of the local link network ::
 
  ip6tables -A PREROUTING -t raw -i eth0 -s $NET_ETH1 -j DROP
  ip6tables -A PREROUTING -t raw -i eth0 -s $ROUTED_VIA_ETH1 -j DROP
- ip6tables -A PREROUTING -t raw fe80::/64 -j ACCEPT
+ ip6tables -A PREROUTING -t raw -s fe80::/64 -j ACCEPT
  ip6tables -A PREROUTING -t raw -i eth1 -s $NET_ETH1 -j ACCEPT
  ip6tables -A PREROUTING -t raw -i eth1 -s $ROUTED_VIA_ETH1 -j ACCEPT
-- 
# Created with git-export-patch
