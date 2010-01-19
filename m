From: "Florian Fuessl" <flo@degnet.de>
Subject: RE: Group consensus sought on nf_conntrack_sip behavior
Date: Wed, 20 Jan 2010 00:40:40 +0100
Message-ID: <002c01ca9960$cf812d20$6e838760$@de>
References: <20100116103640.GB11547@goonies.be> <4B541272.8040001@trash.net> <20100118174919.GD11547@goonies.be> <4B54A4E7.6020200@trash.net> <20100118193654.GE11547@goonies.be> <4B556C5D.3000006@trash.net> <20100119172306.GF11547@goonies.be> <4B55F54E.4020205@trash.net> <20100119182535.GG11547@goonies.be> <4B55FC78.80001@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: "'Patrick McHardy'" <kaber@trash.net>,
	"'Greg Alexander'" <greqcs@galexander.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail04.viruscheckservice.de ([80.73.96.84]:61258 "EHLO
	mail04.viruscheckservice.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755962Ab0ASXr0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2010 18:47:26 -0500
In-Reply-To: <4B55FC78.80001@trash.net>
Content-Language: de
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick, Hi Greg,

as you know, the aspects of NAT have definitely not been considered on the
development of SIP (RFC 3261); so this topic has unfortunately much room for
discussions how to handle problematical issues in detail.

In fact, using SIP together with NAT is still a tricky pain requiring
uncomely workarounds (STUN, keepalive, ...) from the user side.

Nf_conntrack_sip has helped to reduce the issues of SIP with NAT a lot from
the user side; but beyond doubt there are still open traps and unsolved Bugs
requiring some review on the code in some cases. :-/

Patrick McHardy wrote:
> Greg Alexander wrote:
> > Is there anyone else on this mailing list who cares to chime in?
> >

I guess almost everyone on this list does not suffer from this problem
regarding no need for this code on the own "home" installation.

> > I believe it is more important to conform to standards and common
> > practice, especially since they are the same in this case and
> > present no undue burden or risk.
> >

Nf_conntrack_sip should conform to the standards as far as possible; but on
the other side - as it's enabled by default on many distros - it's required
not to open potential security holes on a default installation.

> > Patrick McHardy seems to believe it is more important to enforce a
> > rule of thumb prohibiting wildcard expectations.
> >
> > We each have precedent in other NAT helpers to support our position.
> 
> Well, I'll add one final point. You mentioned the IRC helper
> as precedent, without referring to anything concrete. You're
> mistaken though, the destination address is fixed. But I see
> where your misunderstanding might come from.
> 
> What the SIP helper does is allow expectations between *arbitrary*
> hosts when the direct_media option is off - the destination address
> originates from the SDP payload, the source address is a wildcard.
> 

IMHO the available options should be documented with examples requiring a
change of the default parameters.

Unfortunately using the default settings results in for most users hardly to
debug problems in some cases.

> > Any other opinions?  Linux is a group effort.
> >
> > [...]
> 
> Have fun.

sure: Yes, we have ;)

-Florian

