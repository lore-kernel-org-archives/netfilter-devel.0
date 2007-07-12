From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] LOG target - log GID
Date: Thu, 12 Jul 2007 18:03:24 +0900 (JST)
Message-ID: <200707120903.l6C93PS2025329@toshiba.co.jp>
References: <4693DD17.9020406@ae.poznan.pl>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: maciej.soltysiak@ae.poznan.pl
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4693DD17.9020406@ae.poznan.pl>
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

From: Maciej So=B3tysiak <maciej.soltysiak@ae.poznan.pl>
Date: Tue, 10 Jul 2007 21:25:11 +0200

> Hi,
> =

> While I was browsing through the files in my home directory I stumble=
d =

> upon my patch from
> May 2003 that adds to the LOG target an option to log UID and GID.
> =

> I noticed that someone already has done that in the past 4 years ;-)
> However currently LOG only logs UID. My patch used to log GID too, so=

> what do you say about applying the patches attached.

We cannot change format of LOG target because that breaks programs pars=
ing logs.
But it might be possible by introducing new option like '--log-gid'.

-- Yasuyuki Kozakai
