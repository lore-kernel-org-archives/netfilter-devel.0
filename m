From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: SACK out of window segments?
Date: Thu, 21 Jul 2005 10:19:47 +0200
Message-ID: <1121933987.15942.9.camel@nienna.balabit>
References: <20050720.122652.28782810.davem@davemloft.net>
	<Pine.LNX.4.58.0507202219360.26391@blackhole.kfki.hu>
	<1121928338.15942.3.camel@nienna.balabit>
	<20050721.010634.92583580.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20050721.010634.92583580.davem@davemloft.net>
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


  Hi,

2005-07-21, cs keltez=E9ssel 01.06-kor David S. Miller ezt =EDrta:
> That means the trace doesn't necessarily show exactly what the client
> sees, nor what the server sees....

  The proxy _is_ the client, so the dump should be accurate wrt the
client's packets, shouldn't it? (The TCP connection was established
between the public IP of the proxy and the web server.) Of course we
don't know anything about the server and the firewalls between the
endpoints...

--=20
 Regards,
  Krisztian Kovacs
