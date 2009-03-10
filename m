From: Chris Hanson <chanson@bluebottle.com>
Subject: Re: Suggestion: "--match recent --set --life-span <secs>"  to prevent
 table filling up
Date: Tue, 10 Mar 2009 13:10:34 -0700
Message-ID: <200903102010.n2AKAf9s003525@mi0.bluebottle.com>
References: <49B59CC7.7080002@bluebottle.com> <alpine.LSU.2.00.0903101712400.19523@fbirervta.pbzchgretzou.qr> <49B6BD2E.7010908@bluebottle.com> <alpine.LSU.2.00.0903102026470.23653@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mi0.bluebottle.com ([206.188.25.15]:40998 "EHLO
	mi0.bluebottle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757644AbZCJUKn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Mar 2009 16:10:43 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by mi0.bluebottle.com (8.13.1/8.13.1) with ESMTP id n2AKAf9s003525
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2009 20:10:41 GMT
In-Reply-To: <alpine.LSU.2.00.0903102026470.23653@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Jan Engelhardt wrote:
> (whew, don't strip Ccs!)
>
> On Tuesday 2009-03-10 20:19, Chris Hanson wrote:
>  =20
>>> =20
>>>      =20
>>>> A suggestion for the match recent part of netfilter. Include a
>>>> life_span field in the table. A host is removed from a table after
>>>> it hasn't been seen for x seconds.
>>>>        =20
>>> How does this differ from simply ignoring hosts recorded in the lis=
t
>>> whose last_seen time is greater than x -- apart from potential
>>> memory savings?
>>>      =20
>> I had the impression that the --set function behaved badly when the =
table
>> filled up.
>>    =20
>
> Well the =E2=80=9Conly=E2=80=9D problem xt_recent has is that entries=
 are thrown off
> the edge of the table when it fills up. It *should* do this in the
> style of an LRU. The only benefit of a premature removal due to
> life_span exceeding I can see is that you want to expire specific
> entries (i.e. matched by, like, -m moonphase) to specifically keep
> even older entries from falling off the LRU edge.
>
> Seems to be a big plan there.</thoughts>
>
>  =20
That is a big plan, and not worth the bother!

I double checked the behavior of the table when full and it seemed to=20
work just fine. I don't know why I thought it was broken.
>> I also believe that the "--rcheck ! --seconds x" check didn't work.
>>
>> I will investigate and report back.
>>    =20
I made a mistake in the syntax. It should be "! --rcheck --seconds x".

So, in the end, all I have to complain about is that "--rcheck !=20
--seconds x" doesn't throw an error. It is accepted as if there was no =
"!".
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
