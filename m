From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: kernel panic with connlimit and 2.6.16.* kernels
Date: Tue, 25 Apr 2006 20:25:51 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0604252024200.26607@bizon.gios.gov.pl>
References: <20060425105258.9430.qmail@webhost66.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1651287647-1145989551=:26607"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?windows-1251?Q?noip?= <noip@webhost66.com>
In-Reply-To: <20060425105258.9430.qmail@webhost66.com>
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

---187430788-1651287647-1145989551=:26607
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 25 Apr 2006, noip wrote:

> Hello,
>
> I've described my problem in the linux kernel list here:
> http://www.ussg.iu.edu/hypermail/linux/kernel/0604.2/1472.html
>
> There I've recieved a reply from Patrick McHardy:
> http://www.ussg.iu.edu/hypermail/linux/kernel/0604.2/1666.html
>
> I've used a patch for connlimit from this thread, because without the pat=
ch i can't apply the connlimit patch from the latest patch-o-matic-ng snaps=
hot to any 2.6.16 kernel:
> http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3D3456

What about this one: ftp://ftp.ans.pl/pub/patches/nf/connlimit.patch.gz

I have two positive replays saying that it works.

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-1651287647-1145989551=:26607--
