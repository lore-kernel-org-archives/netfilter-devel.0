From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: REDIRECT changes DST address of the packet
Date: Tue, 26 Jul 2005 12:06:17 +0200
Message-ID: <1122372377.24626.21.camel@nienna.balabit>
References: <20050725045409.35744.qmail@web60823.mail.yahoo.com>
	<42E57CE5.4070202@trash.net> <42E581D4.10402@trash.net>
	<1122370295.24626.10.camel@nienna.balabit> <42E60796.2060909@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42E60796.2060909@trash.net>
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

2005-07-26, k keltez=E9ssel 11.51-kor Patrick McHardy ezt =EDrta:
> >   We're using something similar as part of the transparent proxying
> > patchset, but unfortunately this requires enlarging the skb and is a
> > little hackish. The patch introduces an IP_RECVORIGADDRS socket optio=
n.
> > If you enable this sockopt on a UDP socket, then recvmsg() will retur=
n
> > the original addresses as a control message.
>=20
> Why does the skb need to be enlarged?

  To store the original address (it's stored in IPCB(skb)). Hmm, now
that you say, actually I'm not sure you have to enlarge it. At the
moment struct inet_skb_parm is small enough, so we might be able to put
the original address information into skb->cb. I'm not sure what would
be the right location for such information, however.

--=20
 Regards,
  Krisztian Kovacs
