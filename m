From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] clean up for ftp conntrack helper
Date: Thu, 15 Apr 2004 16:23:11 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <407E9ACF.3020207@trash.net>
References: <407DB66B.9090300@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
 Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <407DB66B.9090300@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira wrote:
> Some considerations, my patch of the new expectation API must be applied 
> before applying this patch. btw, this patch could have some problems with:
> 

I've added your patch to pom-ng, with another minor change (C99
initializers for ftp_search array). BTW, it also applies/works well
without the expect API patch. Thanks Pablo.

Regards,
Patrick
