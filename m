From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [BROKEN] ipt_ wrappers for xt_ functions (WAS: Problems
 Compiling Geoip on linux-2.6.21-rc3)
Date: Thu, 15 Mar 2007 17:03:29 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0703151700320.1199@yvahk01.tjqt.qr>
References: <200703080637.WAA05730@NickAndBarb.net>
	<twig.1173969394.3980@bugmachine.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	kaber@trash.net, Nick Pasich <NewsLetters@NickAndBarb.net>
To: Samuel Jean <jix@bugmachine.ca>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <twig.1173969394.3980@bugmachine.ca>
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


On Mar 15 2007 14:36, Samuel Jean wrote:
>
>How do we workaround the missing wrappers ? Another #if KERNEL_VERSION
>declarations ?
>
>> Kernel: arch/i386/boot/bzImage is ready  (#1)
>>   Building modules, stage 2.
>>   MODPOST 256 modules
>> WARNING: "ipt_unregister_match" [net/ipv4/netfilter/ipt_geoip.ko] undefined!
>> WARNING: "ipt_register_match" [net/ipv4/netfilter/ipt_geoip.ko] undefined!
>> make[1]: *** [__modpost] Error 1
>> make: *** [modules] Error 2

#if DONT_HAVE_IPT /* nicely recent */
#    the wrappers as present before the commit
#endif
#if DONT_HAVE_XT /* really old kernel */
#    define xt_match ipt_match
#    define xt_register(x) do { (x)->family = AF_INET; ipt_register(x); }
#endif

Something like that. Oh yeah what a wonderful world
if pomngs were integrated! :>



Jan
-- 
