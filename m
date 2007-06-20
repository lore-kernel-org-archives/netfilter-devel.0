From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_connlimit kernel 20070620
Date: Wed, 20 Jun 2007 14:56:26 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706201449590.5731@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0706200039290.5731@fbirervta.pbzchgretzou.qr>
	<4678F7A2.6090203@netfilter.org>
	<Pine.LNX.4.64.0706201224490.5731@fbirervta.pbzchgretzou.qr>
	<46790A58.9050106@netfilter.org>
	<Pine.LNX.4.64.0706201328260.5731@fbirervta.pbzchgretzou.qr>
	<46791704.4090609@netfilter.org> <467921FD.8000909@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <467921FD.8000909@trash.net>
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


On Jun 20 2007 14:47, Patrick McHardy wrote:
>Pablo Neira Ayuso wrote:
>> Jan Engelhardt wrote:
>> 
>>> UDP does not have a transition from ESTABLISHED -> TIME_WAIT, to begin
>>> with.
>> 
>> But the event API has the DESTROY transition. There are three kind of
>> events: NEW, UPDATE and DESTROY. Just wait for DESTROY events to release
>> the entry from the hashtable.
>
>Thats not a bad idea, but I always considered the notifier chains
>overkill just for ctnetlink and thought about replacing them by
>simple hooks. Adding another user for them would need some good
>justification, also since it quite heavily adds to the overhead
>for packet processing.

In that case, let's move that issue to later and go with the
current approach :)

One thing catched my eye:

if (found != NULL &&
   (found_ct = nf_ct_tuplehash_to_ctrack(found)) != NULL &&
   memcmp(&conn->tuple, &tuple, sizeof(tuple)) == 0 &&
   found_ct->proto.tcp.state != TCP_CONNTRACK_TIME_WAIT)

I think we need to assure that the connection is actually TCP before 
comparing ->proto.tcp.state. A check is needed, but which?

conn->tuple.dst.proto == IPPROTO_TCP or
found->tuple.dst.proto == IPPROTO_TCP,
or something completely different?


	Jan
-- 
