From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [nf-failover] NAT support for peer-to-peer games
Date: Wed, 22 Sep 2004 14:00:21 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1095854420.2678.10.camel@nienna.balabit>
References: <00d901c49fb3$2dea51f0$e310f43e@manowar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Serguei I. Ivantsov" <manowar@gsc-game.kiev.ua>
In-Reply-To: <00d901c49fb3$2dea51f0$e310f43e@manowar>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


  Hi,

2004-09-21, k keltez=E9ssel 10:15-kor Serguei I. Ivantsov ezt =EDrta:
> http://www.hasenstein.com/HyperNews/get/linux-ip-nat/97.html

  In theory, all of this is implemented by Netfilter at the moment.
Based on http://alumnus.caltech.edu/~dank/peer-nat.html, Netfilter has
some code to make sure that all packets sent from a single local UDP
port are mapped to the same public IP and port. Unfortunately this code
is broken at the moment, but the fix should be really easy. (AFAIK Rusty
already has some patches to fix this.)

PS: please don't send emails like this to the netfilter-failover list,
it's really offtopic there. Use netfilter-devel instead.

--=20
 Regards,
   Krisztian KOVACS
