From: "zhengchuanbo" <zhengcb@netpower.com.cn>
Subject: userspace tool for ctnetlink
Date: Wed, 22 Oct 2003 11:25:47 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200310221116812.SM00868@zhengcb>
Mime-Version: 1.0
Content-Type: text/plain;
      charset="GB2312"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: kaber@trash.net <kaber@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick,
	
sorry to disturb you. I got your code ct.tar.gz. There are some
problem when compile. 
first,it reported that the libnfnetlink.h is missed. So I copied
this file from iptables2.
Then it reported some error like this,
	utils.c:225: `IPS_CONFIRMED' undeclared (first use in this function)
	utils.c:225: (Each undeclared identifier is reported only once
	utils.c:225: for each function it appears in.) 
So I don't know if I got the right version.

Best regards,
Jack
zhengcb@netpower.com.cn
	
>	
>I'm trying to add new conntrack to the kernel from userspace. 
>The nfnetlink-conntrack patch should be helpful to this. But
>what is the userspace tool to do that? Is it iptables2?  I
>can't get a version which works. 
>
>regards,
>Jack
>
>E-mail: zhengcb@netpower.com.cn 
>
>  
>
>There is a hacked tool for testing at trash.net/~kaber/ctnetlink.
>It should be enough as a starting point if you want to use ctnetlink
>with you own software. It is not useful as a general purpose tool
>however and is incomplete.

>Best regards,
>Patrick
