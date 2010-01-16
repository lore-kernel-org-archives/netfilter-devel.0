From: Greg Alexander <greqcs@galexander.org>
Subject: Two patches for nf_conntrack_sip
Date: Sat, 16 Jan 2010 05:36:40 -0500
Message-ID: <20100116103640.GB11547@goonies.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shed.goonies.be ([64.62.190.177]:43755 "EHLO shed.goonies.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab0APKp6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Jan 2010 05:45:58 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello fellow hackers -

I uncovered some issues with net/netfilter/nf_conntrack_sip.c while using
my softphone across a Linux NAT gateway.  I am using Linux 2.6.27.37, so
I hope that this email is still pertinent!  Since I don't know how we
feel about attachments here, I've put the three patches at:
   http://galexander.org/nf_sip/patch1
   http://galexander.org/nf_sip/patch2

And in case you don't bother reading the rest of the email, I want to say
thank you!!  to all of the people who made this system work.  It is a
little frustrating to have to debug it but the quantity and quality of
work that went into it is obvious.  It is great that I get to submit two
one-character patches and pretend that I'm saving the day. :)


patch1 is an off-by-one.  It broke most translation on compact SIP
headers.  In a string like "v:SIP/2.0..." it was checking for
!isalpha('S') when it meant to be inspecting the ':'.


patch2 changes the default for "sip_direct_media" value.

A little detail about SIP (RFC3261).  SIP is a protocol for interacting
with a network of proxies to initiate a direct connection with another
party, whose IP address you do not know at the beginning of the
transaction. Each party sends their IP address/port number to the other
through SIP. As I understand it, we only track one side (outgoing) of the
SIP conversation, so we do not know the address/port that the other party
will be using.

When sip_direct_media is true, it assumes that the remote party's IP
address is the same as the address of the SIP proxy we have been
communicating with.  This is wrong, and will almost never work, as the
explicit purpose of SIP is to use a proxy to determine the location of a
remote peer -- the scenarios where they are at the same IP address are
almost inconceivable.

When sip_direct_media is false, it makes no assumptions about the remote
party's IP.  In general I think it will find the next packet that comes
in to the correct destination port (the one in the expect record) and
then use the associated source IP/port for the NAT. This is also wrong,
but less so.  It allows someone who is snooping the traffic to hijack the
connection (though you could argue once someone has that level of access,
the game is up anyways).  There may also be one other disadvantage...I do
not understand netfilter well enough to say with certainty what would
happen if two connections originated at about the same time that
attempted to use the same source UDP port.  It seems like there's at
least the possibility for a race condition that would result in the
streams being crossed.

On balance, sip_direct_media=0 is better than 1 because it works in a far
greater number of scenarios and requires either a large volume of traffic
or a coordinated attack to show any downsides.  My patch changes the
default to 0.

The correct answer of course is to observe both sides of the SIP dialogue
and precisely match the source address as well as the destination address
of the expected packet.  I'd like to see this happen.  I'm not sure I'm
volunteering because even if I find the time, someone would probably have
to clean up after me because I'm just not terribly familiar with
netfilter idioms.


An observation about SIP failure modes.  I have the impression that
nf_conntrack_sip almost never intervenes successfully.  With my
particular phone/provider, it manifest in being able to receive calls but
not place them.  It turns out this is because my telco uses two totally
different servers for incoming and outgoing calls.  Coincidentally, the
one that is used for outgoing calls blindly sends media packets to the
address that I tell it to.  However, the one that is used for incoming
calls is specifically aware of broken NAT and sends messages to the UDP
port that you send from, regardless of what packet was specified in the
header.  In effect, they ignore the port number that is specified in the
SIP transaction because it is so often wrong (due to NAT).

The point is that when a user reports that nf_nat_sip/nf_conntrack_sip
behave in an unpredictable way, it is likely because nf_nat_sip is
consistently not working and the user is interacting with a variety of
peers, some of whom silently adjust for broken NAT and others of which do
not.


Thanks!
- Greg
