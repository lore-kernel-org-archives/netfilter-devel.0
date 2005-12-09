From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: (D)NAT with IPv6 (was "nf_conntrack & NAT")
Date: Fri, 9 Dec 2005 09:56:06 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0512090950520.26169@bizon.gios.gov.pl>
References: <200511231225.jANCPmYd015427@toshiba.co.jp>
	<20051123132044.GZ3249@eychenne.org>
	<20051123132419.GJ24091@fi.muni.cz>
	<20051206154320.GG4038@rama.exocore.com>
	<20051206173135.GQ5617@eychenne.org>
	<Pine.LNX.4.58.0512071201460.17863@blackhole.kfki.hu>
	<20051207145438.GA5617@eychenne.org>
	<Pine.LNX.4.58.0512071603190.17863@blackhole.kfki.hu>
	<20051208114120.GF5617@eychenne.org>
	<20051208115632.GB13067@oknodo.bof.de>
	<20051209045631.GC4244@rama.exocore.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-255680564-1134118566=:26169"
Cc: Herve Eychenne <rv@wallfire.org>, netfilter-devel@lists.netfilter.org,
	Patrick Schaaf <bof@bof.de>, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051209045631.GC4244@rama.exocore.com>
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

---187430788-255680564-1134118566=:26169
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 9 Dec 2005, Harald Welte wrote:

> On Thu, Dec 08, 2005 at 12:56:32PM +0100, Patrick Schaaf wrote:
>>> So each time you add a service on a host, you should assign a new IP to=
 it
>>> (and create the respective DNS name for this IP/service couple!), just =
in
>>> case you may have to redirect its traffic one day? (even if temporary)
>>
>> This has proven to be a very valuable strategy, at work, even for normal
>> IPv4 operation. Saves headaches every time we want to migrate something.
>> I can warmly recommend this practise.
>
> I totally agree.  Esp. with IPv6 there is no reason to do otherwise...
> A /64 for every physical network segment, guess people still need to get
> used to it.

But if you need to move IP betwen machines then you need one ip for each=20
service, probably with /32 mask for IPv4 and /64 for IPv6. There is no=20
problem when using private addresses and IPv4, should be no problem for=20
IPv6 but there is no way to do it that way with public IPv4 addressess.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-255680564-1134118566=:26169--
