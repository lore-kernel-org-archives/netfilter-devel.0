From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.4/2.6]: TTL target
Date: Mon, 26 Jul 2004 23:10:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4105735B.7090304@trash.net>
References: <1400.192.168.1.16.1090797821.squirrel@192.168.1.16>    <41044BAC.7060705@trash.net> <1526.192.168.1.16.1090805868.squirrel@192.168.1.16>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nicolas Bouliane <nib@cookinglinux.org>
In-Reply-To: <1526.192.168.1.16.1090805868.squirrel@192.168.1.16>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Nicolas Bouliane wrote:
> New patch below.

Thanks. There are still some spaces used for indentation, but I'll
fix it up by hand.

Regards
Patrick


> 
> 
> +      exit_error(PARAMETER_PROBLEM,
> +            "TTL: Expected value between 0 and 255");
> 
>  	switch (c) {
> 
> --
> Nicolas Bouliane,
> Samuel Jean
> at cookinglinux.org
> 
