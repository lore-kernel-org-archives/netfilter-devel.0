From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: [PATCH] set match
Date: Mon, 29 May 2006 00:33:58 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0605290030400.11391@bizon.gios.gov.pl>
References: <1148838123.2516.1.camel@scaramouche.combox.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1798699849-1148855638=:11391"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Torsten Luettgert <t.luettgert@pressestimmen.de>
In-Reply-To: <1148838123.2516.1.camel@scaramouche.combox.de>
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

---187430788-1798699849-1148855638=:11391
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sun, 28 May 2006, Torsten Luettgert wrote:

> Hello,
Hello,

> here's a simple patch for the set match in pom. It adds the
> new protoff parameter in the match function of ipt_set.c and
> changes struct ipt_ip * to void * in the checkentry function
> of ipt_set.c and ipt_SET.c, so they compile without warnings.

http://lists.netfilter.org/pipermail/netfilter-devel/2006-March/023808.html

http://svn.netfilter.org/cgi-bin/viewcvs.cgi?rev=3D6569&view=3Drev

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-1798699849-1148855638=:11391--
