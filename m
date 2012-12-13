From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Formal submission of Xtables2
Date: Thu, 13 Dec 2012 15:53:45 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1212131528410.1273@nerf07.vanv.qr>
References: <alpine.LNX.2.01.1212130601210.9421@nerf07.vanv.qr> <20121213110046.GA22337@1984> <alpine.LNX.2.01.1212131214100.20007@nerf07.vanv.qr> <20121213120509.GA26118@1984> <alpine.LNX.2.01.1212131405170.786@nerf07.vanv.qr> <20121213142820.GA3489@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Netfilter user mailing list <netfilter@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:56295 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932370Ab2LMOxs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:53:48 -0500
In-Reply-To: <20121213142820.GA3489@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2012-12-13 15:28, Pablo Neira Ayuso wrote:
>> >>
>> >> http://www.spinics.net/lists/netfilter-devel/msg23919.html
>> >
>> >I don't think that feature-set provides compelling reasons to push
>> >this mainstream.
>>=20
>> Well, if not that, then what - documentation, code size?
>
>Not only that. Xtables2 (in its feature-set) inherits many of the
>design decisions that were taken while designing iptables back in the
>late nineties.

nf_tables itself retains some "late nineties" design decisions as
well.

In my opinion, there is nothing wrong with keeping some concepts. A
developer is not required to reevaluate and reinnovate every concept
there has been just for the heck of it. (The old "evolution, not
revolution" credo.) Throwing everything overboard generally does not
turn out to work these days.

That reminds me of Linus's statement from this year's LinuxCon:

	'''there were all these crazy people doing =E2=80=9Cinnovative=E2=80=9D=
 operating
	systems, and they were all horrible. And they were trying to
	do things in new ways, and it turns out, sometimes, the old
	ways are the correct ways, and, you have done something for
	30 years one way, because that works.'''
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
