From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: [PATCH] CTA_PROTO_NUM is u_int8_t not u_int16_t (was Re:
 CTA_PROTO_NUM u_int8_t or u_int16_t)
Date: Fri, 25 Nov 2005 01:28:36 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511250126250.15306@bizon.gios.gov.pl>
References: <4381FDF8.6030508@trash.net> <43820874.2050708@eurodev.net>
	<4382A19D.9090201@trash.net> <43836BAF.2050501@eurodev.net>
	<Pine.LNX.4.64.0511222103050.9114@bizon.gios.gov.pl>
	<20051122220606.GC31478@sunbeam.de.gnumonks.org>
	<4383C2C9.8050109@eurodev.net> <43843ACE.4050808@trash.net>
	<Pine.LNX.4.64.0511231128510.9162@bizon.gios.gov.pl>
	<20051124200736.GW31478@sunbeam.de.gnumonks.org>
	<20051124202125.GX31478@sunbeam.de.gnumonks.org>
	<43864DC7.6060109@trash.net>
	<Pine.LNX.4.64.0511250040030.14092@bizon.gios.gov.pl>
	<438656AE.9020307@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-749071533-1132878516=:15306"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <438656AE.9020307@trash.net>
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

---187430788-749071533-1132878516=:15306
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 25 Nov 2005, Patrick McHardy wrote:

> Krzysztof Oledzki wrote:
>> Old binaries are not able to deal with CTA_PROTO and will not be able to=
=20
>> parse this attribute received from kernel. We should keep CTA_PROTO_NUM=
=20
>> here, but this leads to u_int8_t/u_int16_t mismatch in the code.
>
> I didn't notice that, we of course need to dump both attributes.
Both? We already send CTA_PROTO_NUM as u_int8_t to userspace and=20
libnfnetlink has no problem with that.

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-749071533-1132878516=:15306--
