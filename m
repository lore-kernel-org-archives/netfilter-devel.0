From: Patrick McHardy <kaber@trash.net>
Subject: Re: userspace tool for ctnetlink
Date: Wed, 22 Oct 2003 05:04:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F95F3AE.9000506@trash.net>
References: <200310221041453.SM00868@zhengcb>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: zhengchuanbo <zhengcb@netpower.com.cn>
In-Reply-To: <200310221041453.SM00868@zhengcb>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

zhengchuanbo wrote:

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
There is a hacked tool for testing at trash.net/~kaber/ctnetlink.
It should be enough as a starting point if you want to use ctnetlink
with you own software. It is not useful as a general purpose tool
however and is incomplete.

Best regards,
Patrick
