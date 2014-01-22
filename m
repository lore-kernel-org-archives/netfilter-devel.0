From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH] files: replace interpreter during installation
Date: Wed, 22 Jan 2014 17:45:39 +0100
Message-ID: <CAOkSjBidi2YdLuQaqDBOTDuMVHRPCVnhJFa2zRzpyfEgbQyA8w@mail.gmail.com>
References: <20140113091623.10582.14579.stgit@nfdev.cica.es>
 <CAOj-5WAXqwd3eHD0bFNxa031pLcLWwXtHsOxeYbnJxFeUVMYUA@mail.gmail.com> <20140114151605.GA26466@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Sam Liddicott <sam@liddicott.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:38338 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbaAVQqB convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jan 2014 11:46:01 -0500
Received: by mail-lb0-f181.google.com with SMTP id z5so515400lbh.40
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jan 2014 08:45:59 -0800 (PST)
In-Reply-To: <20140114151605.GA26466@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14 January 2014 16:16, Patrick McHardy <kaber@trash.net> wrote:
> On Tue, Jan 14, 2014 at 03:00:14PM +0000, Sam Liddicott wrote:
>> I realise a solution is reached, but an alternative in common use is
>> mentioned here for completeness;
>>
>> #! /usr/bin/env nft -f
>>
>> it is commonly used to invoke interpreters whose path is unknown but
>> which can be expected to be on the PATH
>
> I'm find either way. Unless there are arguments for not using env,
> this seems like the simpler fix.


Using env with an additional argument (the '-f') seems to fail in my sy=
stem.

=3D=3D=3D8<=3D=3D=3D
#!/usr/bin/env nft -f
list table filter
=3D=3D=3D8<=3D=3D=3D

% ./test
/usr/bin/env: nft -f: No such file or directory

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
