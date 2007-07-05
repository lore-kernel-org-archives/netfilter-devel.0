From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: ICMP packets associated with NAT connections sent out wrong
 interface?
Date: Thu, 5 Jul 2007 14:33:30 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707051432550.949@bizon.gios.gov.pl>
References: <468C15EE.9060806@quo.to>
	<200707050111.l651Bu9t008798@toshiba.co.jp>
	<468C86C9.7050204@quo.to> <200707051117.l65BHBA6013655@toshiba.co.jp>
	<468CE260.2040500@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1024390118-1183638810=:949"
Cc: jr-list-2007@quo.to, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <468CE260.2040500@trash.net>
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

---187430788-1024390118-1183638810=:949
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 5 Jul 2007, Patrick McHardy wrote:
<CUT>
>>>> workaround fix is disable hardware checksum offload if you use it.
>>>
>>> eth1 is running off a 10-year-old 3Com 3C905 adapter, which doesn't
>>> appear to support hardware checksums. dmesg says:
>>>
>>>  0000:01:0c.0: scatter/gather disabled. h/w checksums disabled
>
>
> I can't find this message in the kernel tree. Which driver are you
> using?

3c59x.c:                printk(KERN_INFO "%s: scatter/gather %sabled. h/w c=
hecksums %sabled\n",

Best reragds,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1024390118-1183638810=:949--
