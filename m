From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: nf_conntrack & NAT
Date: Wed, 23 Nov 2005 14:44:01 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511231342490.16555@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0511231214590.11295@bizon.gios.gov.pl>
	<200511231225.jANCPmnh018866@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-227000739-1132753441=:16555"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200511231225.jANCPmnh018866@toshiba.co.jp>
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

---187430788-227000739-1132753441=:16555
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 23 Nov 2005, Yasuyuki KOZAKAI wrote:

>
> Hi,
>
> From: Krzysztof Oledzki <olenf@ans.pl>
> Date: Wed, 23 Nov 2005 12:30:07 +0100 (CET)
>
>> Hello,
>>
>> As we have now working nfnetlink in nf_conntrack (thanks!) I'm wonder if
>> there any plans for porting IPv4 NAT to nf_conntrack
>
> Of cause we have. But

Where can I find it?

>>                                                      and adding NAT
>> support for IPv6?
>
> Never ever. You can learn why people don't want to do it from many source=
s.
> For example, You can use many addresses in IPv6 world. And I don't want p=
eople
> get troubles due to NAT traversal issues in IPv6 world.

Oh. So how we are going to make transparent proxy, port redirects, etc=20
possible?

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-227000739-1132753441=:16555--
