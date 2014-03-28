From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nf_tables RFH PATCH] netfilter: nf_tables: add set_elem notifications
Date: Fri, 28 Mar 2014 13:00:36 +0100
Message-ID: <CAOkSjBhhaAOCyZpXBG2N3v7TStEz-ye00mhKdx0+RpHXN96rqg@mail.gmail.com>
References: <20140328114622.8896.14752.stgit@nfdev.cica.es> <20140328114938.GA13207@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:53971 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaC1MA6 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Mar 2014 08:00:58 -0400
Received: by mail-la0-f54.google.com with SMTP id mc6so3645804lab.13
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Mar 2014 05:00:56 -0700 (PDT)
In-Reply-To: <20140328114938.GA13207@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 28 March 2014 12:49, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Mar 28, 2014 at 12:46:22PM +0100, Arturo Borrero Gonzalez wro=
te:
>> This patch adds set_elems notifications.
>>
>> When a set_elem is added/deleted, all listening peers in userspace w=
ill
>> receive the corresponding notification.
>
> I was just looking into this now. Is this patch still crashing?

Yes, still crashing :-(

Should this be delayed until the set batching is applied?
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
