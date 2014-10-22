From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH v3] utils: fix arp family number
Date: Wed, 22 Oct 2014 16:24:22 +0200
Message-ID: <CAOkSjBhzYJqihNrbaSCgV+QRXwunjDU60OAJ_X2wusLk+Hnwcw@mail.gmail.com>
References: <20141020115049.27980.35459.stgit@nfdev.cica.es>
 <20141021075927.GA3610@salvia> <CAOkSjBgmmE0MUPY10u1iOKgBsN4P3y9mLM3FHcMzA7hL3maP8Q@mail.gmail.com>
 <20141021095649.GA5248@salvia> <20141021095741.GA5493@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:32771 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbaJVOYp convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:24:45 -0400
Received: by mail-la0-f48.google.com with SMTP id gi9so2992613lab.7
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Oct 2014 07:24:43 -0700 (PDT)
In-Reply-To: <20141021095741.GA5493@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21 October 2014 11:57, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
> On Tue, Oct 21, 2014 at 11:56:49AM +0200, Pablo Neira Ayuso wrote:
>> On Tue, Oct 21, 2014 at 10:53:19AM +0200, Arturo Borrero Gonzalez wr=
ote:
>> > On 21 October 2014 09:59, Pablo Neira Ayuso <pablo@netfilter.org> =
wrote:
>> > >
>> > > BTW, it would be good to see a similar refactor in nft_verdict2s=
tr().
>> >
>> > I don't see a clean way to do it, given some verdicts are negative
>> > numbers (enum nft_verdicts in nf_tables.h).
>> > We may end accessing a negative index, out of bounds of the array.
>>
>> I see, you mean:
>>
>> enum nft_verdicts {
>>         NFT_CONTINUE    =3D -1,
>>         NFT_BREAK       =3D -2,
>>         NFT_JUMP        =3D -3,
>>         NFT_GOTO        =3D -4,
>>         NFT_RETURN      =3D -5,
>> };
>>
>> You can add some function to shift the values:
>>
>> #define nft_verdict_index(base)     (base + 5)
>
> BTW, instead of 5, add:
>
> #define NFT_VERDICT_BASE        NFT_RETURN
>
> and use it.
>
>>
>> ... nft_verdict_array[] =3D {
>>         [nft_verdict_index(NFT_RETURN)]     =3D "return",
>>         ...
>> };

Ok, following your idea, I end with something like this:

/*
 * NF_DROP      =3D 0
 * NF_ACCEPT    =3D 1
 * NFT_JUMP     =3D -3
 * NFT_GOTO     =3D -4
 * NFT_RETURN   =3D -5
 */

#define NFT_VERDICT_BASE                -NFT_RETURN
#define nft_verdict_index(base)         (base + NFT_VERDICT_BASE)
#define NFT_VERDICT_ARRAY_LEN           nft_verdict_index(NF_ACCEPT)

static const char *const nft_verdict_str[NFT_VERDICT_ARRAY_LEN + 1] =3D=
 {
        [nft_verdict_index(NFT_RETURN)] =3D       "return",       /* 0 =
*/
        [nft_verdict_index(NFT_GOTO)]   =3D       "goto",         /* 1 =
*/
        [nft_verdict_index(NFT_JUMP)]   =3D       "jump",         /* 2 =
*/
        [nft_verdict_index(NF_DROP)]    =3D       "drop",         /* 5 =
*/
        [nft_verdict_index(NF_ACCEPT)]  =3D       "accept",       /* 6 =
*/
};

const char *nft_verdict2str(int verdict)
{
        if (nft_verdict_str[nft_verdict_index(verdict)] =3D=3D NULL)
                return "unknown";

        return nft_verdict_str[nft_verdict_index(verdict)];
}

int nft_str2verdict(const char *verdict, int *verdict_num)
{
        int i;

        for (i =3D 0; i < NFT_VERDICT_ARRAY_LEN; i++) {
                if (nft_verdict_str[i] =3D=3D NULL)
                        continue;

                if (strcmp(nft_verdict_str[i], verdict) =3D=3D 0) {
                        *verdict_num =3D nft_verdict_index(i);
                        return 0;
                }
        }

        return -1;
}

I think the current code (the switch based one) is better, don't you?
That array seems very error prone.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
