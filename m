From: Eicke Friedrich <tady@gmx.net>
Subject: Re: kernel crash
Date: Fri, 30 May 2003 12:18:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3ED73004.1070707@gmx.net>
References: <3ED67067.6080605@eburg.com> <1054247760.709.94.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1054247760.709.94.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all,

Martin Josefsson wrote:
> Beware that conntrack in kernel 2.4.20 has a serious bug caused by core
> kernel changes. Can you please try 2.4.21-rc or apply at least
> submitted/10_confirm_fix.patch from patch-o-matic and run the same thing
> again and see if it still happens?
As I'm using kernel 2.4.20 and conntrack as well, I'm very interessted 
in this problem. I've just patched the kernel with 10_confirm_fix but 
have no chance to test it under load.
Testing my software in a real-scenario on tuesday, I would be glad to 
hear if this patch fixes the problem or if I'm forced to update the 
kernel.

Best regards,
Eicke.
