From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: Bug in ipset -R
Date: Mon, 29 Aug 2005 00:50:20 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0508290045010.28187@bizon.gios.gov.pl>
References: <Pine.LNX.4.62.0508190246520.6407@bizon.gios.gov.pl>
	<Pine.LNX.4.58.0508220940360.20621@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-885816717-1125269420=:28187"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0508220940360.20621@blackhole.kfki.hu>
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

---187430788-885816717-1125269420=:28187
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 22 Aug 2005, Jozsef Kadlecsik wrote:
<CUT>
> because the restore commands must follow each other in a rigid order (the
> feature)
Why? With "ipset -N ..."&"ipset -A ..." it is possible to use any=20
order, I thought I can simply convert my scripts and use ipset -R feature.=
=20
:(

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-885816717-1125269420=:28187--
