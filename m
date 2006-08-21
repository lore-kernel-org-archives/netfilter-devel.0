From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: [PATCH 2/3][CONNTRACK] Introduce the pickup facilities to take
 over TCP connections
Date: Mon, 21 Aug 2006 12:18:22 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0608211214120.25230@bizon.gios.gov.pl>
References: <44E972E1.4080500@netfilter.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1142079072-1156155502=:25230"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <44E972E1.4080500@netfilter.org>
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

---187430788-1142079072-1156155502=:25230
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 21 Aug 2006, Pablo Neira Ayuso wrote:

> This patch introduces a new flag called IPS_PICKUP that forces the protoc=
ol=20
> handler to pick up the window of valid TCP packets. Moreover, four new=20
> attributes to inject the window scale factor and enable SACK are introduc=
ed.
>
> These new facilities provide the appropiate mechanisms to take over TCP=
=20
> connections in failover settings with TCP tracking enabled.
>

Are there any plans for active-active synchronization? This requires=20
online TCP SEQ sync or to keep connections in IPS_PICKUP state forever,=20
doesn't it?

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1142079072-1156155502=:25230--
