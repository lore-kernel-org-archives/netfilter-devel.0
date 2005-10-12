From: =?ISO-8859-1?Q?S=E9bastien_Bernard?= <seb@frankengul.org>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Wed, 12 Oct 2005 09:04:13 +0200
Message-ID: <434CB56D.7050508@frankengul.org>
References: <434C3485.2000700@frankengul.org>	<20051011.153257.75932845.davem@davemloft.net>	<20051012062218.GA2712@frankengul.org>
	<20051011.233149.40160652.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20051011.233149.40160652.davem@davemloft.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

David S. Miller a =E9crit :

>From: seb@frankengul.org
>Date: Wed, 12 Oct 2005 08:22:18 +0200
>
> =20
>
>>After building, the modules_install reports the symbol undefined.
>>Well, I see now that it is only a lack of EXPORT_SYMBOL.
>>   =20
>>
>
>Aha, that makes sense.
>
> =20
>
>>All smp arch used cpu_online_map and cpu_possible_map but sparc which
>>used phys_cpu_present_map (a specificity of the sparc port I presume).
>>   =20
>>
>
>Yes, we do this because since we lack cpu hotplug support
>this means "cpu present"=3D=3D"cpu possible".
>
> =20
>
Ok, heres is the oops provoked by the second patch posted by Harald on=20
the 11th of October.

unable to handle paging_request (some zeros...)140098000

iptables_restor(2488): Oops [#1]
TPC: <get_couters +0x68/0xe0>

Caller: do_ipt_get_ctl + 0x5b8/0x7a0
            nf_sock_opt + 0xa4 / 0x160
            ip_get_sockopt + 0xa4 / 0x5e0
            sock_common_getsockopt + 0x1c/0x40
            sys_get_sockopt + 0x84/0xe0
            compat_sys_getsockopt + 0x28/0x120
            linux_sparc_syscall32 + 0x34/0x40

Note that it is a different crash.
The previous was a unable to handle kernel request NULL dereference.
As a result, the machine locks hard.

Hope it helps.

    Seb
