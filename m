From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH v2] src: new error reporting approach for
 XML/JSON parsers
Date: Mon, 6 Jan 2014 23:46:46 +0100
Message-ID: <CAOkSjBgQt_=obGONgOUmOM+yCXJ7bxK3f1-ZYSmP2089DzddmA@mail.gmail.com>
References: <20140105235114.3752.26544.stgit@Ph0enix> <20140106122344.GA7589@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Alvaro Neira <alvaroneay@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:51780 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933191AbaAFWrH convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:47:07 -0500
Received: by mail-la0-f51.google.com with SMTP id ec20so10104807lab.24
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jan 2014 14:47:06 -0800 (PST)
In-Reply-To: <20140106122344.GA7589@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 6 January 2014 13:23, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Jan 06, 2014 at 12:51:14AM +0100, Alvaro Neira wrote:
>> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>>
>> I have added a new structure for reporting some errors in parser
>> that we can't cover with errno.
>>
>> In this patch, we have three errors that we can't cover with errno:
>>
>> NFT_PARSE_EBADINPUT : Bad XML/JSON format in the input
>> NFT_PARSE_EMISSINGNODE : Missing node in our input
>> NFT_PARSE_EBADTYPE : Wrong type value in a node
>
> This looks good. Applied, thanks Alvaro.

Hi Pablo,

I don't see this applied:

~/libnftables$ git pull --rebase
Current branch master is up to date.
~/libnftables$ gldoc
* b4a0d19 (HEAD, origin/master, origin/HEAD, master) src: rename the
parameter tag to node_name in jansson function
* 24e08e5 build: properly handle --without-{xml,json}-parsing
* 2307124 include: update netlink.h to 3.13
[...]

Regards

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
