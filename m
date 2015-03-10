From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH] src: add tee statement support
Date: Tue, 10 Mar 2015 14:12:45 +0100
Message-ID: <CAOkSjBgevzm49U6-X8fjHNYNPY_OkPQN90qnnpzep=-HKt2Qtg@mail.gmail.com>
References: <20150309193820.6763.36920.stgit@nfdev.cica.es>
 <CAOkSjBhq2z0kmq3Xd_smgcj+JoVCn7kEJHCRz2ccRc5FTVpiGw@mail.gmail.com> <20150310113445.GA3814@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:43246 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbbCJNNH convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Mar 2015 09:13:07 -0400
Received: by lbvp9 with SMTP id p9so1536650lbv.10
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2015 06:13:05 -0700 (PDT)
In-Reply-To: <20150310113445.GA3814@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10 March 2015 at 12:34, Pablo Neira Ayuso <pablo@netfilter.org> wrot=
e:
> On Tue, Mar 10, 2015 at 11:31:00AM +0100, Arturo Borrero Gonzalez wro=
te:
>> On 9 March 2015 at 20:38, Arturo Borrero Gonzalez
>> <arturo.borrero.glez@gmail.com> wrote:
>> > The syntax is:
>> >  tee gw <addr> [oifname <str>]
>> >
>> [...]
>> >
>> > +tee_stmt               :       tee_stmt_alloc  tee_stmt_opt
>> > +                       ;
>> > +
>> > +tee_stmt_alloc         :       TEE
>> > +                       {
>> > +                               $$ =3D tee_stmt_alloc(&@$);
>> > +                       }
>> > +                       ;
>> > +
>> > +tee_stmt_opt           :       GW              expr
>> > +                       {
>> > +                               $<stmt>0->tee.gw =3D $2;
>> > +                       }
>> > +                       |       OIFNAME         STRING
>> > +                       {
>> > +                               $<stmt>0->tee.oifname =3D strdup($=
2);
>> > +                       }
>> > +                       ;
>> > +
>>
>> This grammar is not completely right.
>>
>> However, using something like this:
>>
>> tee_stmt                :       TEE             tee_stmt_opts
>>                         {
>>                                 $$ =3D tee_stmt_alloc(&@$);
>>                         }
>>                         ;
>>
>> tee_stmt_opts           :       tee_stmt_opts   tee_stmt_opt
>>                         |       tee_stmt_opt
>>                         ;
>>
>> tee_stmt_opt            :       GW              expr
>>                         {
>>                                 $<stmt>0->tee.gw =3D $2;
>>                         }
>>                         |       OIFNAME         string
>>                         {
>>                                 $<stmt>0->tee.oifname =3D strdup($2)=
;
>>                         }
>>                         ;
>>
>> lead to shift/reduce conflicts, because expr can be `OIFNAME string'=
=2E
>>
>> Any idea?
>
> You use STRING instead for GW and make sure from the evaluation step
> that this is a valid address?

Nop :-( still conflict.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
