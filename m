From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] conntrack ftp helper modification to use new
	infrastrure
Date: Mon, 10 Jan 2005 00:46:41 +0100
Message-ID: <41E1C261.6050100@trash.net>
References: <41E1AEEF.9050005@eurodev.net> <41E1BC3B.5070101@trash.net>
	<41E1BEBC.3030703@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <41E1BEBC.3030703@eurodev.net>
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

> Patrick McHardy wrote:
>
>> Why is is part of struct ftpsearch ? One struct nf_string_match per 
>> helper
>> should be enough as long as we take the global lock.
>
>
> because the ftp helper looks for four different patterns. The 
> goodshift and badshift arrays required by the boyer-moore algorithm 
> are different for every pattern.

Thanks for the explanation.

>
> Actually, I started a version using lists of nf_string_match to look 
> for a set of patterns iteratively but I finally decided to simplify 
> the thing. If someone finds this feature interesting I could recover 
> it in future.

Since the FTP helper is currently the only possible user of such a feature
I think the current way is fine.

Regards
Patrick
