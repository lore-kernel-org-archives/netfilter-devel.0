From: Greg Alexander <greqcs@galexander.org>
Subject: Re: Group consensus sought on nf_conntrack_sip behavior
Date: Tue, 19 Jan 2010 14:36:55 -0500
Message-ID: <20100119193655.GI11547@goonies.be>
References: <20100116103640.GB11547@goonies.be> <4B541272.8040001@trash.net> <20100118174919.GD11547@goonies.be> <4B54A4E7.6020200@trash.net> <20100118193654.GE11547@goonies.be> <4B556C5D.3000006@trash.net> <20100119172306.GF11547@goonies.be> <4B55F54E.4020205@trash.net> <20100119182535.GG11547@goonies.be> <4B55FC78.80001@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shed.goonies.be ([64.62.190.177]:51935 "EHLO shed.goonies.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922Ab0ASTg6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2010 14:36:58 -0500
Content-Disposition: inline
In-Reply-To: <4B55FC78.80001@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 19, 2010 at 07:39:52PM +0100, Patrick McHardy wrote:
> Well, I'll add one final point. You mentioned the IRC helper
> as precedent, without referring to anything concrete. You're
> mistaken though, the destination address is fixed. But I see
> where your misunderstanding might come from.
> 
> What the SIP helper does is allow expectations between *arbitrary*
> hosts when the direct_media option is off - the destination address
> originates from the SDP payload, the source address is a wildcard.

*sigh*

I offered a DCC send from an internal host with nf_nat_irc:
  # cat /proc/net/ip_conntrack_expect
  289 proto=6 src=0.0.0.0 dst=98.223.156.20 sport=0 dport=4110
                  ^^^^^^^                         ^

I offered an RTP stream from an internal host using SIP/SDP with
nf_conntrack_sip sip_direct_media=0 (and nf_nat_sip of course):
  # cat /proc/net/ip_conntrack_expect
  179 proto=17 src=0.0.0.0 dst=98.223.156.20 sport=0 dport=7078
  179 proto=17 src=0.0.0.0 dst=98.223.156.20 sport=0 dport=7079
                   ^^^^^^^                         ^

The situations really are analogous and nf_nat_irc really does use a
wildcard for the remote end of the connection.  This is because both are
sloppy peer-to-peer protocols advertising over a proxy network using the
same handshaking methodology.

Oh and while we're on misinterpretations...I think maybe you thought I
was pushing for sip_direct_signalling=0.  I do not know if the standard
explicitly forbids indirect signalling, but personally I am a fan of
direct signalling, as are the major VOIP providers.  I think we would all
agree that sip_direct_signalling=0 presents a substantial risk for
nefarious activity.

Anyways, if you thought I was pushing for sip_direct_signalling=0 then it
makes sense that you would have figured I was insane.

- Greg


> 
> > Any other opinions?  Linux is a group effort.
> > 
> > I'm not used to playing politics just to get a Linux project to adhere to
> > a standard, but here we are.  If I do not receive a satisfactory response
> > here, I will petition the non-development netfilter user list.  Should
> > that fail I will attempt to induce the vast masses of users who are
> > inconvenienced by this misfeature to write to various netfilter project
> > mailing lists.  Nip this in the bud, explain to me how sip_direct_media
> > poses an actual security risk worth breaking SIP NAT for most users over.
> > 
> > This issue will not go away for the userbase until the default is
> > changed.  The status quo in which the users are ignored is over.
> > 
> > Thanks,
> 
> Have fun.
