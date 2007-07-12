From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] LOG target - log GID
Date: Thu, 12 Jul 2007 10:10:15 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707121009100.11053@fbirervta.pbzchgretzou.qr>
References: <4693DD17.9020406@ae.poznan.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-699020219-319730141-1184227815=:11053"
Cc: netfilter-devel@lists.netfilter.org
To: =?ISO-8859-2?Q?Maciej_So=B3tysiak?= <maciej.soltysiak@ae.poznan.pl>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-319730141-1184227815=:11053
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


On Jul 10 2007 21:25, Maciej So=C5=82tysiak wrote:
>
> I noticed that someone already has done that in the past 4 years ;-)
> However currently LOG only logs UID. My patch used to log GID too, so
> what do you say about applying the patches attached.

So.. what happens when you ping or a kernel thread (e.g. knfsd) sends out=
 data,
which do not normally have an owner?


	Jan
--=20
---699020219-319730141-1184227815=:11053--
