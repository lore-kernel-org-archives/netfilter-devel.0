From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Makefile for man pages of xtables extensions + connrate
Date: Thu, 06 Sep 2007 11:56:56 +0200
Message-ID: <46DFCEE8.5060403@trash.net>
References: <46DC0293.6010307@balabit.hu> <46DEB2EC.6080107@trash.net>
	<46DED217.7090101@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: panther@balabit.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46DED217.7090101@balabit.hu>
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

Laszlo Attila Toth wrote:
> I made a new patch for connrate: it was not optional (not tested) and
> wasn't in the Makefile's PF_EXT_SLIB: line. It is not in the kernel
> version 2.6.23-rc3 (linus.git)


I missed connrate when removing the other unsupported extensions,
I removed it now.

> I made the following changes in extensions/Makefile:
> 
>  * no extra target/match by default :)
>  * man page of fix modules (PF_EXT_SLIB etc.) plus optional
>   (...SLIB_OPTS)  modules generated, but not all.
>  * because of the previous one I had to rename PF_EXT_SE_SLIB to
>    PF_EXT_SELINUX_SLIB etc. as a non-optional variable, original
>    PF_EXT_SE_SLIB gets the value of PF_EXT_SELINUX_SLIB if DO_SELINUX is
>    set to 1.


Applied, thanks Attila.
