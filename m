From: "Samuel Jean" <jix@bugmachine.ca>
Subject: Re: GeoIP match and kernel 2.6.19
Date: Wed, 6 Dec 2006 05:08:40 -0000
Message-ID: <twig.1165381720.24844@bugmachine.ca>
References: <003d01c717c0$a4d60e80$010210ac@BJERKESET.COM>
Reply-To: jix@bugmachine.ca
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Svein Olav Bjerkeset" <netfilter@bjerkeset.com>,
	<netfilter-devel@lists.netfilter.org>
In-Reply-To: <003d01c717c0$a4d60e80$010210ac@BJERKESET.COM>
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

On Mon, Dec 4, 2006, Svein Olav Bjerkeset <netfilter@bjerkeset.com> said:

> Hi,

Hi!

> 
> After upgrading to kernel 2.6.19, I found that GeoIP match was once again 
> broken. Since it seems the GeoIP match patchlet is not activly maintained 
> anymore, I had a look at the source and compiled a patch that made it work 
> on my system.

I uploaded the fixed version a few minutes ago. It should work with both
older and newer 2.6 kernels.

I gave it a try on 2.6.19 and seems to work fine. It also compiles good
on 2.6.15.

I would appreciate if someone could test a 2.6.16, 17 and 18 kernel.
 
> The patches work for me on a Fedora Core 6 x86_64 with a custom built 
> kernel, but I will make no promise that it works on your system - use at 
> your own risk.

Thanks for the help you provided to others while this module was
out-of-sync.
