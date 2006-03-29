From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: ip_ct_tcp_timeout_established timeout problem
Date: Wed, 29 Mar 2006 15:00:38 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0603291455370.23839@bizon.gios.gov.pl>
References: <442A46DD.2B1385.31446>
	<000701c65313$5c03ba30$d51c010a@zhuxiaoping>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-846312187-1143637238=:23839"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: zhu xiaoping <zhuxp@leadsec.com.cn>
In-Reply-To: <000701c65313$5c03ba30$d51c010a@zhuxiaoping>
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

---187430788-846312187-1143637238=:23839
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 29 Mar 2006, zhu xiaoping wrote:

> the ip_ct_tcp_timeout_established is 5 DAYS, if someone setup a=20
> connection but do not send any data,this connection will stay on=20
> firewall box five days, and if lot of such connection stay on firewall=20
> box, then no new connection will be established. Is this a problem? and=
=20
> there's no place to change this parameter,so if it's happened, we have=20
> on chance to solve this problem

Plase use:

sysctl net.ipv4.netfilter.ip_conntrack_tcp_timeout_established=3Dtimeout

where "timeout" is any value in seconds representing required timeout (for=
=20
example 172800 for 2 days)

Best regards,

 =09=09=09Krzysztof Ol=EAdzki

PS: This is not a netfilter-devel question, definitely ;).
---187430788-846312187-1143637238=:23839--
