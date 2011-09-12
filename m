From: =?UTF-8?B?S3J6eXN6dG9mIE9sxJlkemtp?= <ole@ans.pl>
Subject: Re: conntrack (nf_conn) locking question
Date: Mon, 12 Sep 2011 21:12:05 +0200
Message-ID: <4E6E5985.9080306@ans.pl>
References: <CAOAcFN-fXwCrtDu1snSAH-O5ud92bcBS4Dh8fR2m38pc=5hbTA@mail.gmail.com> <20110912084557.GA2080@1984> <CAOAcFN8DeYAk_sv+f=DrDykEqxd7jQ-yBKCBnqieHOr=RofY5g@mail.gmail.com> <20110912185354.GB4018@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Gidon Miller <gmiller@vasonanetworks.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([195.187.34.71]:41293 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab1ILTaY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Sep 2011 15:30:24 -0400
In-Reply-To: <20110912185354.GB4018@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2011-09-12 20:53, Pablo Neira Ayuso wrote:
> On Mon, Sep 12, 2011 at 01:11:50PM +0300, Gidon Miller wrote:
>> Hi Pablo,
>> thanks for your reply. can you please refer me to any documentation =
on
>> how to use ct extensions?
>
> Only code, see net/netfilter/nf_conntrack_acct.c for instance.

Plus:
  include/net/netfilter/nf_conntrack_acct.h
  include/net/netfilter/nf_conntrack_extend.h

BTW: if nothing changed, extensions can be only attached to a conntrack=
=20
before it is confirmed.

Best regards,

				Krzysztof Ol=C4=99dzki
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
