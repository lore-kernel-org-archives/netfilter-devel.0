From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Suggestion: "--match recent --set --life-span <secs>"  to prevent
 table filling up
Date: Tue, 10 Mar 2009 20:29:53 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903102026470.23653@fbirervta.pbzchgretzou.qr>
References: <49B59CC7.7080002@bluebottle.com> <alpine.LSU.2.00.0903101712400.19523@fbirervta.pbzchgretzou.qr> <49B6BD2E.7010908@bluebottle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Chris Hanson <chanson@bluebottle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35053 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbZCJT34 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Mar 2009 15:29:56 -0400
In-Reply-To: <49B6BD2E.7010908@bluebottle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

(whew, don't strip Ccs!)

On Tuesday 2009-03-10 20:19, Chris Hanson wrote:
>> =20
>>> A suggestion for the match recent part of netfilter. Include a
>>> life_span field in the table. A host is removed from a table after
>>> it hasn't been seen for x seconds.
>>
>> How does this differ from simply ignoring hosts recorded in the list
>> whose last_seen time is greater than x -- apart from potential
>> memory savings?
>
> I had the impression that the --set function behaved badly when the t=
able
> filled up.

Well the =E2=80=9Conly=E2=80=9D problem xt_recent has is that entries a=
re thrown off
the edge of the table when it fills up. It *should* do this in the
style of an LRU. The only benefit of a premature removal due to
life_span exceeding I can see is that you want to expire specific
entries (i.e. matched by, like, -m moonphase) to specifically keep
even older entries from falling off the LRU edge.

Seems to be a big plan there.</thoughts>

> I also believe that the "--rcheck ! --seconds x" check didn't work.
>
> I will investigate and report back.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
