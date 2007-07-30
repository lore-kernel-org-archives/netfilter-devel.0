From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] ipt_ROUTE for kernel 2.6.21.5
Date: Mon, 30 Jul 2007 16:45:18 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707301644360.26373@fbirervta.pbzchgretzou.qr>
References: <2cb453e80707300742i66b81b95pde18e37a6db046d5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-699020219-1889860985-1185806718=:26373"
Cc: netfilter-devel@lists.netfilter.org
To: Ludovic <ludovic.mailinglist@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <2cb453e80707300742i66b81b95pde18e37a6db046d5@mail.gmail.com>
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

---699020219-1889860985-1185806718=:26373
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


On Jul 30 2007 16:42, Ludovic wrote:
>Hi guys,
>
>sorry if there is already some patches about this but i've searched
>one week how to make the ROUTE target work well.
>
>Here are two patches (one for ipv4 and one for ipv6) which change
>ipt_register and ipt_unregister to xt_register and xt_unregister and
>which add .family =3D AF_INET in the xt_target structure declaration.

Somehow this feels like d=C3=A9j=C3=A0-vu. ipt_ROUTE is, well, a hack
and the proper solution to it is policy routing; e.g. based on fwmark.


	Jan
--=20
---699020219-1889860985-1185806718=:26373--
