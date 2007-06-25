From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_connlimit 20070620_2
Date: Mon, 25 Jun 2007 20:51:44 +0200
Message-ID: <46800EC0.8020307@trash.net>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Andrew Beverley <andy@andybev.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
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
> +/* we will save the tuples of all connections we care about */
> +struct xt_connlimit_conn {
> +	struct list_head list;
> +	struct nf_conntrack_tuple tuple;
>   

I just applied Yasuyuki's ct_extend patches, what you could do
now is to allocate a ct_extend area where you'll put the list_heads
and a pointer to the conntrack, then you can use the destroy
callback to remove it from the list again to keep it clean without
much effort. Should also simplify the rest memory handling a bit.
