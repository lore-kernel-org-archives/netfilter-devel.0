From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] netfilter: finer grained nf_conn locking
Date: Mon, 30 Mar 2009 21:54:47 +0200
Message-ID: <49D12387.20507@cosmosbay.com>
References: <20090218051906.174295181@vyatta.com> <20090218052747.679540125@vyatta.com> <499BDB5D.2050105@trash.net> <499C1894.7060400@cosmosbay.com> <49CE568A.9090104@cosmosbay.com> <49D11635.2050809@hp.com> <Pine.LNX.4.64.0903302131390.13325@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netdev <netdev@vger.kernel.org>,
	Netfilter Developers <netfilter-devel@vger.kernel.org>
To: Jesper Dangaard Brouer <hawk@diku.dk>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0903302131390.13325@ask.diku.dk>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jesper Dangaard Brouer a =E9crit :
>=20
>> Eric Dumazet wrote:
>>>  "tbench 8" results on my 8 core machine (32bit kernel, with
>>>  conntracking on) : 2319 MB/s instead of 2284 MB/s
>=20
> How do you achieve this impressing numbers?
> Is it against localhost? (10Gbit/s is max 1250 MB/s)
>=20

tbench is a tcp test on localhost yes :)

Good to test tcp stack without going to NIC hardware


