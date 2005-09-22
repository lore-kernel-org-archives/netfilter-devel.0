From: Amin Azez <azez@ufomechanic.net>
Subject: Re: (no subject)
Date: Thu, 22 Sep 2005 11:25:07 +0100
Message-ID: <43328683.5040400@ufomechanic.net>
References: <200207041911.08783.fabrice@celestix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200207041911.08783.fabrice@celestix.com>
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

Fabrice MARIE wrote:
> Hello,
> 
> Attached patch should fix the tftp conntrack patch to
> make it apply properly again.
...
> ------------------------------------------------------------------------
> 
> diff -uNr cvs/netfilter/userspace/patch-o-matic/extra/tftp-conntrack-nat.patch.makefile-3 netfilter/userspace/patch-o-matic/extra/tftp-conntrack-nat.patch.makefile-3
> --- cvs/netfilter/userspace/patch-o-matic/extra/tftp-conntrack-nat.patch.makefile-3	2002-04-15 19:33:13.000000000 +0800
> +++ netfilter/userspace/patch-o-matic/extra/tftp-conntrack-nat.patch.makefile-3	2002-07-04 18:43:00.000000000 +0800
> @@ -1,2 +1,2 @@
> -# NAT helpers
> +# NAT helpers 
>  obj-$(CONFIG_IP_NF_NAT_TFTP) += ip_nat_tftp.o

Does this patch actually do anything?

Sam
