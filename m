From: Amin Azez <azez@ufomechanic.net>
Subject: Fixed Re: iptables 1.3.1 crashes on iptables-restore
Date: Fri, 05 Aug 2005 13:57:15 +0100
Message-ID: <dcvnn9$vpl$1@sea.gmane.org>
References: <20050330034616.GA8639@samad.com.au>	<424BB242.6070809@drugphish.ch>	<42F24151.1090702@ufomechanic.net>
	<42F33AAD.8060201@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42F33AAD.8060201@ufomechanic.net>
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

The futex hanging was in glibc during fclose() (!!!)

The fix was as simple as:

LD_ASSUME_KERNEL=2.2.5

environment variable.

I guess my kernel version is too high for my glibc version or something
like that!

This also stops various segfaults too.

Sam
