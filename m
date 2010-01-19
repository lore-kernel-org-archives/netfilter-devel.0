From: Greg Alexander <greqcs@galexander.org>
Subject: (PATCH) Re: Two patches for nf_conntrack_sip
Date: Tue, 19 Jan 2010 12:23:06 -0500
Message-ID: <20100119172306.GF11547@goonies.be>
References: <20100116103640.GB11547@goonies.be> <4B541272.8040001@trash.net> <20100118174919.GD11547@goonies.be> <4B54A4E7.6020200@trash.net> <20100118193654.GE11547@goonies.be> <4B556C5D.3000006@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shed.goonies.be ([64.62.190.177]:35053 "EHLO shed.goonies.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab0ASRXJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2010 12:23:09 -0500
Content-Disposition: inline
In-Reply-To: <4B556C5D.3000006@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Its not about what applications or phones do at all. Its about what
> you can do by sending fake INVITE or other requests containing foreign
> addresses. I'm not going to change the default, sorry.

Okay, this is becoming increasingly frustrating for me.  I keep on
pointing out to you that SIP is a standard by which people register their
intent to exchange media streams directly between unrelated peers. You
then wave your hands and say "fake" or "poke a hole" and ignore what I've
said.  Nothing in nf_nat_sip permits arbitrary holes to be poked!  Until
the host initiates a SIP conversation, nf_nat_sip does not facilitate ANY
packets moving through the firewall.  Until the host sends an SDP packet,
nf_nat_sip only facilitates SIP packets.  Once the media stream begins,
nf_nat_sip will not facilitate any new holes without a new SDP packet.

An SDP packet is a conspicuous standard-conforming notification that
incoming traffic is expected on a specific local port, and the remote
host is left unspecified.  You are saying we should ignore this
standard-conforming notification merely because we do not approve of
wildcard remote hosts.  This is insufficient.  We only disapprove of
wildcard remote hosts because there is the potential to poke arbitrary
holes through the firewall.  There is the potential for monsters under my
bed, so I shine my flashlight and I know there are no monsters.  I
inspect nf_conntrack_sip and I know there is no arbitrary hole poking!

Your "no wildcard expectations" is a reasonable heuristic, or rule of
thumb.  And like any rule of thumb, it is to be discarded in favor of a
more thorough analysis whenever it turns out to be dysfunctional.

> I'm working on supporting helpers for selected connections (using an
> iptables target) however, for which I might reconsider this.

Um, I'm going to reiterate to you that the host _MUST REGISTER_ before
nf_nat_sip has any effect on them.  The idea of requiring an extra layer
of selection is meaningless extravagance.  If a host talks SIP on the
specified port, select them.  If they don't talk SIP, leave them alone.

> This is a documentation question.

The undocumented fact here is that you're breaking behavior for a huge
number of users and ultimately forcing SIP providers to break the
standard to communicate with users behind Linux NAT.  We should conform
with standards, not force others to break the standards!

> Its BTW completely in line with what other helpers do, we also
> have a "gkrouted_only" option in H.323 defaulting to 1 and a
> "loose" option in FTP for FXP, defaulting to 0. Both for exactly
> the same reason.

No one is astonished to learn that nf_nat_ftp doesn't support FXP.

I've cited nf_nat_irc.  It seems there's in fact precedent for each side.
Are you going to break nf_nat_irc now that I've brought it to your
attention?

> Great. Could you send me the off-by-one fix please?

You have some standards that you demand people adhere to.  You like
tcpdumps as binary attachments, and patches as text/plain.  Standards
make life easy, right?  There is no reason to even be flexible with
people when you can demand that they adhere to a reasonable standard.  I
like standards too.  I'm honoured by the opportunity to communicate with
you by adopting some of your standards.

SIP is a published standard that exists to allow direct media transfer
between two hosts who did not know or trust eachother at the beginning of
the transaction. Conform please.

I will escalate this disagreement because you are simply being stubborn
about something that is of no consequence to you based on the
misapplication of an overly general principle.  I assume at some point in
your life you've dealt with religious nuts who would not accept anything
you say because they have an authoritative source (the bible).  Well, I
have an authoritative source: RFC3261.  Until you give some good reason
for the Linux kernel to ignore this standard, I'm going to keep on
thumping that RFC.

I think you will find that standard adherence is a popular religion in
the open source world.

Patch follows.

Thanks!  (and I mean it -- apart from this one infelicity, your work is
very good!)

- Greg

--- nf_conntrack_sip.c	2010/01/15 21:51:08	1.1
+++ nf_conntrack_sip.c	2010/01/16 09:29:07	1.3
@@ -375,7 +375,7 @@
 			dptr += hdr->len;
 		else if (hdr->cname && limit - dptr >= hdr->clen + 1 &&
 			 strnicmp(dptr, hdr->cname, hdr->clen) == 0 &&
-			 !isalpha(*(dptr + hdr->clen + 1)))
+			 !isalpha(*(dptr + hdr->clen)))
 			dptr += hdr->clen;
 		else
 			continue;
