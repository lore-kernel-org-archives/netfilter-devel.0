From: Greg Alexander <greqcs@galexander.org>
Subject: Re: Two patches for nf_conntrack_sip
Date: Mon, 18 Jan 2010 14:36:54 -0500
Message-ID: <20100118193654.GE11547@goonies.be>
References: <20100116103640.GB11547@goonies.be> <4B541272.8040001@trash.net> <20100118174919.GD11547@goonies.be> <4B54A4E7.6020200@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shed.goonies.be ([64.62.190.177]:38404 "EHLO shed.goonies.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab0ARTg7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jan 2010 14:36:59 -0500
Content-Disposition: inline
In-Reply-To: <4B54A4E7.6020200@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 18, 2010 at 07:13:59PM +0100, Patrick McHardy wrote:
> No, NAT is only responsible for address translation, and in fact it
> isn't even involved in this decision. The connection tracking helper
> (which can also be used without NAT) creates expectations, the expected
> connections have to be permitted by the ruleset. The helper doesn't
> drop or allow anything, all this parameter does is control how the
> expectations are set up (wildcards or no wildcards).

The thing is, you don't even need to violate the separation between NAT
and conntrack.  You are arguing that conntrack is only supposed to track
connections, and you seem to believe that a connection exists only when
both ends have been fully specified.  Wildcard addresses do violate that
definition, but that definition is unduly limited.

There is a type of connection in which one endpoint is unspecified until
after traffic is received.  In TCP, this is a listen socket used for
peer-to-peer communication, like IRC's DCC.  Rightfully we do not love
such wildcard connection strategies, but we acknowledge that we are not
the body that forms the standards.  Thus nf_nat_irc is born.  SIP/SDP
uses the same connection strategy (at least if early media is in play).

The actual exposure from this wildcard is very limited.  We only open the
port when the internal host specifically requests it, and ultimately the
expectation is only in effect for the first remote host to trigger it.
The worst case scenario would be to allow people to send arbitrary
packets to a port that is expecting valid media data.  This isn't great
but it's a weakness imposed by the protocol.  As a bonus, the softphone
software has access to both the SDP stream and the original source
address on these UDP packets, so it can make its own decisions (generally
turning it into a DoS instead of compromise).

> I've seen quite a few of those bug reports myself, and in all but one
> case it was actually people using the old version of the helper, which
> didn't work properly at all (and didn't support these parameters).

Maybe I'm misunderstanding the epidemiology here, but don't you see
yourself sending out "try sip_direct_media=0" to each and every person
who contacts you?  Just imagine the thousands (soon millions) of users
who would benefit from sip_direct_media=0 who will not know to contact
you?  The Linux kernel is packaged in most routers these days. It's all
fine and dandy to force Linksys to add "sip_direct_media=0" to their
options, but from the user perspective this option should be called
"break_big_sip_providers=0".  I don't think I would be willing to blame
D-Link for failing to anticipate that we would provide a
"break_big_sip_providers" option which defaults to 1.  Even now, but
especially in the future, SIP usage will be dominated by big providers.
Gizmo5 is soon to be pronounced "Google Voice." I'd understand a quixotic
desire to break common practice so that we can enforce a standard, but
the standard in this case is clear that we are in violation, not the
commercial providers.

I mean, are we really in the business of distributing the "works with
Asterisk" standards-ignoring but-slightly-safer SIP translator?

> So does it work with sip_direct_media=0?

Yes, it works perfectly with sip_direct_media=0.

Thanks,
- Greg
