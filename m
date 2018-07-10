From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] netfilter: NFT_SOCKET don't use NF_SOCKET_IPV6 without NF_TABLES_IPV6
Date: Tue, 10 Jul 2018 11:10:40 +0200
Message-ID: <CAK8P3a0zYmdoMdWdFDcWprZY_4w2hbMYq4--iZB=JE4x2UiscA@mail.gmail.com>
References: <20180709213537.2748896-1-arnd@arndb.de> <20180710080227.qwh53ahq26j6phhd@sch.bme.hu>
 <20180710080538.d7xqpjdvpksfrx6o@sch.bme.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Flavio Leitner <fbl@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: =?UTF-8?B?TcOhdMOpIEVja2w=?= <ecklm94@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180710080538.d7xqpjdvpksfrx6o@sch.bme.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jul 10, 2018 at 10:05 AM, M=C3=A1t=C3=A9 Eckl <ecklm94@gmail.com> w=
rote:
> On Tue, Jul 10, 2018 at 10:02:27AM +0200, M=C3=A1t=C3=A9 Eckl wrote:
>> On Mon, Jul 09, 2018 at 11:35:09PM +0200, Arnd Bergmann wrote:
>> > It is now possible to build the nft_socket module as built-in when
>> > NF_TABLES_IPV6 is disabled, and have NF_SOCKET_IPV6=3Dm set manually.
>> >
>> > In this case, the NF_SOCKET_IPV6 functionality will be useless accordi=
ng
>> > to the explanation in commit 35bf1ccecaaa ("netfilter: Kconfig: Change
>> > IPv6 select dependencies"), but on top of that it also causes a link
>> > error:
>> >
>> > net/netfilter/nft_socket.o: In function `nft_socket_eval':
>> > nft_socket.c:(.text+0x162): undefined reference to `nf_sk_lookup_slow_=
v6'
>> >
>> > This changes the compile-time check so we don't attempt to use
>> > the NF_SOCKET_IPV6 code when it cannot be used, and make it all
>> > compile again. That may lead to unexpected behavior when a user
>> > enables NF_SOCKET_IPV6 but cannot use it, but seems to be the
>> > logical conclusion of the 35bf1ccecaaa change.
>> >
>> > Fixes: 35bf1ccecaaa ("netfilter: Kconfig: Change IPv6 select dependenc=
ies")
>> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>
>> I think this should be fixed in the Kconfig rather than inside the modul=
e(s).

Should we revert your patch then, or do you have a better idea?

>> I did some investigation and it turns out that you missed a circumstance=
. This
>> link error occures only if NFT_SOCKET=3Dy && NF_SOCKET_IPV6=3Dm && NF_TA=
BLES_IPV6=3Dy
>> (cannot be m here if NFT_SOCKET is y).

No, if NF_TABLES_IPV6=3Dy the problem cannot happen, since NFT_SOCKET then
selects NF_SOCKET_IPV6=3Dy as well. Before your patch, it would always sele=
ct
NF_SOCKET_IPV6 when it could, so it worked in all configurations.

>>  And probably the same with
>> iptables-related modules. Probably this possibility should be eliminated=
.
>
> NF_TPROXY_IPV6 might be in the same situation.

I tried coming up with a combination that is broken for NF_TPROXY_IPV6=3Dm
but could not. From what I can see with

config NETFILTER_XT_TARGET_TPROXY
       tristate '"TPROXY" target transparent proxying support'
       depends on IP6_NF_IPTABLES || IP6_NF_IPTABLES=3Dn
       select NF_TPROXY_IPV6 if IP6_NF_IPTABLES

and

#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)

inside of net/netfilter/xt_TPROXY.c, there is no way we can end up with
xt_TPROXY calling into the nf_tproxy_ipv6 loadable module from
a built-in context. This is the same approach I used in my patch,
just with IP6_NF_IPTABLES instead of NF_SOCKET_IPV6, in both
the Kconfig dependency and the module.

      Arnd
