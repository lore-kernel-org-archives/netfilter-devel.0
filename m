From: Pablo Neira <pablo@netfilter.org>
Subject: Re: [PATCH] libnfnetlink updates
Date: Mon, 17 Oct 2005 00:11:27 +0200
Message-ID: <4352D00F.9080900@netfilter.org>
References: <4352C36E.109@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@netfilter.org>
In-Reply-To: <4352C36E.109@netfilter.org>
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
> @@ -110,10 +115,11 @@
>  extern int nfnl_nfa_addattr32(struct nfattr *, int, int, u_int32_t);
>  extern int nfnl_parse_attr(struct nfattr **, int, struct nfattr *, int);
>  #define nfnl_parse_nested(tb, max, nfa) \
> -	nfnl_parse_attr((tb), (max), NFA_DATA((nfa)), NFA_PAYLOAD((nfa)))
> +({	memset(tb, 0, max *sizeof(struct nfattr *));		\
> +	nfnl_parse_attr((tb), (max), NFA_DATA((nfa)), NFA_PAYLOAD((nfa))); })

Hm, this is bogus. I just realized that the tb array is zeroed from 
nfattr_parse_attr. Ignore this patch. I'll send you another patch 
without this modification tomorrow.

--
Pablo
