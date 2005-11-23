From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: [PATCH] CTA_PROTO_NUM is u_int8_t not u_int16_t (was Re:
 CTA_PROTO_NUM u_int8_t or u_int16_t)
Date: Wed, 23 Nov 2005 11:31:18 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511231128510.9162@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0511211534580.30476@bizon.gios.gov.pl>
	<4381DF77.2030704@eurodev.net> <4381FDF8.6030508@trash.net>
	<43820874.2050708@eurodev.net> <4382A19D.9090201@trash.net>
	<43836BAF.2050501@eurodev.net>
	<Pine.LNX.4.64.0511222103050.9114@bizon.gios.gov.pl>
	<20051122220606.GC31478@sunbeam.de.gnumonks.org>
	<4383C2C9.8050109@eurodev.net> <43843ACE.4050808@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1486620015-1132741878=:9162"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43843ACE.4050808@trash.net>
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

---187430788-1486620015-1132741878=:9162
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 23 Nov 2005, Patrick McHardy wrote:

> Pablo Neira wrote:
>> Harald Welte wrote:
>>
>>> another alternative was to introduce a new CTA_PROTO_NUM8 value, which
>>> is more explicit (but somehow stupid).
>>
>>
>> Why don't we send a patch to -stable? I think that most people will use
>> lastest stable branch in 2.6.14, so only < 2.6.14.3 would be broken. I
>> still don't like too much the idea of adding a new field just because of
>> this bugfix :(
>
> I would be fine with this.

Can we make it before 2.6.14.3? I don't know how long we are going to wait=
=20
for 2.6.14.4.

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-1486620015-1132741878=:9162--
