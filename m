From: Kiran Kumar Immidi <immidi@spymac.com>
Subject: Re: [PATCH]: Fix invalid return values from sctp_new
Date: Mon, 20 Sep 2004 14:09:16 +0530
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200409201408.35538.immidi@spymac.com>
References: <414E9493.3020800@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <414E9493.3020800@trash.net>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Monday 20 September 2004 13:58, Patrick McHardy wrote:

> there are multiple places in sctp_new where it returns -1, but
> it looks like it really wants to return "invalid". The call to
> protocol->new in init_conntrack looks like this:
>
>         if (!protocol->new(conntrack, skb)) {
>                 kmem_cache_free(ip_conntrack_cachep, conntrack);
>                 return NULL;
>         }
>
> so it has to return 0 to say "invalid". Please check if the
> attached patch which fixes these places is correct.

  This seems fair. But the place I copied this from 
[ ip_conntrack_proto_tcp.c:tcp_new() ]  also needs to be fixed I guess..

@@ -237,7 +237,7 @@
        struct tcphdr tcph;

        if (skb_copy_bits(skb, skb->nh.iph->ihl * 4, &tcph, sizeof(tcph)) != 
0)
-               return -1;
+               return 0;


-- 
Regards,
Kiran Kumar Immidi
