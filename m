From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH] evaluate: better error reporting in too long sets names
Date: Thu, 28 Apr 2016 09:42:43 +0200
Message-ID: <CAOkSjBjxO4_5osADYYowJQp4s_LVv-QR645tVCUEEs6HE3R5Og@mail.gmail.com>
References: <146115978018.25287.16460508385150502285.stgit@nfdev2.cica.es> <20160427171419.GA7625@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36138 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbcD1HnE convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Apr 2016 03:43:04 -0400
Received: by mail-wm0-f44.google.com with SMTP id n129so54546224wmn.1
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Apr 2016 00:43:03 -0700 (PDT)
In-Reply-To: <20160427171419.GA7625@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27 April 2016 at 19:14, Pablo Neira Ayuso <pablo@netfilter.org> wrot=
e:
> On Wed, Apr 20, 2016 at 03:43:00PM +0200, Arturo Borrero Gonzalez wro=
te:
>> Currently, if we choose a set name larger than allowed, the error me=
ssage is:
>>  Error: Could not process rule: Numerical result out of range
>>
>> Let's inform the user with a better error message.
>>
>> We can discuss later if length of set names should be increased, but=
 I think
>> this better error reporting is necessary right now to avoid headache=
s to users.
>
> /* The max length of strings including NUL: set and type identifiers =
*/
> #define IPSET_MAXNAMELEN        32
>
> I would like that we get the same length as ipset, this should make i=
t
> easier for people to migrate.
>
> This would require a bit of work though since the interface name size
> is limited by the register size. Not much a problem, but it would
> require a bit of code adjustments from the kernel.
>
> So let me postpone this userspace check.

We would need the userspace check anyway to avoid the very misleading
error reporting from the kernel.
Then if tomorrow we change the name length, we just need an oneliner
here to update with the new size. I remember in the past we discussed
using set names as completely variable size strings, but that's
another discussion.

If loading a ruleset with 'nft -f' with lot of nested and included
files, the error is just very difficult to track down; I've hit it
several times already.

=3D=3D t.nft =3D=3D
flush ruleset
table t {
    set abcdefghijklmopqrst {
         type ipv4_addr
    }
}
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

% nft -f t.nft
t.nft:2:1-2: Error: Could not process rule: Numerical result out of ran=
ge
table t {
^^

So I don't understand the point in not including some more informative
message right now.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
