From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: patch for iptables
Date: Tue, 22 Aug 2006 16:57:56 +0200
Message-ID: <200608221657.57179.max@nucleus.it>
References: <200608221634.13559.max@nucleus.it>
	<44EB1A5E.9050304@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <44EB1A5E.9050304@netfilter.org>
Content-Disposition: inline
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

On Tuesday 22 August 2006 4:53 pm, Pablo Neira Ayuso wrote:

> The official policy is "do not break backward" :). IHMO, if we want to
> go further with iptables we need to think about providing a netlink API.
>
> For out-of-tree stuff the thing can be different, I have seen breakages
> if it really required it. For example, the string match is not
> compatible with the old and broken match for 2.4.

OK. I will send a backward compatible version in a few hours.
With new things as XT, however, many things may move on the kernel side and 
there's no reason for the userspace build system to meddle in the kernel 
includes.
Maybe we sould just do a non-mandatory check in $KERNEL/.config 
(or /proc/config.gz where available) and just keep a coherent set of includes 
with proper structures and associated version numbers?

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
