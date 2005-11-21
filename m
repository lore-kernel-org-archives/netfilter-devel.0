From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: kernel BUG at kernel/sched.c:2833!
Date: Mon, 21 Nov 2005 10:48:07 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511211042240.10417@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0511141033001.8729@bizon.gios.gov.pl>
	<437882BE.6080705@eurodev.net>
	<Pine.LNX.4.64.0511162216140.16387@bizon.gios.gov.pl>
	<437BD093.3010905@eurodev.net>
	<20051117151135.GJ14201@sunbeam.de.gnumonks.org>
	<437D4825.1060801@eurodev.net> <437D4992.3040501@eurodev.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-624662319-1132566487=:10417"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <437D4992.3040501@eurodev.net>
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

---187430788-624662319-1132566487=:10417
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 18 Nov 2005, Pablo Neira wrote:

> Pablo Neira wrote:
>> @@ -527,10 +531,10 @@ ctnetlink_parse_tuple_proto(struct nfatt
>>
>>  =09proto =3D ip_conntrack_proto_find_get(tuple->dst.protonum);
>>
>> -=09if (likely(proto && proto->nfattr_to_tuple)) {
>> +=09if (likely(proto && proto->nfattr_to_tuple))
>>  =09=09ret =3D proto->nfattr_to_tuple(tb, tuple);
>
> Still not good. Forgot to remove that proto !=3D NULL checking. It's too
> late. I'll resend a patch tomorrow in the morning.

I'm still waiting... ;)

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-624662319-1132566487=:10417--
