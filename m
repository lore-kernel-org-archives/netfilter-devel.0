From: Andrew Watts <akwatts@ymail.com>
Subject: Re: NFQUEUE verdicts - adding non-termination
Date: Tue, 16 Nov 2010 02:48:01 -0800 (PST)
Message-ID: <620472.579.qm@web111011.mail.gq1.yahoo.com>
References: <4CE10CD3.1080307@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stig Thormodsrud <stig@vyatta.com>,
	Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nm22-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.222]:28070 "HELO
	nm22-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932992Ab0KPKsD convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Nov 2010 05:48:03 -0500
In-Reply-To: <4CE10CD3.1080307@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--- On Mon, 11/15/10, Patrick McHardy <kaber@trash.net> wrote:

> From: Patrick McHardy <kaber@trash.net>
> Subject: Re: NFQUEUE verdicts - adding non-termination
> To: "Stig Thormodsrud" <stig@vyatta.com>
> Cc: "Andrew Watts" <akwatts@ymail.com>, netfilter-devel@vger.kernel.o=
rg
> Date: Monday, November 15, 2010, 10:34 AM
> On 12.11.2010 20:54, Stig Thormodsrud
> wrote:
> > On 11/11/2010 02:50 AM, Patrick McHardy wrote:
> >> On 11.11.2010 10:01, Andrew Watts wrote:
> >>> Hi.
> >>>
> >>> The NF_CONTINUE verdict that Darryl Miles
> brings up in his 11/4 post is very interesting.
> >>>
> >>> NF_CONTINUE would provide the NFQUEUE target
> the added flexibility of, say, partial handling in
> userspace. A queue-handler could have a set of criteria
> that, when satisfied, would result in an immediate drop or
> accept. One could then leave the rest of the packets to find
> their fate in the chains/rules left to traverse.
> >>>
> >>> I would be interested in helping to add this
> verdict if someone will take the lead (assuming a patch
> hasn't already been written - has it?).
> >>
> >> There's no difference between returning NF_ACCEPT
> or a new NF_CONTINUE.
> >> Queueing happens outside of the ruleset context,
> so in either case the
> >> packet would continue through the network stack
> directly, not after
> >> the NFQUEUE rule.
> >=20
> > I've been interested in this thread since I recently
> converted our
> > version of snort inline to use NFQUEUE instead of
> QUEUE.=A0 One of driving
> > factors was that I needed to have multiple QUEUE
> targets.=A0 While I was
> > doing the work I was hoping there was a verdict like
> NF_RETURN, so that
> > if it passed the snort inspection then I could have
> another NFQUEUE
> > target that would do https domain filtering.=A0
> From reading this thread I
> > now understand why I can just continue, but I
> wondering what is that the
> > recommended approach for this type of use case?=A0
> As it is now, I think I
> > would need to have the 2nd NFQUEUE target on a
> different hook.
>=20
> Look at my second response to Andrew, you can use NF_REPEAT
> and some
> mark based jumps to do this. You can also return NF_QUEUE
> from userspace
> directly and encode the queue number in the upper 16 bits.
>=20

Patrick, many thanks for the guidance on this. Your
advice was right on.

Stig, something to consider in addition to Patrick's
comment is that you can make the mark-based decision
more complex than just binary. Then a single queue
handler can process according to different mark values
and increment the mark on each return (until a=20
termination value is reached).

~ Andy


     =20
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
