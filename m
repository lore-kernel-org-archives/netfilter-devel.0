From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: load balacing with https home banking
Date: Mon, 25 Dec 2006 02:49:28 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0612250242500.27316@bizon.gios.gov.pl>
References: <BAY103-DAV25AE1C31A08B7725D1CACB2D60@phx.gbl>
	<4580827A.7090708@trash.net>
	<BAY103-DAV11AB3769A4A2BB8625C42AB2D50@phx.gbl>
	<45812BA7.3000809@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1302603799-1167011368=:27316"
Cc: netfilter-devel@lists.netfilter.org, Marco Berizzi <pupilla@hotmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <45812BA7.3000809@trash.net>
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

---187430788-1302603799-1167011368=:27316
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 14 Dec 2006, Patrick McHardy wrote:

> Marco Berizzi wrote:
>> Patrick McHardy wrote:
>>
>>> Different TOS values might still break the thing, for it should work
>>
>> for
>>
>>> HTTP/HTTPS.
>>
>>
>> Just for ask: why different TOS values should break?
>
> Cached routes are keyed on (src,dst,iif,oif,mark,tos).
> Different tos values cause new routing lookups which
> might result in a different path.

IMHO you man not relay on routing cache anyway, as it may be invalidated=20
(flushed) at any time, for example when you add or remove a single routing=
=20
entry.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1302603799-1167011368=:27316--
