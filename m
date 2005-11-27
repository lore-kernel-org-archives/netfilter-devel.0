From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: [PATCH] CTA_PROTO_NUM is u_int8_t not u_int16_t (was Re:
 CTA_PROTO_NUM u_int8_t or u_int16_t)
Date: Sun, 27 Nov 2005 23:28:47 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511272313570.28434@bizon.gios.gov.pl>
References: <43836BAF.2050501@eurodev.net>
	<Pine.LNX.4.64.0511222103050.9114@bizon.gios.gov.pl>
	<20051122220606.GC31478@sunbeam.de.gnumonks.org>
	<4383C2C9.8050109@eurodev.net> <43843ACE.4050808@trash.net>
	<Pine.LNX.4.64.0511231128510.9162@bizon.gios.gov.pl>
	<20051124200736.GW31478@sunbeam.de.gnumonks.org>
	<20051124202125.GX31478@sunbeam.de.gnumonks.org>
	<43864DC7.6060109@trash.net>
	<Pine.LNX.4.64.0511250040030.14092@bizon.gios.gov.pl>
	<20051125084427.GL31478@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.64.0511251019330.32144@bizon.gios.gov.pl>
	<438710E1.2000202@trash.net> <4387A946.3000005@eurodev.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1188968981-1133130527=:28434"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
In-Reply-To: <4387A946.3000005@eurodev.net>
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

---187430788-1188968981-1133130527=:28434
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 26 Nov 2005, Pablo Neira Ayuso wrote:

> Patrick McHardy wrote:
>> Krzysztof Oledzki wrote:
>>>
>>> On Fri, 25 Nov 2005, Harald Welte wrote:
>>>
>>>> yes.  old libnetfilter_conntrack is broken, because it makes wrong siz=
e
>>>> assumptions.  But if we'd start introdcucing the "new scheme" I
>>>> proposed, we can guarantee not to run into any of these.
>>>
>>>
>>> Only if new libnetfilter_conntrack will send different messages to
>>> differnet kernels (u_int16_t for 2.6.14 and u_int8_t for 2.6.15+).
>>
>> I also thinks its a large overkill to introduce this scheme just to
>> handle brokeness, lets just try not to make this kind of mistake again.
>> Also it doesn't handle the byteorder-problem of this particular case,
>> so I don't think we should go this way.
>
> I agree. Sorry, I'm not willing to be repetitive but I still see a
> possible workaround as something ugly that we'll have to live with
> forever because of an early mistake in the development. If there will be
> more 2.6.14.x release, fixing it there can be a choice. In spite of
> everything, I understand that breaking backward compatibility isn't nice
> but in this case ctnetlink just got pushed forward and it's barely one
> month old.

So, I think what we can do is to fix it in 2.6.15, leave it unchanged in=20
2.6.14 and add kernel version checking to the libnetfilter_conntrack to=20
send u_int16_t for 2.6.14 and u_int8_t for 2.6.15+ (one if/else). I don't=
=20
know if (and when) there will be another 2.6.14-stable release.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1188968981-1133130527=:28434--
