From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: current pom-ng's nfnetlink doesn't apply cleanly to kernel 2.4.22
Date: Sun, 18 Apr 2004 11:07:00 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404181102460.4242-100000@filer.marasystems.com>
References: <20040418050458.84139.qmail@web41709.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Develop <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: zhi wang <pangy2004@yahoo.com>
In-Reply-To: <20040418050458.84139.qmail@web41709.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 17 Apr 2004, zhi wang wrote:

> None of the other patch is applied, only nfnetlink-ctnetlink. From the
> nfnetlink's patch, it is supposed that this patch should apply cleanly
> to a official linux-2.4.22 kernel, but it isn't. I also tried 2.4.20,
> 2.4.24, 2.4.25, and current 2.4.26 kernels. Any hint? [...]

I am using this patch with no big trouble.. had to adjust it a little due 
to conflicts with other patches applied but just some trivial things..

Maybe the patch does indeed depend on some other patch not listed in the
dependencies. Where does it fail?  My kernel uses quite many patches..

Regards
Henrik
