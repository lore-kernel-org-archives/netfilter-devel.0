From: James Nurmi <jdnurmi@qwe.cc>
Subject: Re: Xtables2 Netlink spec
Date: Mon, 13 Dec 2010 18:16:30 -0800
Message-ID: <AANLkTikOeBAkGvPFUxw+FzHFZFNiaUzT7s7QxGcFgZtc@mail.gmail.com>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr>
	<alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu>
	<4D00C6A4.6090305@netfilter.org>
	<alpine.LNX.2.01.1012140257430.7384@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.01.1012140257430.7384@obet.zrqbmnf.qr>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Dec 13, 2010 at 6:01 PM, Jan Engelhardt <jengelh@medozas.de> wr=
ote:
>
> On Thursday 2010-12-09 13:08, Pablo Neira Ayuso wrote:
>>
>>If we follow the one message per rule basis, you can put several
>>messages into one batch with different sequence numbers. Thus, you ca=
n
>>know what message in the batch has triggered the error and the reason=
=2E
>
> /* The unwritten laws of netlink */
>
> Normally, the sequence number of a response message is simply
> the one from the request message. But in a dump where there
> can be multiple messages, do they all share the sequence number?
>
> Must the response sequence numbers match at all, or is it like TCP
> where each side has its own set?
>
> BTW, can response messages - all those leading up to NLMSG_DONE -
> have different nlmsg_type, or not? Does the nlmsg_type need
> to match the request type?
>

There's an upper layer netlink flag set (NLM_F_MULTI , NLMSG_DONE,
etc) that's usually used in NETLINK_ROUTE, etc.

Essentially, you set the MULTI flag on multi-part messages, and DONE
on the last one, clients are expected to collect and respond;

In those cases, the sequence number does NOT change intra-messageset
in my experience, instead it is assumed they may be received out of
order.

> Jan
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
