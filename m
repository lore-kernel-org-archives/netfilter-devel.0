From: Pablo Neira <pablo@eurodev.net>
Subject: Re: How/where does the kernel map packets to an application ...
Date: Thu, 15 Jan 2004 00:48:04 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4005D534.9050401@eurodev.net>
References: <200401150910.32898.andrej@paradise.net.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: andrej@paradise.net.nz, netfilter-devel@lists.netfilter.org
In-Reply-To: <200401150910.32898.andrej@paradise.net.nz>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Andrei,

Andrej Ricnik wrote:

>Hi Guys,
>
>and sorry for asking this here, I'm aware of the fact that
>this isn't quite the right list to do so, in fact, I don't even
>know how to word my question properly, so please bear
>with me.
>
>Since you're pretty close to what I suspect to be the right
>layer to be looking at I hope someone might understand
>what I'm on about :)
>
>My idea is to write an addition to netfilter that will check 
>the originating application of an IP request against a list
>of allowed files, and if I handle that well enough, integrate
>a roster of user/application to check whether a request is
>legal or not.
>
>My question is:
>At which point does the kernel determine which application
>a incoming packet is meant for?
>

Actually, netfilter can't know for which application is that packet 
coming for, because it works in the network/transport (level 3/4 of OSI 
model) layer, I mean that netfilter can only manages data packets (they 
are contained in a network buffer, see the structure skbuff). What you 
want do is packet filtering from the application layer.

> Imagine one user having
>mozilla and opera open, using both for browsing. Another
>user having a links session in a console. How does the
>kernel determine which application is meant to receive
>a incoming packet on port 80? I hope that once I under-
>stand how this works I could for instance use lsof or a
>tool the like to intercept illegal requests by matching 
>against application name/path ...
>
if it's only web traffic, it will be a good idea performing the 
filtering via proxy.

cheers,
Pablo
