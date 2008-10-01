From: David Miller <davem@davemloft.net>
Subject: Re: [net-next PATCH 03/16] Allow binding to non-local addresses if
 IP_TRANSPARENT is set
Date: Wed, 01 Oct 2008 07:31:42 -0700 (PDT)
Message-ID: <20081001.073142.267502679.davem@davemloft.net>
References: <20081001142431.4893.48078.stgit@este>
	<20081001142431.4893.89758.stgit@este>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: hidden@sch.bme.hu
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20081001142431.4893.89758.stgit@este>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

=46rom: KOVACS Krisztian <hidden@sch.bme.hu>
Date: Wed, 01 Oct 2008 16:24:31 +0200

> Setting IP_TRANSPARENT is not really useful without allowing non-loca=
l
> binds for the socket. To make user-space code simpler we allow these =
binds
> even if IP_TRANSPARENT is set but IP_FREEBIND is not.
>=20
> Signed-off-by: T=F3th L=E1szl=F3 Attila <panther@balabit.hu>

Applied to net-next-2.6

