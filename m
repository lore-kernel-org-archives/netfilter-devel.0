From: Patrick McHardy <kaber@trash.net>
Subject: Re: Panic in ipt_do_table with 2.6.16.13-xen
Date: Mon, 15 May 2006 21:27:15 +0200
Message-ID: <4468D613.20309@trash.net>
References: <4468BE70.7030802@tektonic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Matt Ayres <matta@tektonic.net>
In-Reply-To: <4468BE70.7030802@tektonic.net>
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

Matt Ayres wrote:
> I have been noticing this same problem dozens of times and have finally
> caught a full trace.  I have run it through ksymoops, but there is no
> /proc/ksyms.  Is there a better method for getting information out of
> the Code line than using ksymoops in 2.6 kernels?


CONFIG_KALLSYMS will make the kernel decode the oops itself.

> The kernel is for Xen, but it does not appear to be related to Xen.


We haven't had problems in that code for ages, so my initial feeling
is that it probably is related to Xen. Do you have any other patches
applied besides Xen? Please also post the full ruleset you're using
and anything else that might appear special about your setup.
