From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Re: How do I use ip_conntrack_destroyed?
Date: Fri, 05 Dec 2003 16:57:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FD09CF7.1090402@netlab.hut.fi>
References: <Pine.LNX.4.44.0312032243000.11739-100000@filer.marasystems.com> <3FCEE93C.5040104@balabit.hu> <3FCF413D.1060405@netlab.hut.fi> <3FCF4E6A.8070202@balabit.hu>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

KOVACS Krisztian wrote:

>   This was the case for an older version of nfnetlink. With 
> nfnetlink-ctnetlink 0.13 you should use
>
> static struct notifier_block my_notifier = {
>     my_notifier_function,
>     NULL,
>     0
> };
>
>   For more info see that patch, it actually _uses_ notifiers to be 
> able to catch conntrack entry related events. Note that this interface 
> is much more universal, for example you can catch events when a 
> conntrack entry is modified, etc. Good luck :)
>

About this patch, I cannot install it. I started over from a clean linux 
2.4.22 kernel and applied the patches. First I used ./runme base and 
applied everything I could. then I used ./runme extra and in the extra 
patches I only tried to apply the nfnetlinc patch (thus I did not 
install the two conflicting patches - ctstat and netfilter-docbook). 
Still, it does not work. Is there any other required/conflicted patch 
that I am not aware of?


             Emmanuel

PS: for information, the output of pom:


Testing... nfnetlink-ctnetlink-0.13.patch NOT APPLIED (4 missing files)
The extra/nfnetlink-ctnetlink-0.13 patch:
   Author: Harald Welte <laforge@gnumonks.org>, Jay Schulist 
<jschlst@samba.org>,
   Patrick McHardy <kaber@trash.net>
   Status: Under development, but stabilizing now.
  
   Add recent work by patrick (notifiers, event messages to userspace.
  
-----------------------------------------------------------------
Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?] y
Patch extra/nfnetlink-ctnetlink-0.13.patch conflicts with 
extra/netfilter-docbook.patch...
netfilter-docbook.patch NOT APPLIED (33 rejects out of 33 hunks)
Patch extra/nfnetlink-ctnetlink-0.13.patch conflicts with 
extra/ctstat.patch...
ctstat.patch NOT APPLIED (15 rejects out of 15 hunks)
Testing patch extra/nfnetlink-ctnetlink-0.13.patch...
   Placed new Config.in line
   Placed new Config.in line
   Placed new Makefile line
   Placed new ip_conntrack.h line
   Placed new ip_conntrack.h line
   Placed new ip_conntrack.h line
   Placed new ip_conntrack.h line
   Placed new ip_conntrack.h line
   Placed new ip_conntrack.h line
   Placed new ip_conntrack.h line
   Placed new ip_conntrack.h line
Failed to patch copy of /usr/src/linux-2.4.22
TEST FAILED: patch NOT applied.
