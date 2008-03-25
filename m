From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: ebtables and iptables different behavior between 2.6.18 on fc6 and 2.6.23 on fc8
Date: Mon, 24 Mar 2008 20:18:00 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A226A019@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.infrasupportetc.com ([66.173.97.5]:46622 "EHLO
	mail733.InfraSupportEtc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753552AbYCYBdM convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Mar 2008 21:33:12 -0400
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This issue cost me most of a night's sleep and it will take me a few
paragraphs to describe.  The one sentence summary is, marking packets
with ebtables and reading later with iptables seems to behave
differently with 2.6.23 than it did with 2.6.18 and earlier.  

I put together a firewall system based on fc8 and the RedHat kernel that
ships with fc8.  I think this one is 2.6.23-2.  My previous latest and
greatest was with a 2.6.18 variant that shipped with fc6.  

This config requires that I bridge.  I need to bridge because I have
various H.323 videoconference codecs behind the firewall system and some
of these, especially older ones, do not work very well with NAT.  The
other choice besides bridging is proxy ARP, but I learned the hard way
that proxy ARP is horrible in colocation situations.  So I need to
bridge.  

But I also need NAT to handle traditional PCs and other stuff behind the
firewall.  

To make this work, I need to know which way packets are headed.  I need
to know on which interface packets come in, and which interface they go
out.  This is easy with routing, more challenging with bridging.
iptables had a facility that would let me test --physdev with bridged
packets.  It might still be there but I remember reading a discussion
about how this violated layering and would not be supported long term.  

So I found another way.  Ebtables lets me mark packets based on the
physical interface in or out.  In the broute table of ebtables, I can
mark packets in from the Internet with "1", and packets in from the LAN
side with "2".  I also need to know the interface on which packets go
out, so I mark those with "3" in the FORWARD and OUTPUT chains of the
filter table.  

And then later on, I can test the marks with iptables and take
appropriate actions depending on the direction of packet travel.  

Here is the ebtables code to do that, extracted from a very long
rc.firewall script - hopefully this won't be garbled in this post.  


echo "Flushing and zeroing all ebtables tables and chains"
$EBTABLES -t broute -F
$EBTABLES -t broute -Z
$EBTABLES -t filter -F
$EBTABLES -t filter -Z
$EBTABLES -t nat -F
$EBTABLES -t nat -Z

#
# Use ebtables to mark packets based on the in/out interface.
# 1 - (bit 0 set) for packets entering on the Internet physical
interface
# 2 - (bit 1 set) for packets entering on the trusted physical interface
# 3 - (bits 0 and 1) for packets exiting via the Internet physical
interface

echo "Marking bridged packets at layer 2 for later layer 3 filtering."
$EBTABLES -t broute -A BROUTING -i $INET_IFACE \
	-j mark --mark-set 1 --mark-target CONTINUE
$EBTABLES -t broute -A BROUTING -i $TRUSTED1_IFACE \
	-j mark --mark-set 2 --mark-target CONTINUE
$EBTABLES -t filter -A FORWARD -o $INET_IFACE \
	-j mark --mark-set 3 --mark-target CONTINUE
$EBTABLES -t filter -A OUTPUT -o $INET_IFACE \
	-j mark --mark-set 3 --mark-target CONTINUE


With that background, here is the problem.

None of my packets that were supposed to have that "3" mark ever kept
them.  For some reason, they either never were marked or they were
marked and then the mark disappeared.  The packets with "1" and "2"
worked just fine.  I set up tons of logging to chase that down.  But the
packets with "3" were not marked.  

Needless to say, this created major havoc with my network routing.  The
good news is, it only kept me up all night and none of the users at this
site ever knew anything was messed up.  

I built two nearly identical systems.  One with fc6, the other with fc8.
I set them up with the exact same IP Addresses and identical copies of
my rc.firewall script.  The only difference between them were various
logging and debug lines I inserted into my rc.firewall script at
different times to chase down the marking.  The fc6 system worked as I
expected, the fc8 system did not.

And now I can reproduce the problem here under controlled conditions.  

So my questions - what changed with the interaction betweem iptables and
ebtables?  Is there a supported way I can track the physical interfaces
on which packets come in and go out that I can count on for the
indefinite future?  Or did I uncover an obscure bug with
ebtables/iptables?  

I have test systems and a simulated environment right here so I can try
different kernel combinations if needed.  

Thanks

- Greg Scott
