From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: [PATCH] Link netfilter before ipv4.
Date: Sun, 13 Nov 2005 14:27:41 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511131420010.20769@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0511120202080.26844@bizon.gios.gov.pl>
	<200511130810.jAD8AhXT003387@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-181760367-1131888461=:20769"
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200511130810.jAD8AhXT003387@toshiba.co.jp>
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

---187430788-181760367-1131888461=:20769
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sun, 13 Nov 2005, Yasuyuki KOZAKAI wrote:
<CUT>
> Good catch! But that patch seems not to able to apply current tree becaus=
e of
> Hunk. Harald, could you apply attached patch instead ?
Just tested with 2.6.15-rc1. No problem with attached version.

> Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Why did you remove my Signed-off-by line?

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-181760367-1131888461=:20769--
