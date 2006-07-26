From: Amin Azez <azez@ufomechanic.net>
Subject: quick fix Re: Fix --with-kernel for libnfnetlink
Date: Wed, 26 Jul 2006 15:11:25 +0100
Message-ID: <44C7780D.6000109@ufomechanic.net>
References: <859616420604200825o71f81878lbbb45251f1e0330d@mail.gmail.com>	<4447E23E.4090204@trash.net>	<859616420604210021y53dda87ai64678342068ed43f@mail.gmail.com>	<20060421110954.GA4403@localhost.localdomain>
	<44C776F8.10904@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <44C776F8.10904@ufomechanic.net>
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

I'm an idiot.
Sorry.

(Takes hammer for quick fix. Ouch. Fix complete).

Sam


* Amin Azez wrote, On 26/07/06 15:06:
> Sorry to bring this up again...
> 
> * Pablo Neira Ayuso wrote, On 21/04/06 12:09:
>> Why do you need this parameter? the netfilter libraries don't require
>> kernel headers anymore since they are already bundled in the package
>> provided. For example, see include/libnfnetlink/linux_nfnetlink.h. We
>> have had several problems with iptables and the kernel headers in the
>> past: compilation warnings, breakages... That is the reason why we
>> decided to do so.
>>
>> On the other hand, autogen.sh automates the copy of these headers,
>> so you could choose them via KERNEL_DIR but you need some important
>> reason to do that.
> 
> 
> Current (svn) autogen.sh is hard wired to use the currently booted kernel.
> 
> I'm all for not keeping a copy in the SVN tree, but why presume that the
> one in the booted kernel is the one we want? Isn't this just another
> reason to have --with-kernel back; as we are not copying old userland
> so-called kernel header files?
> 
> Since my 2.6.11 work (which is booted) I'm now working towards 2.6.17,
> and the differences are:
> 
> -#define NFNL_SUBSYS_CTHELPER           5
> -#define NFNL_SUBSYS_COUNT              6
> +#define NFNL_SUBSYS_COUNT              5
> 
>  #ifdef __KERNEL__
> 
> @@ -165,6 +164,7 @@
>         __res;                                                          \
>  })
> 
> +extern int nfnetlink_has_listeners(unsigned int group);
> 
> 
> Which seem important; it is a mistake for autogen.sh to have copied the
> file for the booted kernel.
> 
> I did wonder if libnfnetlink should use text labels instead of symbols,
> and have the dynamic (or at least unpredicatbale) values fetched from
> the kernel and stored as int's instead of constants in libnfnetlink
> 
> It would solve this problem.
> 
> Sam
> 
> 
