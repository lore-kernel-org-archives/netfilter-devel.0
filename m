From: Amin Azez <azez@ufomechanic.net>
Subject: Re: Fix --with-kernel for libnfnetlink
Date: Fri, 21 Apr 2006 13:48:41 +0100
Message-ID: <4448D4A9.1080809@ufomechanic.net>
References: <859616420604200825o71f81878lbbb45251f1e0330d@mail.gmail.com>	<4447E23E.4090204@trash.net>	<859616420604210021y53dda87ai64678342068ed43f@mail.gmail.com>
	<20060421110954.GA4403@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <20060421110954.GA4403@localhost.localdomain>
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

Pablo Neira Ayuso wrote:

> Why do you need this parameter? the netfilter libraries don't require
> kernel headers anymore since they are already bundled in the package
> provided. For example, see include/libnfnetlink/linux_nfnetlink.h. We
> have had several problems with iptables and the kernel headers in the
> past: compilation warnings, breakages... That is the reason why we
> decided to do so.
> 
> On the other hand, autogen.sh automates the copy of these headers,
> so you could choose them via KERNEL_DIR but you need some important
> reason to do that.

I needed it because (at the time) I was working on netfilter and 
changing it. I was building multiple kernels with different modifications.

It's possibly only useful for developers (but this is netfilter-devel).

Sam
