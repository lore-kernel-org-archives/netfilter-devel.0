From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: nftables/libnftables packages for Fedora
Date: Sun, 12 Jan 2014 22:16:35 +0100
Message-ID: <CAOkSjBhCTDCDzBLp86d1qA+xH=KMZtz2HrU3QfnZ+8AJ+qcWTg@mail.gmail.com>
References: <20140112134024.2475a4f2@voldemort.scrye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Kevin Fenzi <kevin@scrye.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60582 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaALVRA convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Jan 2014 16:17:00 -0500
Received: by mail-lb0-f174.google.com with SMTP id p9so2872659lbv.5
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Jan 2014 13:16:56 -0800 (PST)
In-Reply-To: <20140112134024.2475a4f2@voldemort.scrye.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12 January 2014 21:40, Kevin Fenzi <kevin@scrye.com> wrote:
> Greetings.
>
> I apologize in advance if this is not the right place to discuss this=
=2E
> If it's not, please point me the right direction and I will move it
> there. :)
>
> I am packaging up libnftables/nftables for Fedora.

good to know! :)

>
> 2. There is some question about the /etc/nftables/* scripts. In Fedor=
a
> land, things in /etc/ should be config files, but these aren't really
> config files. They call nft without a full path (/usr/sbin/nft, etc).
> Should these really be in /usr/share ? or is it expected users will
> modify them? Could you clarify the use case there?
>

There is a patch from me to address this:
http://patchwork.ozlabs.org/patch/304866/
=46eel free to test it and comment.

I have the same issue in the Debian land. I applied the patch locally
in the package as a workaround.

The patch is not applied yet to upstream.

>
> 6. I recently enabled the xml stuff in libnftables and am seeing a
> number of tests fail:
>
> parsing xmlfiles/55-rule-real.xml:  [31mFAILED [0m (Invalid argument)
> and
> parsing xmlfiles/74-set.xml:  [31mFAILED [0m (Invalid argument)
> mxml: <!-- nft add rule filter output ct secmark 0 counter --> cannot
> be a second root node after <nftables>
>

I can't see the libmxml version in the build log. Which version of
libmxml are you using?
Seem that your version of libmxml treats XML comments different than
in my version (libmxml 2.6 from Debian).

Also I guess you are using an outdated snapshot of libnftables. Some
important changes happened to the XML/JSON parsers.

Anyway, thanks for the report, I'm going to review the XML parser.

>
> Are these expected? The Invalid argument might be because it doesn't
> have nftables available in the build kernel? But the json tests
> work. :(
>

Not expected at all.

These tests simply parse the XML/JSON input, they don't send anything
to the kernel.

> Thanks. Again, if I should send this somewhere else instead, just let
> me know. Comments welcome here, direct email and/or in the above revi=
ew
> bugs. ;)


I think this is the right place.

Thanks.
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
