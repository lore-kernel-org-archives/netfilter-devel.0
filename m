From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_connlimit 20070625
Date: Thu, 28 Jun 2007 21:23:29 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706282121220.22579@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
	<467BAF07.6020502@trash.net>
	<Pine.LNX.4.64.0706251309521.3137@fbirervta.pbzchgretzou.qr>
	<467FA9CE.8000805@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <467FA9CE.8000805@trash.net>
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


On Jun 25 2007 13:41, Patrick McHardy wrote:

>> +	/* check the saved connections */
>> +	list_for_each_entry_safe(conn, tmp, hash, list) {
>> +		found    = nf_conntrack_find_get(&conn->tuple, ct);
>
> Something for the hopefully near future: with ct_extend you could
> allocate a dummy ct extension and use the destructor to remove
> connections, which will avoid this expansive searching.

There's just one problem... judging from example code
(`a=96ef23541211a66adb0504d1451ee318965ac525; git diff $a^..$a` in your
nf-2.6.23.git tree), the struct nf_ct_ext_type->cleanup() handler is only
called with "struct nf_conn *", but that does not help at all. xt_connlimit
needs the "struct xt_connlimit_data", which is only accessible through
xt_match's void *matchinfo (per-match private info).
Ideas?



Thanks,
	Jan
-- 
