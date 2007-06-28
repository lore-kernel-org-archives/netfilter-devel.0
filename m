From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_connlimit 20070625
Date: Thu, 28 Jun 2007 21:27:27 +0200
Message-ID: <46840B9F.7080803@trash.net>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
	<467BAF07.6020502@trash.net>
	<Pine.LNX.4.64.0706251309521.3137@fbirervta.pbzchgretzou.qr>
	<467FA9CE.8000805@trash.net>
	<Pine.LNX.4.64.0706282121220.22579@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706282121220.22579@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
> On Jun 25 2007 13:41, Patrick McHardy wrote:
> 
> 
>>>+	/* check the saved connections */
>>>+	list_for_each_entry_safe(conn, tmp, hash, list) {
>>>+		found    = nf_conntrack_find_get(&conn->tuple, ct);
>>
>>Something for the hopefully near future: with ct_extend you could
>>allocate a dummy ct extension and use the destructor to remove
>>connections, which will avoid this expansive searching.
> 
> 
> There's just one problem... judging from example code
> (`a=96ef23541211a66adb0504d1451ee318965ac525; git diff $a^..$a` in your
> nf-2.6.23.git tree), the struct nf_ct_ext_type->cleanup() handler is only
> called with "struct nf_conn *", but that does not help at all. xt_connlimit
> needs the "struct xt_connlimit_data", which is only accessible through
> xt_match's void *matchinfo (per-match private info).
> Ideas?


I though you would store the struct xt_connlimit_conn in the
ct_extend area. The only reason I can think of why you'd need
the xt_connlimit_data is for the lock. So you could make the
lock global (which I think is fine) or add a pointer to the
data you need.
