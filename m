From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft 3/3] src: add set optimization options
Date: Fri, 19 Sep 2014 09:04:17 +0200
Message-ID: <CAOkSjBheru+aESGEuqLABAsEJvciBBo_ZqFvoVx0fU7vrpk4UQ@mail.gmail.com>
References: <1411064300-4433-1-git-send-email-arturo.borrero.glez@gmail.com>
 <1411064300-4433-3-git-send-email-arturo.borrero.glez@gmail.com> <49a03ccd-ddb8-47dc-b455-885ddf607e6a@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:44374 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275AbaISHEi convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Sep 2014 03:04:38 -0400
Received: by mail-la0-f52.google.com with SMTP id gq15so2525693lab.25
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Sep 2014 00:04:37 -0700 (PDT)
In-Reply-To: <49a03ccd-ddb8-47dc-b455-885ddf607e6a@email.android.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18 September 2014 20:39, Patrick McHardy <kaber@trash.net> wrote:
> On 18. September 2014 20:18:20 MESZ, Arturo Borrero Gonzalez <arturo.=
borrero.glez@gmail.com> wrote:
>>This patch adds options to choose set optimization mechanisms.
>>
>>Two new statements are added to the set syntax, and they can be mixed=
:
>>
>> nft add set filter set1 { type ipv4_addr ; size 1024 ; }
>> nft add set filter set1 { type ipv4_addr ; policy memory ; }
>> nft add set filter set1 { type ipv4_addr ; policy performance ; }
>>nft add set filter set1 { type ipv4_addr ; policy memory ; size 1024 =
;
>>}
>>nft add set filter set1 { type ipv4_addr ; size 1024 ; policy memory =
;
>>}
>>nft add set filter set1 { type ipv4_addr ; policy performance ; size
>>1024 ; }
>>nft add set filter set1 { type ipv4_addr ; size 1024 ; policy
>>performance ; }
>>
>>Also valid for maps:
>>
>>nft add map filter map1 { type ipv4_addr : verdict ; policy performac=
e
>>; }
>> [...]
>>
>>
>>This is the output format, which can be imported later with `nft -f':
>>
>>table filter {
>>       set set1 {
>>               type ipv4_addr
>>               policy memory
>>               size 1024
>>       }
>>}
>
> Conceptually this looks good, I'll have a look at the implementation =
after dinner.
>
> What my patch did was only handle the case where limits can be determ=
ined automatically, IOW literal sets. Both is needed.
>

Do you mean to give the size parameter a value when we know the set
has a concrete number of elements?
=46or example:
add rule tcp dport {1 , 2 , 3} counter --> then add a set with fixed si=
ze 3.

I realize now the patch includes some newlines included by mistake. So
a v2 is likely to be needed.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
