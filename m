From: Greg Alexander <greqcs@galexander.org>
Subject: Group consensus sought on nf_conntrack_sip behavior
Date: Tue, 19 Jan 2010 13:25:35 -0500
Message-ID: <20100119182535.GG11547@goonies.be>
References: <20100116103640.GB11547@goonies.be> <4B541272.8040001@trash.net> <20100118174919.GD11547@goonies.be> <4B54A4E7.6020200@trash.net> <20100118193654.GE11547@goonies.be> <4B556C5D.3000006@trash.net> <20100119172306.GF11547@goonies.be> <4B55F54E.4020205@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shed.goonies.be ([64.62.190.177]:52833 "EHLO shed.goonies.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899Ab0ASSZi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2010 13:25:38 -0500
Content-Disposition: inline
In-Reply-To: <4B55F54E.4020205@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Is there anyone else on this mailing list who cares to chime in?

I believe it is more important to conform to standards and common
practice, especially since they are the same in this case and present no
undue burden or risk.

Patrick McHardy seems to believe it is more important to enforce a rule
of thumb prohibiting wildcard expectations.

We each have precedent in other NAT helpers to support our position.

Any other opinions?  Linux is a group effort.

I'm not used to playing politics just to get a Linux project to adhere to
a standard, but here we are.  If I do not receive a satisfactory response
here, I will petition the non-development netfilter user list.  Should
that fail I will attempt to induce the vast masses of users who are
inconvenienced by this misfeature to write to various netfilter project
mailing lists.  Nip this in the bud, explain to me how sip_direct_media
poses an actual security risk worth breaking SIP NAT for most users over.

This issue will not go away for the userbase until the default is
changed.  The status quo in which the users are ignored is over.

Thanks,

- Greg

On Tue, Jan 19, 2010 at 07:09:18PM +0100, Patrick McHardy wrote:
> Greg Alexander wrote:
> >> Its not about what applications or phones do at all. Its about what
> >> you can do by sending fake INVITE or other requests containing foreign
> >> addresses. I'm not going to change the default, sorry.
> > 
> > Okay, this is becoming increasingly frustrating for me.  I keep on
> > pointing out to you that SIP is a standard by which people register their
> > intent to exchange media streams directly between unrelated peers. You
> > then wave your hands and say "fake" or "poke a hole" and ignore what I've
> > said.  Nothing in nf_nat_sip permits arbitrary holes to be poked!  Until
> > the host initiates a SIP conversation, nf_nat_sip does not facilitate ANY
> > packets moving through the firewall.  Until the host sends an SDP packet,
> > nf_nat_sip only facilitates SIP packets.  Once the media stream begins,
> > nf_nat_sip will not facilitate any new holes without a new SDP packet.
> > 
> > An SDP packet is a conspicuous standard-conforming notification that
> > incoming traffic is expected on a specific local port, and the remote
> > host is left unspecified.  You are saying we should ignore this
> > standard-conforming notification merely because we do not approve of
> > wildcard remote hosts.  This is insufficient.  We only disapprove of
> > wildcard remote hosts because there is the potential to poke arbitrary
> > holes through the firewall.  There is the potential for monsters under my
> > bed, so I shine my flashlight and I know there are no monsters.  I
> > inspect nf_conntrack_sip and I know there is no arbitrary hole poking!
> 
> You obviously haven't inspected it very well. I have no interest in
> continuing this debatte.
> 
> > Patch follows.
> > 
> > --- nf_conntrack_sip.c	2010/01/15 21:51:08	1.1
> > +++ nf_conntrack_sip.c	2010/01/16 09:29:07	1.3
> > @@ -375,7 +375,7 @@
> >  			dptr += hdr->len;
> >  		else if (hdr->cname && limit - dptr >= hdr->clen + 1 &&
> >  			 strnicmp(dptr, hdr->cname, hdr->clen) == 0 &&
> > -			 !isalpha(*(dptr + hdr->clen + 1)))
> > +			 !isalpha(*(dptr + hdr->clen)))
> >  			dptr += hdr->clen;
> >  		else
> >  			continue;
> 
> Applied, thanks.
