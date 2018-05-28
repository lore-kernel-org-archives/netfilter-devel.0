From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: Re: [PATCH net-next v16 4/8] netfilter: Add nf_ct_get_tuple_skb callback
Date: Mon, 28 May 2018 23:28:41 +0200
Message-ID: <87d0xftqpi.fsf@toke.dk>
References: <152751762093.30935.15398977119837536494.stgit@alrua-kau> <152751766686.30935.14644567905547700823.stgit@alrua-kau> <20180528194902.kooqoao3agt32nls@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180528194902.kooqoao3agt32nls@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> On Mon, May 28, 2018 at 04:27:46PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
> [...]
>> diff --git a/net/netfilter/core.c b/net/netfilter/core.c
>> index 0f6b8172fb9a..520565198f0e 100644
>> --- a/net/netfilter/core.c
>> +++ b/net/netfilter/core.c
>> @@ -572,6 +572,27 @@ void nf_conntrack_destroy(struct nf_conntrack *nfct)
>>  }
>>  EXPORT_SYMBOL(nf_conntrack_destroy);
>>=20=20
>> +bool (*skb_ct_get_tuple)(struct nf_conntrack_tuple *,
>> +			 const struct sk_buff *) __rcu __read_mostly;
>> +EXPORT_SYMBOL(skb_ct_get_tuple);
>
> Now we have struct nf_ct_hook in net-next, please add ->get_tuple to
> that new object.

Ah, right, will do :)

-Toke
