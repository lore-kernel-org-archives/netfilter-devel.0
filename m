From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] init-conntrack-optimize does not apply to 2.4
Date: Mon, 04 Oct 2004 01:35:19 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41608CB7.7060702@eurodev.net>
References: <20041001220555.GB30842@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20041001220555.GB30842@linuxace.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Phil,

Phil Oester wrote:

>init-conntrack-optimize in pom-ng depends on expect-slab-cache,
>which requires kernel >= 2.6.6.  This breaks --batch mode on 2.4.
>The below patch removes the 2.4 version and adds the proper 'requires'
>entry.
>  
>

I'm fine with it, anyway if someone thinks that this patch can goes into 
2.4 mainline, I will have no problem in posting a patch which applies 
cleanly to current 2.4.

regards,
Pablo
