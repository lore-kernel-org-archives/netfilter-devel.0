From: Roberto Nibali <ratz@drugphish.ch>
Subject: Re: Fixed Re: iptables 1.3.1 crashes on iptables-restore
Date: Fri, 05 Aug 2005 15:22:07 +0200
Message-ID: <42F367FF.7060605@drugphish.ch>
References: <20050330034616.GA8639@samad.com.au>	<424BB242.6070809@drugphish.ch>	<42F24151.1090702@ufomechanic.net>	<42F33AAD.8060201@ufomechanic.net>
	<dcvnn9$vpl$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <dcvnn9$vpl$1@sea.gmane.org>
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

Amin Azez wrote:
> The futex hanging was in glibc during fclose() (!!!)

Strange. So you run a 2.6.x kernel.

> The fix was as simple as:
> 
> LD_ASSUME_KERNEL=2.2.5
> 
> environment variable.

Which would disable TLS.

> I guess my kernel version is too high for my glibc version or something
> like that!

What's the output /lib/libc.so.6? Just out of curiosity. And maybe if 
you set LD_DEBUG=all and run iptables? Also the ldd /sbin/iptables and 
LD_TRACE_LOADED_OBJECTS=1 setting may give you more input.

> This also stops various segfaults too.

Interesting.

Cheers,
Roberto Nibali, ratz
-- 
echo 
'[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
