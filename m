From: Brad Fisher <brad@info-link.net>
Subject: Re: Patch for ipt_time (to enable start > stop / crossing midnight)
Date: Wed, 04 Jan 2006 11:18:41 -0600
Message-ID: <43BC0371.3050500@info-link.net>
References: <20060104142750.GF15217@schlittermann.de>
	<Pine.LNX.4.64.0601041639400.19966@bizon.gios.gov.pl>
	<43BBF971.50307@info-link.net>
	<Pine.LNX.4.64.0601041758580.22709@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org,
	Heiko Schlittermann <hs@schlittermann.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0601041758580.22709@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:

>
>
> On Wed, 4 Jan 2006, Brad Fisher wrote:
>
>> I've also sent a couple of patches to add this functionality to=20
>> Fabrice and the dev list.  I'd like to see it implemented at some=20
>> point, regardless of the patch used :)  Another thing I know was an=20
>> issue in the past for me was a restriction on which hooks the time=20
>> match was allowed in.  I believe my most recent patch (send on=20
>> 12/3/2003 i think) removed those restrictions and allowed it in all=20
>> hooks as well as allowing the time range to cross the midnight=20
>> boundary.  Perhaps that issue has been resolved in the meantime=20
>> though, I haven't checked the code recently.  I see there have also=20
>> been a few others who have sent patches to  the mailing list to=20
>> address this issue as well.
>
>
> Currently, according to the code, ipt_time is allowed in PREROUTING,=20
> INPUT, FORWARD and OUTPUT. I believe the restriction can be relaxed in=20
> 2.6.x version now since it always gets timestamp only if packets does=20
> not contain one. We can fix 2.4.x version in the same way. Which other=20
> hooks are also useful? There is only one left - POSTROUTING. ;)
>
> Best regards,
>
>                 Krzysztof Ol=EAdzki

I recall having problems in the mangle table, so it was probably with=20
the POSTROUTING chain.  My rules depended on the dst IP after NAT was=20
performed.
-Brad
