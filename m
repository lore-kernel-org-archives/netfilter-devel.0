From: Pablo Neira <pablo@eurodev.net>
Subject: Re: kernel BUG at kernel/sched.c:2833!
Date: Fri, 18 Nov 2005 04:25:06 +0100
Message-ID: <437D4992.3040501@eurodev.net>
References: <Pine.LNX.4.64.0511141033001.8729@bizon.gios.gov.pl>	<437882BE.6080705@eurodev.net>	<Pine.LNX.4.64.0511162216140.16387@bizon.gios.gov.pl>	<437BD093.3010905@eurodev.net>	<20051117151135.GJ14201@sunbeam.de.gnumonks.org>
	<437D4825.1060801@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <437D4825.1060801@eurodev.net>
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

Pablo Neira wrote:
> @@ -527,10 +531,10 @@ ctnetlink_parse_tuple_proto(struct nfatt
>  
>  	proto = ip_conntrack_proto_find_get(tuple->dst.protonum);
>  
> -	if (likely(proto && proto->nfattr_to_tuple)) {
> +	if (likely(proto && proto->nfattr_to_tuple))
>  		ret = proto->nfattr_to_tuple(tb, tuple);

Still not good. Forgot to remove that proto != NULL checking. It's too
late. I'll resend a patch tomorrow in the morning.

-- 
Pablo
