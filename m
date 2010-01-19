From: Patrick McHardy <kaber@trash.net>
Subject: Re: Group consensus sought on nf_conntrack_sip behavior
Date: Tue, 19 Jan 2010 19:39:52 +0100
Message-ID: <4B55FC78.80001@trash.net>
References: <20100116103640.GB11547@goonies.be> <4B541272.8040001@trash.net> <20100118174919.GD11547@goonies.be> <4B54A4E7.6020200@trash.net> <20100118193654.GE11547@goonies.be> <4B556C5D.3000006@trash.net> <20100119172306.GF11547@goonies.be> <4B55F54E.4020205@trash.net> <20100119182535.GG11547@goonies.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Greg Alexander <greqcs@galexander.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52125 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab0ASSjz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2010 13:39:55 -0500
In-Reply-To: <20100119182535.GG11547@goonies.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Greg Alexander wrote:
> Is there anyone else on this mailing list who cares to chime in?
> 
> I believe it is more important to conform to standards and common
> practice, especially since they are the same in this case and present no
> undue burden or risk.
> 
> Patrick McHardy seems to believe it is more important to enforce a rule
> of thumb prohibiting wildcard expectations.
> 
> We each have precedent in other NAT helpers to support our position.

Well, I'll add one final point. You mentioned the IRC helper
as precedent, without referring to anything concrete. You're
mistaken though, the destination address is fixed. But I see
where your misunderstanding might come from.

What the SIP helper does is allow expectations between *arbitrary*
hosts when the direct_media option is off - the destination address
originates from the SDP payload, the source address is a wildcard.

> Any other opinions?  Linux is a group effort.
> 
> I'm not used to playing politics just to get a Linux project to adhere to
> a standard, but here we are.  If I do not receive a satisfactory response
> here, I will petition the non-development netfilter user list.  Should
> that fail I will attempt to induce the vast masses of users who are
> inconvenienced by this misfeature to write to various netfilter project
> mailing lists.  Nip this in the bud, explain to me how sip_direct_media
> poses an actual security risk worth breaking SIP NAT for most users over.
> 
> This issue will not go away for the userbase until the default is
> changed.  The status quo in which the users are ignored is over.
> 
> Thanks,

Have fun.
