From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack [was Re: [PATCH 1/4] RFC: fast string matching
 infrastrure for netfilter]
Date: Fri, 14 Jan 2005 04:16:19 +0100
Message-ID: <41E73983.7060905@trash.net>
References: <41E1AECD.6020209@eurodev.net> <41E1B9F1.7010106@trash.net>
	<Pine.LNX.4.58.0501102041430.28819@blackhole.kfki.hu>
	<41E2E631.3060102@trash.net>
	<20050110212807.GZ18568@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050807020403010802050200"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050110212807.GZ18568@sunbeam.de.gnumonks.org>
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

This is a multi-part message in MIME format.
--------------050807020403010802050200
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Harald Welte wrote:

>>I think we should put ip_conntrack in maintenance mode, than we can
>>resync nf_conntrack and make changes like this before we submit it.
>>
>
>At last, we again agree :)
>

I've commited a TODO list for nf_conntrack (just off the top of my head)
to svn. Any further suggestions are appreciated.

Regards
Patrick


--------------050807020403010802050200
Content-Type: text/plain;
 name="TODO"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="TODO"

TODOs for nf_conntrack (last changed Jan 14 2005)
-------------------------------------------------

Some items are controversial, so make sure to get some feedback on
netfilter-develbefore working on any of these.

- Resync with latest ip_conntrack changes
- Function/structure name unification: s/nf_conntrack/nf_ct/
- Replace get_features stuff by ct_extend ?
- Don't waste space for IPv4 tuples (currently union with IPv6 tuples) ?
- kill ->confirm, nf_conntrack_confirm is generic
- Add nf_ct_get_afinfo for things like ip_ct_attach
- Some IPv4/IPv6 registered hook functions just call generic functions, this
  means even longer call-chains. Add family argument to hook functions and
  kill them ?
- IPv4 NAT


--------------050807020403010802050200--
