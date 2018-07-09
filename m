From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net-next] netfilter: fix NETFILTER_XT_TARGET_TEE dependencies
Date: Mon, 9 Jul 2018 17:27:04 +0200
Message-ID: <CAK8P3a10sLvYb1=ZS9K_-Nf+vzY_ZkFsTRmZ3Bz7KMZL8g8MSw@mail.gmail.com>
References: <20180706123805.2852900-1-arnd@arndb.de> <20180706124542.jybscbmzixyt4rx2@salvia>
 <20180706124827.xwho2rgu3jkk3hp5@salvia> <CAK8P3a23rdqk-5i_6jLtCH6Z+_SSJ-0=5r=KfPuL-Xaas=6VyA@mail.gmail.com>
 <20180706155401.7jwc5laxqvnfpiur@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?TcOhdMOpIEVja2w=?= <ecklm94@gmail.com>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        "Pablo M. Bermudo Garay" <pablombg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180706155401.7jwc5laxqvnfpiur@salvia>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jul 6, 2018 at 5:54 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Jul 06, 2018 at 03:05:13PM +0200, Arnd Bergmann wrote:
>> On Fri, Jul 6, 2018 at 2:48 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > On Fri, Jul 06, 2018 at 02:45:42PM +0200, Pablo Neira Ayuso wrote:
>> >> On Fri, Jul 06, 2018 at 02:37:58PM +0200, Arnd Bergmann wrote:
>> >> > With NETFILTER_XT_TARGET_TEE=y and IP6_NF_IPTABLES=m, we get a link
>> >> > error when referencing the NF_DUP_IPV6 module:
>> >> >
>> >> > net/netfilter/xt_TEE.o: In function `tee_tg6':
>> >> > xt_TEE.c:(.text+0x14): undefined reference to `nf_dup_ipv6'
>> >> >
>> >> > The problem here is the 'select NF_DUP_IPV6 if IP6_NF_IPTABLES'
>> >> > that forces NF_DUP_IPV6 to be =m as well rather than setting it
>> >> > to =y as was intended here. Adding a soft dependency on
>> >> > IP6_NF_IPTABLES avoids that broken configuration.
>> >>
>> >> Applied to nf.git, thanks Arnd.
>> >
>> > Sorry, let me reconsider.
>> >
>> > We many need similar patches to other spots in 35bf1ccecaaa ?
>> >
>> > If so, it would be good to fix in the one go.
>>
>> I'm fairly sure that  NETFILTER_XT_TARGET_LOG is safe, since
>> NF_LOG_IPV6 already depends on IP6_NF_IPTABLES.
>>
>> NF_SOCKET_IPV6 like NF_DUP_IPV6 does not depend on
>> IP6_NF_IPTABLES, so we may have a similar problem there, though
>> I have not come across that. I have done only a few hundred randconfig
>> builds since I started yesterday, so I may have missed something,
>> but I think this is safe because CONFIG_NF_SOCKET_IPV6 is
>> used like a 'bool' symbol these days, we don't actually control building
>> a module with it, only a small portion in the nft_socket file.
>
> Thanks for explaining.

Unfortunately I came across a related build error that my patch failed
to address. I've sent another patch for that one. Feel free to fold it
into my first patch in case you rebased before you forward the patches
to net-next.

      Arnd
