From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [PATCH 1/3] scanner: add files in include dirs in alphabetical order.
Date: Thu, 8 Jun 2017 18:37:57 +0200
Message-ID: <CAOkSjBiTkEbhLtmRQq4ifYv7QQ352tCLfd6kT9DN=XsB=KtR7Q@mail.gmail.com>
References: <20170607083559.10051-1-ismo.puustinen@intel.com>
 <CAOkSjBjeTaZTJDEViBRq2y1q715EssHUdgxOFNVf1H7JzpJ6hw@mail.gmail.com> <20170608101735.GA2735@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ismo Puustinen <ismo.puustinen@intel.com>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:36747 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751413AbdFHQiT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Jun 2017 12:38:19 -0400
Received: by mail-it0-f65.google.com with SMTP id 185so1414704itv.3
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Jun 2017 09:38:19 -0700 (PDT)
Received: from mail-io0-f171.google.com (mail-io0-f171.google.com. [209.85.223.171])
        by smtp.gmail.com with ESMTPSA id w16sm2332589iod.26.2017.06.08.09.38.18
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Jun 2017 09:38:18 -0700 (PDT)
Received: by mail-io0-f171.google.com with SMTP id k93so22589225ioi.2
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Jun 2017 09:38:18 -0700 (PDT)
In-Reply-To: <20170608101735.GA2735@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 8 June 2017 at 12:17, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Jun 07, 2017 at 09:40:53PM +0200, Arturo Borrero Gonzalez wrote:
>> On 7 June 2017 at 10:35, Ismo Puustinen <ismo.puustinen@intel.com> wrote:
>> >
>> > +static int directoryfilter(const struct dirent *de)
>> > +{
>> > +       if (strcmp(de->d_name, ".") == 0 ||
>> > +                       strcmp(de->d_name, "..") == 0)
>> > +               return 0;
>> > +
>> > +       /* Accept other filenames. If we want to enable filtering based on
>> > +        * filename suffix (*.nft), this would be the place to do it.
>> > +        */
>> > +
>>
>> This filter by suffix is good to have IMHO.
>> I guess that forcing users to explicitly create a file for nftables
>> (or at least give a specific suffix) reduces chances for user errors.
>
> You mean, this new include directory feature just takes *.nft files,
> right?
>

Yes,

> Then, to keep it consistent, we should also display a warning in
> include file with no .nft postfix. At deprecate the existing behaviour
> at some point, ie. bail out if you include a file that has no trailing
> .nft in its name.
>
> If we follow this path, all ruleset file will end up using .nft as
> a trailer in the name.
>

but perhaps it makes sense to differentiate two cases:
 * include a single file: accept arbitrary names
 * include a whole dir: accept only files ending in .nft

This seems to be what sysctl(8) does when loading a single file vs a directory.
I'm thinking in a case where you have a README in the directory or
other unrelated file.

If the idea is to allow drop files (a good idea indeed), then being
explicit is a good approach.

> Is there any other similar software following this approach? How is
> 'ferm' doing this?

ferm seems to load arbitrary files. In the docs they suggest using
.ferm files but the code
seems to allow whatever.
However, they have a set of regexp hardcoded to avoid loading things
like backups file an the like.
So, yes, probably forcing to .nft is sensible.
