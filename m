From: Patrick McHardy <kaber@trash.net>
Subject: Re: userspace tool for ctnetlink
Date: Wed, 22 Oct 2003 05:39:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F95FBFF.90703@trash.net>
References: <200310221116812.SM00868@zhengcb>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: zhengchuanbo <zhengcb@netpower.com.cn>
In-Reply-To: <200310221116812.SM00868@zhengcb>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I'm sorry I deleted my old compile environment just today.
IPS_CONFIRMED should be defined in the kernel header files
so you probably need to adjust the location of these in the
Makefile. IIRC you also need this patch:
http://trash.net/~kaber/ctnetlink/libnfnetlink-nfnl_talk.diff

Best regards,
Patrick

zhengchuanbo wrote:

>Patrick,
>	
>sorry to disturb you. I got your code ct.tar.gz. There are some
>problem when compile. 
>first,it reported that the libnfnetlink.h is missed. So I copied
>this file from iptables2.
>Then it reported some error like this,
>	utils.c:225: `IPS_CONFIRMED' undeclared (first use in this function)
>	utils.c:225: (Each undeclared identifier is reported only once
>	utils.c:225: for each function it appears in.) 
>So I don't know if I got the right version.
>
>Best regards,
>Jack
>zhengcb@netpower.com.cn
>
>  
>
