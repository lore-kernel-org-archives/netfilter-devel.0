From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [PATCH] ipt_ROUTE for kernel 2.6.21.5
Date: Wed, 29 Aug 2007 13:23:14 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708291318130.4125@bizon.gios.gov.pl>
References: <2cb453e80707300742i66b81b95pde18e37a6db046d5@mail.gmail.com>
	<Pine.LNX.4.64.0707301644360.26373@fbirervta.pbzchgretzou.qr>
	<46ADF9FA.4000901@trash.net>
	<Pine.LNX.4.64.0707301649000.26373@fbirervta.pbzchgretzou.qr>
	<46ADFACE.5040304@trash.net>
	<Pine.LNX.4.64.0707301709370.4354@bizon.gios.gov.pl>
	<46AE0501.3080107@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1715579830-1188386594=:4125"
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Ludovic <ludovic.mailinglist@gmail.com>,
	netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46AE0501.3080107@trash.net>
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

---187430788-1715579830-1188386594=:4125
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 30 Jul 2007, Patrick McHardy wrote:

> Krzysztof Oledzki wrote:
>> 1. ROUTE has a very usefull option --tee. AFAIK it is not possible to do
>> it other way.
>
>
> Thats true. Not sure in what practical situation it is used though.
>
>> 2. Policy routing based on fwmark is not always an option if you use
>> marks for other purposes.
>
>
> Maybe (trying to avoid getting into discussion about too small mark
> values again :)).
>
>> So, if it is going to be removed from pom-ng I would like to keep it in
>> my external pomng-repository.
>
>
> Please go ahead.

So I added it to my pom-ng repository for now, with fixes for=20
2.6.21/2.6.22.

> Just FYI: One more reason for removing it is that its broken wrt.
> IPsec handling

Could you explain it a bit? What is wrong and maybe some clue how it=20
should be fixed?

> and the duplicated functions from ip_output are out
> of sync

OK, found it. This is a easy part to fix. :)

> (and I think there were a few smaller problems as well).

For example?

> If there really is a need for something like the tee functionality
> I'm not opposed to considering merging a clean patch without these
> problems for that.

OK. I'll do my best. :)

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1715579830-1188386594=:4125--
