From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH] dist: include tests/ directory and files in tarball
Date: Thu, 28 Apr 2016 12:07:10 +0200
Message-ID: <CAOkSjBj7FQLjnyWx+rEdLhm47xaGT5YgL-0XjTqZTXeTV630Rw@mail.gmail.com>
References: <146183487873.3430.10556920470037312368.stgit@nfdev2.cica.es> <20160428092720.GA1848@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:36910 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbcD1KHb convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Apr 2016 06:07:31 -0400
Received: by mail-wm0-f45.google.com with SMTP id a17so56478765wme.0
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Apr 2016 03:07:30 -0700 (PDT)
In-Reply-To: <20160428092720.GA1848@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 28 April 2016 at 11:27, Pablo Neira Ayuso <pablo@netfilter.org> wrot=
e:
> On Thu, Apr 28, 2016 at 11:14:38AM +0200, Arturo Borrero Gonzalez wro=
te:
>> If we include tests/ in the release tarball, downstream distributors
>> can run the testsuites themselves while developing the packages.
>>
>> This way, tests can be run in a more integrated environment and they=
 can
>> discover errors related to the integration with the given distributi=
on itself.
>>
>> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.co=
m>
>> ---
>>  Makefile.am |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/Makefile.am b/Makefile.am
>> index 068009b..10aa40f 100644
>> --- a/Makefile.am
>> +++ b/Makefile.am
>> @@ -4,3 +4,5 @@ SUBDIRS =3D     src     \
>>               include \
>>               doc     \
>>               files
>> +
>> +EXTRA_DIST =3D tests
>
> You can get a git clone instead?
>
> This is going to bloat the tarball for something that only a few
> developer need.

It seems these are the numbers:

In the case of nftables
 * 327K withtout tests
 * 388K with tests

In case of conntrack-tools
 * 496K without tests
 * 503K with tests

I don't think this is a big deal.

Other release tarballs include tests or qa files (libnftnl, ipset,
libnetfilter-conntrack...)

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
