From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 2.6] cleanup conntrack helper API
Date: Mon, 29 Mar 2004 16:13:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40682F02.6000901@eurodev.net>
References: <20040329104011.GE1528@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
 netfilter-devel@lists.netfilter.org
In-Reply-To: <20040329104011.GE1528@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald,

Harald Welte wrote:

>Hi Dave!
>
>This is the first in a set of 2.6.x optimization patches.  Obviosly,
>they are meant for 2.6.6, not 2.6.5.  Please apply to your tree, thanks.
>  
>
If this patch goes to stable kernel 2.6 branch, it implies that all 
helpers available in pom-ng which use the old call won't compile, so 
they won't work :-).

So, do you want me to prepare a patch for all those helpers?

regards,
Pablo
