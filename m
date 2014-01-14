From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH] files: replace interpreter during installation
Date: Tue, 14 Jan 2014 13:48:46 +0100
Message-ID: <CAOkSjBjuoofax5qsT435Q3m7Ho+drY8FYAm-MWkDh8egHfwciw@mail.gmail.com>
References: <20140113091623.10582.14579.stgit@nfdev.cica.es>
 <20140113093912.GA14898@macbook.localnet> <CAOkSjBgTH=De81npZv_6P6B3rxJxt_0DW6yzK=pzp8uD03TpjA@mail.gmail.com>
 <20140113095252.GB15457@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:60942 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbaANMtI convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jan 2014 07:49:08 -0500
Received: by mail-la0-f49.google.com with SMTP id y1so250116lam.8
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Jan 2014 04:49:06 -0800 (PST)
In-Reply-To: <20140113095252.GB15457@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 13 January 2014 10:52, Patrick McHardy <kaber@trash.net> wrote:
> On Mon, Jan 13, 2014 at 10:49:51AM +0100, Arturo Borrero Gonzalez wro=
te:
>> On 13 January 2014 10:39, Patrick McHardy <kaber@trash.net> wrote:
>> >
>> > I think we should use .in files instead and perform variable subst=
ition.
>> >
>>
>> Could you please elaborate this?
>>
>> I have understood:
>>
>> Use a variable in files/nftables/*, like:
>> <<
>> $shebang
>>
>> table filter {
>> [...]
>>
>> >>
>>
>> And replace during install. Is this true?
>
> Use f.i. files/nftables/ipv4-filter.in and use
>
> #! ${sbindir}/nft

I'm OK with this.

But I see you pushed my patch to master [0]. Should I still work on
your .in approach?

Regards.

[0] https://git.netfilter.org/nftables/commit/?id=3Dc54ce2e0fd25d79f534=
3792c1c620fecdc3b03bc
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
