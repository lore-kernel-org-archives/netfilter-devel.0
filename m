From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: ipt_time fixes (resend, sorry)
Date: Fri, 14 Jan 2005 15:48:13 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0501141542230.3572@bizon.gios.gov.pl>
References: <Pine.LNX.4.61.0501141503220.9908@bizon.gios.gov.pl>
	<20050114143722.GA10088@ti64.telemetry-investments.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1891851402-1105714093=:3572"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Fabrice MARIE <fabrice@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
In-Reply-To: <20050114143722.GA10088@ti64.telemetry-investments.com>
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

---187430788-1891851402-1105714093=:3572
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 14 Jan 2005, Bill Rugolsky Jr. wrote:

> On Fri, Jan 14, 2005 at 03:04:38PM +0100, Krzysztof Oledzki wrote:
>> Hello,
>>
>> My two patches fixes two problem I have just found. I tried to
>> migrate from 2.4.x to the 2.6.11-rc1 kernel. Patches are against
>> patch-o-matic-ng-20050105 but can be cleanly applied to the latest
>> patch-o-matic-ng (20050113).
>>
>> 1. Fix compilation, without this patch I got:
>
> Yes, I also sent a patch for this.
Ah, sorry :(

Anyway, which version is the correct one? With or without "&"?

+static struct ipt_match time_match =3D {
+=09.name =3D "time",
+=09.match =3D &match,
+=09.checkentry =3D &checkentry,
+=09.me =3D THIS_MODULE
+};

+static struct ipt_match time_match =3D {
+=09.name=09=09=3D "time",
+=09.match=09=09=3D match,
+=09.checkentry=09=3D checkentry,
+=09.me=09=09=3D THIS_MODULE,
+};


>> 2. Fix time match when skb->stamp.tv_sec is 0. I don't know why but on
>> 2.6.11-rc1 (and probably others 2.6.x kernels) skb->stamp.tv_sec seems t=
o
>> be allways 0, even on PRE_ROUTING and LOCAL_IN. So I fixed it by allways
>> use kernel time byt only if skb->stamp.tv_sec is 0 (like in ULOG). With
>> such modification we no longer needs kerneltime in the "struct
>> ipt_time_info"
>> but I'm afraid we should keep it for binary compability, shouldn't we?
>
> This is most likely due to Andi Kleen's net timestamp optimization, which
> avoids calling gettimeofday in the network fastpath unless it is needed.

I see... So, where we should fix this in netfilter code?

Best regards,


 =09=09=09Krzysztof Ol=EAdzki
---187430788-1891851402-1105714093=:3572--
