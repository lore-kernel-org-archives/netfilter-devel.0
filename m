From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Subject: Re: Kernel oops when putting the console option
	in	/boot/grub/menu.lst
Date: Fri, 11 May 2007 19:15:38 +0200
Message-ID: <4644A4BA.8040606@gmx.net>
References: <D0B3C45E7FCE4C488BEF410B2EF666A17F8D04@moe.nextone.local>	<46434BE2.5090605@trash.net>
	<D0B3C45E7FCE4C488BEF410B2EF666A17F8D4A@moe.nextone.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: Hung Lin <hlin@nextone.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <D0B3C45E7FCE4C488BEF410B2EF666A17F8D4A@moe.nextone.local>
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

On 10.05.2007 19:06, Hung Lin wrote:
> EIP:    0060:[<c012b5bb>]    Tainted: PF    U VLI
> EFLAGS: 00010046   (2.6.11.4-430.8-bigsmp)

Please try to reproduce with current vanilla kernel without loading
proprietary modules and without forcing module load.

Regards,
Carl-Daniel
