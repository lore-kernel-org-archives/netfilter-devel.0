From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] MASQUERADE not flushing conntracks on ip change
Date: Mon, 08 Nov 2004 17:07:21 +0100
Message-ID: <418F99B9.9080808@trash.net>
References: <20041102210440.GA1851@linuxace.com> <418999B2.3070600@trash.net>
	<Pine.LNX.4.61.0411080215020.8242@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0411080215020.8242@filer.marasystems.com>
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

Henrik Nordstrom wrote:

> If this is what you want create another "Automatic SNAT" target 
> without the flush logics.
>
The old code is broken, that's why I don't want to keep it.
I'm perfectly fine with a working solution.

Regards
Patrick
