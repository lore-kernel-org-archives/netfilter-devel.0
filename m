From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: new target: -j TEE
Date: Wed, 29 Aug 2007 21:30:16 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708292128310.24730@fbirervta.pbzchgretzou.qr>
References: <1188216512.6900.24.camel@basti79.freenet-ag.de>
	<Pine.LNX.4.64.0708271539140.11442@fbirervta.pbzchgretzou.qr>
	<1188237343.4548.4.camel@calypso>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-699020219-857271783-1188415816=:24730"
Cc: netfilter-devel@lists.netfilter.org
To: Sebastian =?ISO-8859-1?Q?Cla=DFen?= <Sebastian.Classen@freenet.ag>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1188237343.4548.4.camel@calypso>
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

---699020219-857271783-1188415816=:24730
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


On Aug 27 2007 19:55, Sebastian Cla=C3=9Fen wrote:
>>=20
>> * Is --gw 0.0.0.0 even supported/meaningful? It seems not, so some=20
>>   checks could be removed.
>
>No, theres no special meaning. I don't know which checks u mean.

if (tee_info->gw)
	route_gw(...)
else
	DEBUGP(...)

If gw is not allowed to be zero, then the else case is redundant.
Of course, gw=3D0 is valid I think, meaning the default gateway.


	Jan
--=20
---699020219-857271783-1188415816=:24730--
