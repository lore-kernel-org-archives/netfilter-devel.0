From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [conntrackd PATCH v3] conntrackd: add systemd support
Date: Mon, 16 Nov 2015 15:22:21 +0100
Message-ID: <CAOkSjBgG7pVyP1LT0p+cbjrHkTGXRB=KPnrAVNQHSVSXys0xfw@mail.gmail.com>
References: <144741224967.19762.12430502552848102506.stgit@r2d2.cica.es> <20151116111720.GA14988@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:32917 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbbKPOWm convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Nov 2015 09:22:42 -0500
Received: by wmec201 with SMTP id c201so178966839wme.0
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2015 06:22:41 -0800 (PST)
In-Reply-To: <20151116111720.GA14988@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16 November 2015 at 12:17, Pablo Neira Ayuso <pablo@netfilter.org> w=
rote:
> On Fri, Nov 13, 2015 at 11:59:35AM +0100, Arturo Borrero Gonzalez wro=
te:
>> v2: change functions definitions to static inline if no BUILD_SYSTEM=
D,
>>     and set watchdog variables as static.
>>
>> v3: add runtime systemd configuration. Report warnings.
>
> One more question:
>
> This is checking for 'libsystemd >=3D 227'
>
> Is this library version really required? Or it is simply that you hav=
e
> set to the most recent version for some reason?

227 is the version I've tested. Previous versions may not work.

=46or example, I remember the library being split in several small
libraries and then mixed into this libsystemd, thus changing some
headers and include paths.

Also, I simply ignore what is the behaviour of the watchdog stuff
previous to 227, it seems a recent thing.

What are your concerns?

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
