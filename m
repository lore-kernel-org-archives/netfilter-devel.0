From: Amin Azez <azez@ufomechanic.net>
Subject: Re: Fix --with-kernel for libnfnetlink
Date: Fri, 21 Apr 2006 14:56:14 +0100
Message-ID: <4448E47E.7060801@ufomechanic.net>
References: <859616420604200825o71f81878lbbb45251f1e0330d@mail.gmail.com>	<4447E23E.4090204@trash.net>	<859616420604210021y53dda87ai64678342068ed43f@mail.gmail.com>	<20060421110954.GA4403@localhost.localdomain>	<4448D4A9.1080809@ufomechanic.net>
	<20060421131210.GA10173@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>, David Vogt <beunlovable@gmail.com>
In-Reply-To: <20060421131210.GA10173@localhost.localdomain>
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

Pablo Neira Ayuso wrote:
> On Fri, Apr 21, 2006 at 01:48:41PM +0100, Amin Azez wrote:
> 
>>Pablo Neira Ayuso wrote:
>>
>>
>>>Why do you need this parameter? the netfilter libraries don't require
>>>kernel headers anymore since they are already bundled in the package
>>>provided. For example, see include/libnfnetlink/linux_nfnetlink.h. We
>>>have had several problems with iptables and the kernel headers in the
>>>past: compilation warnings, breakages... That is the reason why we
>>>decided to do so.
>>>
>>>On the other hand, autogen.sh automates the copy of these headers,
>>>so you could choose them via KERNEL_DIR but you need some important
>>>reason to do that.
>>
>>I needed it because (at the time) I was working on netfilter and 
>>changing it. I was building multiple kernels with different modifications.
>>
>>It's possibly only useful for developers (but this is netfilter-devel).
> 
> 
> Still, why such thing would be useful?
> 
> I just noticed that this thread started from "Problem with compiling 
> libnfnetlink". Could you check that you have /usr/include/asm/types.h
> installed? it seems that your system doesn't find the definition of
> __u32.
> 
> It's true that this is defined in a kernel header but such file is usually
> provided by the linux-kernel-header package, that is the case of debian.
> I think that is a reasonable requirement to compile libnfnetlink.
> 


It's David Vogt who had the problem.
I supplied the --with-kernel autoconf code I wrote for the conntrack 
stuff when I autoconf-ified it for you.

I needed the code because I was modifiying conntrack and nfnetlink at 
the and changing some of the structs.

David, can you do the checks Pablo asks for?

While I recognize compilation warnings and breakages, I think that 
pretending that a linux-kernel-header package will always be up to date 
is just deferring the problem to some other time and place.

anyway... I'm fine as I can add this code when I need it and just ship 
my own source, but feel free to take up David's problem to see if 
another solution is preferred.

Sam
