From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: Patch for ipt_time (to enable start > stop / crossing midnight)
Date: Wed, 4 Jan 2006 18:09:04 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0601041758580.22709@bizon.gios.gov.pl>
References: <20060104142750.GF15217@schlittermann.de>
	<Pine.LNX.4.64.0601041639400.19966@bizon.gios.gov.pl>
	<43BBF971.50307@info-link.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1195583745-1136394544=:22709"
Cc: netfilter-devel@lists.netfilter.org,
	Heiko Schlittermann <hs@schlittermann.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Brad Fisher <brad@info-link.net>
In-Reply-To: <43BBF971.50307@info-link.net>
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

---187430788-1195583745-1136394544=:22709
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 4 Jan 2006, Brad Fisher wrote:

> I've also sent a couple of patches to add this functionality to Fabrice a=
nd=20
> the dev list.  I'd like to see it implemented at some point, regardless o=
f=20
> the patch used :)  Another thing I know was an issue in the past for me w=
as a=20
> restriction on which hooks the time match was allowed in.  I believe my m=
ost=20
> recent patch (send on 12/3/2003 i think) removed those restrictions and=
=20
> allowed it in all hooks as well as allowing the time range to cross the=
=20
> midnight boundary.  Perhaps that issue has been resolved in the meantime=
=20
> though, I haven't checked the code recently.  I see there have also been =
a=20
> few others who have sent patches to  the mailing list to address this iss=
ue=20
> as well.

Currently, according to the code, ipt_time is allowed in PREROUTING,=20
INPUT, FORWARD and OUTPUT. I believe the restriction can be relaxed in=20
2.6.x version now since it always gets timestamp only if packets does not=
=20
contain one. We can fix 2.4.x version in the same way. Which other hooks=20
are also useful? There is only one left - POSTROUTING. ;)

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1195583745-1136394544=:22709--
