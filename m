From: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>
Subject: Re: Overlapping IP networks no longer allowed?
Date: Thu, 15 Feb 2018 10:15:37 +0200
Message-ID: <CAPWNY8WnuieHPKCGkERT0JxAi2UyJTF3gL6W=vGMYsKK4KWDvQ@mail.gmail.com>
References: <CAPWNY8W5euS6+LrEppdKp81k-Uz48w2WZP8kzu5=cVyhObnVMg@mail.gmail.com>
 <20180214182249.nnccha2bg5j4htrv@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pl0-f42.google.com ([209.85.160.42]:41257 "EHLO
        mail-pl0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754930AbeBOIPy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Feb 2018 03:15:54 -0500
Received: by mail-pl0-f42.google.com with SMTP id k8so10015766pli.8
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Feb 2018 00:15:53 -0800 (PST)
In-Reply-To: <20180214182249.nnccha2bg5j4htrv@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 14, 2018 at 8:22 PM, Pablo Neira Ayuso <pablo@netfilter.org> wr=
ote:
> On Wed, Feb 14, 2018 at 07:02:32PM +0200, Mantas Mikul=C4=97nas wrote:
>> Hello,
>>
>> As of nftables 0.8.1, it seems I can no longer write anonymous sets
>> which contain overlapping networks (CIDR masks).
>>
>> For example, I want to write the following ruleset:
>>
>> #!/usr/bin/nft -f
>> define users =3D { 10.0.0.0/8, 193.219.181.192/26 }
>> define admins =3D { 10.123.0.0/24, 31.220.42.129 }
>> define allowed =3D { $users, $admins }
>> table inet filter {
>>         chain foobar {
>>                 ip saddr $allowed accept
>>         }
>> }
>>
>> results in an error message:
>>
>>     Error: interval overlaps with previous one
>>
>> I noticed a few nftables.git commits related to disabling auto-merge
>> for interval sets... but mine don't have the 'interval' flag, and
>> there doesn't seem to be any way to specify 'auto-merge' for anonymous
>> sets, either.
>
> I would like not to enable this by default since typo in rulesets
> could go through unnoticed.
>
> So the two alternatives I see are:
>
> 1) add per-table configuration options, this would allow us to
>    enable auto-merge explicitly for all anonymous sets. This is also
>    required if we want to allow user to select "policy memory;" for
>    anonymous sets. Only problem with this approach is that this needs
>    a kernel patch, so it will take a while to restore the behaviour you
>    want since we need a new NFTA_TABLE_USERDATA attribute to store user
>    preferences on this.
>
> 2) We add a -m option that we can combine with -f for this, which
>    globally enables auto-merge for every set, including anonymous and
>    named sets.

For anonymous sets, 2) seems to make more sense =E2=80=93 though maybe it
should be settable from within the ruleset itself (a line like "option
auto-merge;"), rather than via command line. [Just like I currently
use "flush ruleset;" rather than `nft --flush`. Also similar to how
perl prefers "use warnings;" over `perl -w`.]

But I agree with Florian's comments, and I think some of the arguments
in commit log don't make as much sense for anonymous sets as they
would for named ones; e.g. "problematic because it introduces an
inconsistency between what we add and what we later on get. This is
going to get worse with the upcoming timeout support for intervals" =E2=80=
=93
afaik, anonymous inline sets cannot be added to nor removed from (so
no timeouts).

(A fourth option would be to support a new syntax for set options, for
example "{ [automerge] $foo, $bar }" and "{ [interval, automerge]
1-10, 2, 4, 6 }"... if that makes sense internally?)

--=20
Mantas Mikul=C4=97nas
