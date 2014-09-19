From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nf_tables 1/3] netfilter: nf_tables: store and dump sets
 mechanism options
Date: Fri, 19 Sep 2014 08:51:48 +0200
Message-ID: <CAOkSjBjbW+vkbLZbOmFAdRxzbPTNQ-BkPdLN2asyAcaXO50arQ@mail.gmail.com>
References: <1411064300-4433-1-git-send-email-arturo.borrero.glez@gmail.com> <1de321c7-7c48-4dcb-a445-b27aae8d8bcf@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:56641 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaISGwL convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Sep 2014 02:52:11 -0400
Received: by mail-lb0-f180.google.com with SMTP id b12so2515207lbj.25
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Sep 2014 23:52:09 -0700 (PDT)
In-Reply-To: <1de321c7-7c48-4dcb-a445-b27aae8d8bcf@email.android.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18 September 2014 20:34, Patrick McHardy <kaber@trash.net> wrote:
> On 18. September 2014 20:18:18 MESZ, Arturo Borrero Gonzalez <arturo.=
borrero.glez@gmail.com> wrote:
>>The sets mechanism options was not being stored anywhere.
>>
>>We want to know in which cases the user explicitly set the mechanism
>>options. In that case, we also want to dump back the info.
>>
>
> I don't think this is needed. Basically we always want to dump option=
s for non-constant sets, since they couldn't have been chosen automatic=
ally, and don't need to dump them for constant sets, since they can alw=
ays be determined automatically based on the contents.
>

Could you please elaborate?

If the set is non-constant, currently the options are by default
NFT_SET_POL_PERFORMANCE and size 0.
Do you want these options to be printed to the end user even when the
user did not originally use the 'policy xx' and 'size xx' statements?
Or in the other hand, to never print the options even when the user
gave an explicit config?

In the case of constant sets, what If I want to test the performance
of different policies? I need to know which policy is applied to a
given set, (in order to change it).

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
