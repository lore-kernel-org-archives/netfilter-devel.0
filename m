From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH 1/3] tests: fix error reporting
Date: Tue, 1 Oct 2013 00:02:15 +0200
Message-ID: <CAOkSjBjFsqZSSaNr6jUMN3aZR=fA+TR2dBSVNyOp_xLGt84DvQ@mail.gmail.com>
References: <20130930150551.32124.23680.stgit@nfdev.cica.es> <20130930174157.GA31379@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:49670 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210Ab3I3WCi convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 18:02:38 -0400
Received: by mail-lb0-f175.google.com with SMTP id y6so5065536lbh.20
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2013 15:02:36 -0700 (PDT)
In-Reply-To: <20130930174157.GA31379@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 30 September 2013 19:41, Pablo Neira Ayuso <pablo@netfilter.org> wro=
te:
> On Mon, Sep 30, 2013 at 05:05:52PM +0200, Arturo Borrero Gonzalez wro=
te:
>> The testbench was not reporting errors properly.
>>
>> With this patch, "1" is returned to the shell if the test failed (in=
stead of
>> returning "0" unconditionally). Textual reporting is also fixed.
>
> How is it broken?
>
> IIRC the error reporting provides some rudimentary cursor to indicate
> where the problem happens. I think this patch breaks it.

I don't see where the break happens. Could you give me some hints?

=46or me, the cursor works as expected.
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
