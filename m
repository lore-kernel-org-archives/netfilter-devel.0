From: Robby <inet6@mail.be>
Subject: Re: pom-ng TRACE patch: unable to find ladd slot in src
  ./net/ipv6/Config.in
Date: Tue, 17 Feb 2004 23:31:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <5.2.1.1.2.20040217230231.00b25e18@wheresmymailserver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Cc: Netfilter development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Well, I'm currently busy with it and I have a patch and mail ready for 
sending, but I'm not sending it as it seems to be breaking some things in a 
"make menuconfig".
The Kernel is 2.4.25-rc3, but that's not the cause of the errors in the 
pom-ng cvs it's the missing files (Config.in.ladd and Makefile.ladd) in 
ROUTE and TRACE, but
actually they're not missing, they are present in the directory above, they 
basicly just need to be moved, but again, something seems to break and even 
then, pom-ng
still has some bugs I noticed when looking in Documentation/Configure.help 
some things are missing and the wrong things are being put in the file 
(although this does
not happen with every patch as you can see below (like the string patch for 
example is being added correctly).

Like for example when adding the h323-conntrack-nat (or the rtsp and/or 
mms) patch (with ./runme extra) this gets inserted in 
Documentation/Configure.help:
***[BEGIN OF PASTE]

IP tables support (required for filtering/masq/NAT)
CONFIG_IP_NF_IPTABLES
   iptables is a general, extensible packet identification framework.
   The packet filtering and full NAT (masquerading, port forwarding,
   etc) subsystems now use this: say `Y' or `M' here if you want to use
   either of those.

   If you want to compile it as a module, say M here and read
   <file:Documentation/modules.txt>.  If unsure, say `N'.


-----------------[THINGS ARE WRONG STARTING FROM HERE]----------------------

   This adds CONFIG_IP_NF_H323: H.323/netmeeting support module for netfilter
   connection tracking and NAT. H.323 uses/relies on the following data 
streams:

         Port            Description
         389             Internet Locator Server (TCP)
         522             User Location Server (TCP)
         1503            T.120 Protocol (TCP)
         1720            H.323 (H.225 call setup, TCP)
         1731            Audio call control (TCP)
         Dynamic         H.245 call control (TCP)
         Dynamic         RTCP/RTP streaming (UDP)

   The H.323 conntrack/NAT modules support the connection tracking/NATing of
   the data streams requested on the dynamic ports. The helpers use the
   search/replace hack from the ip_masq_h323.c module for the 2.2 kernel
   series.

   At the very minimum, H.323/netmeeting (video/audio) is functional by letting
   trough the 1720 port and loading these H.323 module(s).

   The H.323 conntrack/NAT modules do not support

   - H.245 tunnelling
   - H.225 RAS (gatekeepers)





   This adds CONFIG_IP_NF_MMS: support for Microsoft Streaming Media
   Services. This allows client (Windows Media Player) and server
   to negotiate protocol (UDP, TCP) and port for the media stream.

   A partially reverse engineered protocol analysis is available
   from http://get.to/sdp, together with a link to a Linux client.

   By default, the helper module tracks TCP traffic over port 1755
   and adds the necessary UPD or TCP expectation. It is recommended
   to also open UDP port 1755 to the server, as this port is used
   for retransmission requests.

   This helper has been tested in SNAT and DNAT setups.

   Note that this helper has *nothing* to do with ip_masq_mms for
   2.2 kernels!





   This patch adds CONFIG_IP_NF_RTSP: support for the RTSP protocol.

   This allows UDP transports to be setup properly, including RTP and RDT.

------------------------------------[THINGS ARE RIGHT 
AGAIN]----------------------------------

String match support (EXPERIMENTAL)
CONFIG_IP_NF_MATCH_STRING

   This patch adds CONFIG_IP_NF_MATCH_STRING which allows you to
   match a string in a whole packet.

   THIS PATCH DOES NOT WORK WITH KERNEL 2.4.9 !!!

***[END OF PASTE]

When actually THIS needs to be inserted:
* for the rtsp-conntrack patch:
RTSP protocol support
CONFIG_IP_NF_RTSP
   Support the RTSP protocol.  This allows UDP transports to be setup
   properly, including RTP and RDT.

   If you want to compile it as a module, say 'M' here and read
   Documentation/modules.txt.  If unsure, say 'Y'.

* for the h323-conntrack-nat patch:
H.323 (netmeeting) support
CONFIG_IP_NF_H323
   H.323 is a standard signalling protocol used by teleconferencing
   softwares like netmeeting. With the ip_conntrack_h323 and
   the ip_nat_h323 modules you can support the protocol on a connection
   tracking/NATing firewall.

   If you want to compile it as a module, say 'M' here and read
   Documentation/modules.txt.  If unsure, say 'N'.

Etcetera....
So I'm currently boggled with this... (and I'm not really a developer, 
although smaller things are not a problem, but this...)
I'm very close to use the old patch-o-matic again, and checking the new 
patch-o-matic-ng patches for new code and if so, eventually merge it with 
my old
patch-o-matic for local use because the new system is still bugged.

 > ----------------------------------------
 > From: Henrik Nordstrom <hno@marasystems.com>
 > Sent: Tue Feb 17 23:00:22 CET 2004
 > To: Robby <inet6@mail.be>
 > Subject: Re: pom-ng TRACE patch: unable to find ladd slot in src
 >  ./net/ipv6/Config.in
 >
 >
 > On Tue, 17 Feb 2004, Robby wrote:
 >
 > > Testing TRACE... not applied
 > > The TRACE patch:
 > >     Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
 > >     Status: Testing.
 > > [...]
 > > -----------------------------------------------------------------
 > > Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?] t
 > > unable to find ladd slot in src ./net/ipv6/Config.in
 > > -----------------------------------------------------------------
 > > Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?]
 >
 >
 > Kernel version?
 >
 > Mind to try to make a patch to correct the problem?
 >
 > (the first line of the ladd file is the line after which the new option
 > should be added)
 >
 > Regards
 > Henrik
 >
 >


--
Robby 
