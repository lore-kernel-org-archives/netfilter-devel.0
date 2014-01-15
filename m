From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH] tests: xml: delete comments
Date: Wed, 15 Jan 2014 17:00:20 +0100
Message-ID: <CAOkSjBjTZv0jHzPG6MPYVQU=amvGntwq1qe8FY47O704mFs5fA@mail.gmail.com>
References: <20140115111218.25584.60794.stgit@nfdev.cica.es> <20140115131214.GA22148@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:54149 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbaAOQAp convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 11:00:45 -0500
Received: by mail-la0-f48.google.com with SMTP id er20so1549534lab.21
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jan 2014 08:00:42 -0800 (PST)
In-Reply-To: <20140115131214.GA22148@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15 January 2014 14:12, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
> On Wed, Jan 15, 2014 at 12:12:18PM +0100, Arturo Borrero Gonzalez wro=
te:
>> In libmxml > 2.6, comments are not ignored when building the XML tre=
e,
>> so these comments produce errors and test fail.
>
> Doesn't have libmxml any way to accept comments?

I explained it bad, i'm sorry.

When building a XML tree, only one root node can be in place. This is
a "feature" added in libmxml 2.7:

<<<
mxmlLoad... did not error out on XML with multiple root nodes (Bug #403=
)
>>>

In libmxml 2.6 the second root node was ingored, not because it was a
comment but because a bug.
Our files had two root nodes, being comments or not.
libmxml accept comments, but inside the root node.

>
>> Delete the comment lines, so parsing test pass with libmxml 2.7 and =
2.8.
>>
>> By now, this is the only issue I found when working with libmxml > 2=
=2E6.
>
> Kevin mentioned a different error, please investigate it. Thanks.

The error Kevin reported is what I've fixed.

Anyway, I've tested libnftables linked against libmxml 2.7 and 2.8
with no other issues.

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
