From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] extensions: libip6t_REJECT: Add translation to nft
Date: Tue, 5 Jan 2016 14:49:39 +0100
Message-ID: <CAOkSjBgDiaergNSesJYTY0Qs8Z6b3tDojCRO_OSNEoEeC1JP=g@mail.gmail.com>
References: <20160105065504.GA5780@gmail.com> <CAOkSjBiBO6Aj-dmgBLB4jctWD_aXim3cJmoPcWC3_we-SG=YVQ@mail.gmail.com>
 <CAKHNQQGSuA8u4TKM7AxvjwQP=RqbJP+2n4+0AZKEBJ6V7NP9Lw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35627 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbcAENuA convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jan 2016 08:50:00 -0500
Received: by mail-wm0-f41.google.com with SMTP id f206so23631069wmf.0
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Jan 2016 05:50:00 -0800 (PST)
In-Reply-To: <CAKHNQQGSuA8u4TKM7AxvjwQP=RqbJP+2n4+0AZKEBJ6V7NP9Lw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 5 January 2016 at 13:48, Shivani Bhardwaj <shivanib134@gmail.com> wr=
ote:
> On Tue, Jan 5, 2016 at 5:00 PM, Arturo Borrero Gonzalez
> <arturo.borrero.glez@gmail.com> wrote:
>> On 5 January 2016 at 07:55, Shivani Bhardwaj <shivanib134@gmail.com>=
 wrote:
>>>
>>> +static const struct reject_names_xlate reject_table_xlate[] =3D {
>>> +       {"no-route",            IP6T_ICMP6_NO_ROUTE},
>>> +       {"admin-prohibited",    IP6T_ICMP6_ADM_PROHIBITED},
>>> +#if 0
>>> +       {"not-neighbour",       IP6T_ICMP6_NOT_NEIGHBOR},
>>> +#endif
>>> +       {"addr-unreachable",    IP6T_ICMP6_ADDR_UNREACH},
>>> +       {"port-unreachable",    IP6T_ICMP6_PORT_UNREACH},
>>> +       {"tcp reset",           IP6T_TCP_RESET},
>>> +       {"policy-fail",         IP6T_ICMP6_POLICY_FAIL},
>>> +       {"reject-route",        IP6T_ICMP6_REJECT_ROUTE}
>>> +};
>>
>> I wonder the reason behind including code which seems is not going t=
o
>> be compiled.
>> It was in the original extension code, perhaps you can revisit that =
now.
>>
> Hi Arturo,
>
> I've removed the if endif block. Thanks for pointing out.
> If you're referring to some other thing please let me know.
>
>>> +
>>> +static int REJECT_xlate(const struct xt_entry_target *target,
>>> +                       struct xt_buf *buf, int numeric)
>>> +{
>>> +       const struct ip6t_reject_info *reject =3D
>>> +                               (const struct ip6t_reject_info *)ta=
rget->data;
>>> +       unsigned int i;
>>> +
>>> +       for (i =3D 0; i < ARRAY_SIZE(reject_table_xlate); ++i)
>>> +               if (reject_table_xlate[i].with =3D=3D reject->with)
>>> +                       break;
>>> +       if (reject->with =3D=3D IP6T_TCP_RESET)
>>> +               xt_buf_add(buf, "reject with %s", reject_table_xlat=
e[i].name);
>>> +       else
>>> +               xt_buf_add(buf, "reject with icmpv6 type %s",
>>> +                          reject_table_xlate[i].name);
>>> +
>>> +       return 1;
>>> +}
>>> +
>>
>> AFAIK, -j REJECT can be used without further options. However, this
>> _xlate() function doesn't seem to support it.
>>
>> I would print unconditionally the 'reject' keyword and in case some
>> option was used, then include the 'with XXX' thing.
>>
>
> In the reject module for ip, port unreachable is mentioned as the
> default option if the reject target is called.
>
> static const struct reject_names reject_table[] =3D {
> ...
> {"icmp-port-unreachable", "port-unreach",
>                 IPT_ICMP_PORT_UNREACHABLE, "ICMP port unreachable (de=
fault)"}
> ...
> }
>
> Same is happening in case of ipv6. Should I be removing this default
> nature of both of them?
>

Ok,

reading now the code in depth, I see there is no way the _xlate() can
get a REJECT target without the 'with' option.

So your patch looks good.

Acked-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
