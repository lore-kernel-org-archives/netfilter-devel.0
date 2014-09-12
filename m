From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft RFC PATCH] src: add set optimization options
Date: Fri, 12 Sep 2014 20:35:03 +0200
Message-ID: <CAOkSjBiWRHDx13UW34gMa_wfD2VZseETE+BQss3Qi2JbhAcRCw@mail.gmail.com>
References: <20140813081649.25737.82564.stgit@nfdev.cica.es>
 <20140903100959.GA17083@salvia> <20140903102233.GC4069@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:40981 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaILSfZ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:35:25 -0400
Received: by mail-la0-f41.google.com with SMTP id s18so1505636lam.28
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Sep 2014 11:35:24 -0700 (PDT)
In-Reply-To: <20140903102233.GC4069@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 3 September 2014 12:22, Patrick McHardy <kaber@trash.net> wrote:
> On Wed, Sep 03, 2014 at 12:09:59PM +0200, Pablo Neira Ayuso wrote:
>> Cc'ing Patrick.
>>
>> On Wed, Aug 13, 2014 at 10:17:06AM +0200, Arturo Borrero Gonzalez wr=
ote:
>> > This patch adds options to choose set optimization mechanisms.
>> >
>> > The syntax is one of:
>> >
>> >  nft add set filter set1 { type ipv4_addr size 1024 ; }
>> >  nft add set filter set1 { type ipv4_addr policy memory ; }
>> >  nft add set filter set1 { type ipv4_addr policy performance ; }
>> >  nft add set filter set1 { type ipv4_addr policy memory size 1024 =
; }
>> >  nft add set filter set1 { type ipv4_addr size 1024 policy memory =
; }
>> >  nft add set filter set1 { type ipv4_addr policy performance size =
1024 ; }
>> >  nft add set filter set1 { type ipv4_addr size 1024 policy perform=
ance ; }
>>
>> @Patrick: Does this syntax look reasonable to you?
>
> I think I would prefer having statements instead of everything combin=
ed.
>

Could you please elaborate on this?

>> > Also valid for maps:
>> >
>> >  nft add map filter map1 { type ipv4_addr : verdict policy perform=
ace ; }
>> >  [...]
>> >
>> >
>> > This is the output format, which can be imported later with `nft -=
f':
>> >
>> > table filter {
>> >     set set1 {
>> >             type ipv4_addr policy memory size 1024
>> >     }
>> > }
>> >
>> > Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.=
com>
>> > ---
>> >
>> > This is my proposal for set internal mechanism selection in nft.
>> >
>> > My idea is: given the kernel uses optional arguments to choose the
>> > set mechanism, in userspace the configuration should be also optio=
nal.
>
> Agreed.
>
>> > The patch is not fully tested, there are still some issues; It see=
ms that the
>> > kernel is lacking some details.
>> > For example, it doesn't dump back to userspace the policy configur=
ation.
>> >
>> > In my opinion, we should be able to inform userspace of the config=
uration, in a
>> > way that userspace can differentiate between default values and fi=
xed ones.
>> > For example, NFT_SET_POL_PERFORMANCE seems to be the default in ke=
rnel, but
>> > we don't want every set to be printed with "policy performance".
>> >
>> > Please, feel free to comment.
>>
>> Just one minor comment:
>>
>>      struct {
>>              uint32_t        flags;
>>              uint32_t        policy;
>>              struct {
>>                      uint32_t        size;
>>              } desc;
>>      } mechanism;
>> };
>>
>> I prefer if you map 1:1 what we have in the kernel:
>>
>>         struct set {
>>                 ...
>>                 uint32_t policy;
>>                 struct {
>>                         uint32_t size;
>>                         uint32_t flags;
>>                 } desc;
>>         };
>
> This is what I have in my patchset:
>
> +struct set_desc {
> +       unsigned int            size;
> +       struct expr             *range;
> +};
>
> Range is another way to express the maximum size and at the same time=
 a
> common prefix.
>
> I can dust off my patch and send it later so we combine what we have.

Would you send that patch?

thanks.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
