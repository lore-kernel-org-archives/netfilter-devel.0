From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH v3] extensions: libxt_statistic: Add translation to nft
Date: Wed, 2 Mar 2016 14:52:04 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1603021409540.15745@nerf40.vanv.qr>
References: <20160301204042.GA15382@sonyv> <20160302114611.GA3008@salvia> <20160302121033.GA4348@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Laura Garcia Liebana <nevola@gmail.com>,
	netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	outreachy-kernel@googlegroups.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:36236 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbcCBNwG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 08:52:06 -0500
In-Reply-To: <20160302121033.GA4348@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2016-03-02 13:10, Florian Westphal wrote:
>>         case XT_STATISTIC_MODE_RANDOM:
>>                 if ((prandom_u32() & 0x7FFFFFFF) < info->u.random.pr=
obability)
>>=20
>> --probability seems to check for "less than" the random value.
>
>Yes. [...]=20
>Other suggestions?

"--probability" is meant to represent saying "with a probability
of=C2=A0p=3D10%, ...". This does not mandate any particular operator.

The use of the LE operator seems more of an implementation detail for
use with discrete approaches (such as prandom_u32 and counting =C3=A0 l=
a
Nth), and therefore should not be exposed by nft. Think of asking a
hypothetical hardware device which answers the probability question.

int mtinit(prob p) { setup_hw(p); }
bool match() { return hw_says(); }



=46urthermore, it surprises me that iptables even supports
!=C2=A0--probability, because you can just express it as 1-p
instead.

"32% of people voted for Party 1, not 32% for Party 2"

Nobody does that. Instead,

"32% of people voted for Party 1, 68% (or: the rest) for Party 2"

which is probably also why I have never seen !=C2=A0--p in the
wild, because anyone could just specify 1-p instead.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
