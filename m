From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 0/2] nf_conntrack: fixes for nfsim-found problems
Date: Sun, 06 Nov 2005 02:00:46 +0900 (JST)
Message-ID: <200511051700.jA5H0lo0006359@toshiba.co.jp>
References: <200511051254.20432@nienna>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: hidden@balabit.hu
In-Reply-To: <200511051254.20432@nienna>
	<200511051255.08714@nienna>
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

From: KOVACS Krisztian <hidden@balabit.hu>
Date: Sat, 5 Nov 2005 12:54:20 +0100

>   These patches are fixes for nf_conntrack problems found by nfsim. 
> Please review and apply them if you find them appropriate.

Thanks a lot! These look fine to me except following comment in 2nd patch.

> +	/* free l3proto protocol tables */
> +	for (i = 0; i < PF_MAX; i++)
> +		if (nf_ct_protos[i]) {
> +			kfree(nf_ct_protos[i]);
> +			nf_ct_protos[i] = NULL;
> +		}

nf_ct_protos is the table for layer 4 protocol, not layer 3.

Regards,

-- Yasuyuki Kozakai
