From: Xiaotian Feng <xtfeng@gmail.com>
Subject: Re: [PATCH] Netfilter: Fix integer overflow in net/ipv6/netfilter/ip6_tables.c
Date: Tue, 23 Mar 2010 10:29:53 +0800
Message-ID: <7b6bb4a51003221929i16673523nd5f558ccbaace397@mail.gmail.com>
References: <20100320143240.GB2942@localhost.localdomain>
	 <4BA7A3CF.8070503@trash.net>
	 <628d1651003221834g543e3e6cl4ea39c0886cb4ba1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: wzt wzt <wzt.wzt@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <628d1651003221834g543e3e6cl4ea39c0886cb4ba1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Mar 23, 2010 at 9:34 AM, wzt wzt <wzt.wzt@gmail.com> wrote:
>> I can see that the size might cause an overflow in the addition with
>> sizeof(struct ipt_get_entries)
> That's the integer overflow i pointed.
> get.size is copy from the user space, =C2=A0it can be set as 0x7fffff=
ff,
> addition with sizeof(struct ipt_get_entries) can be overflow.

Patrick's point is that you're using "if (get.size >=3D INT_MAX /
sizeof(struct ipt_get_entries))"
So, did you find any chance that get.size * sizeof(struct
ipt_get_entries) >=3D INT_MAX ?

And, for the addition overflow, can it be caught by

"if (*len !=3D sizeof(struct ipt_get_entries) + get.size)"  ???

>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (*len !=3D sizeof(struct ipt_get_entrie=
s) + get.size) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0duprintf("get_=
entries: %u !=3D %zu\n",
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 *len, sizeof(get) + get.size);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINVAL=
;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> so, check get.size max value before addition with sizeof(struct
> ipt_get_entries) to prevent the integer overflow.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
>
