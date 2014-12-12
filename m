From: leroy christophe <christophe.leroy@c-s.fr>
Subject: Re: bug : nft_redirect port byteorder issue
Date: Fri, 12 Dec 2014 13:55:01 +0100
Message-ID: <548AE5A5.8020104@c-s.fr>
References: <54885B08.1010700@c-s.fr> <20141210182244.GA5622@salvia> <548AC07D.6080703@c-s.fr> <CAOkSjBj3uY8f==Xwc1GirAgj7-QdtViOxVMFhfPKxUFnJX9dVA@mail.gmail.com> <548ACC89.5060700@c-s.fr> <CAOkSjBiDnZPHyGoHy+zmA9Kc957KfxRd6U86J+B21124i4Z5jA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: GUITTON Alex <alex.guitton@c-s.fr>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:29537 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967744AbaLLMzD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Dec 2014 07:55:03 -0500
In-Reply-To: <CAOkSjBiDnZPHyGoHy+zmA9Kc957KfxRd6U86J+B21124i4Z5jA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Le 12/12/2014 12:55, Arturo Borrero Gonzalez a =C3=A9crit :
> On 12 December 2014 at 12:07, leroy christophe <christophe.leroy@c-s.=
fr> wrote:
>> Le 12/12/2014 11:49, Arturo Borrero Gonzalez a =C3=A9crit :
>>> With nft_nat and nft_redir_ipv6, the three code are almost the same=
:
>>>
>>>
>>> http://git.kernel.org/cgit/linux/kernel/git/pablo/nf-next.git/tree/=
net/netfilter/nft_nat.c
>>>
>>> http://git.kernel.org/cgit/linux/kernel/git/pablo/nf-next.git/tree/=
net/ipv6/netfilter/nft_redir_ipv6.c
>>>
>>> Since it seems the same issue may appear, would you like to patch a=
ll of
>>> them?
>>>
>>> regards.
>> Hi,
>>
>> Yes the issue is most likely the same, so I believe it should also b=
e fixed
>> there.
>>
> BTW, please send your patches to netfilter-devel. No need to CC
> netfilter@vger.kernel.org.
> Patches should include the Signed-off-by line (please be sure they
> apply with git am).
>
> Thanks, regards.
>
I'm not sure what I proposed it the correct patch, maybe it shall be=20
fixed earlier in the chain, I don't know.
So I prefer you or Pablo look at it and do what's best.

Regards
Christophe


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
