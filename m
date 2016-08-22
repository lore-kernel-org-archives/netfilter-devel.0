From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: gre: Use the consitent GRE and PPTP
 struct instead of the structures defined in netfilter
Date: Mon, 22 Aug 2016 11:22:09 +0200
Message-ID: <20160822092209.GA2810@salvia>
References: <1471618894-10582-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
        philipp@redfish-solutions.com, netdev@vger.kernel.org,
        gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1471618894-10582-1-git-send-email-fgao@ikuai8.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Aug 19, 2016 at 11:01:34PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> There are two structures which define the GRE header and PPTP
> header. So it is unneccessary to define duplicated structures in
> netfilter again.

Please, split this change in smaller patches, I'd suggest one to
replace GRE_* definitions and another to use generic GRE struct
definitions, so this makes it is easier to review.

> @@ -212,8 +212,8 @@ static bool gre_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
>  	if (!pgrehdr)
>  		return true;
>  
> -	if (ntohs(grehdr->protocol) != GRE_PROTOCOL_PPTP) {
> -		pr_debug("GRE_VERSION_PPTP but unknown proto\n");
> +	if (grehdr->protocol != GRE_PROTO_PPP) {
> +		pr_debug("Unknown GRE proto(0x%x)\n", ntohs(grehdr->protocol));

Something is fishy here, grehdr->protocol used to have ntohs(), the
pr_debug() still has it while the branch check does not.
