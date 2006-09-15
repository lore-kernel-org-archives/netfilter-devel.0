From: Michael Rash <mbr@cipherdyne.org>
Subject: Re: patchomatic string patch w/ kernel 2.4.33.3 and netfilter 1.3.5?
Date: Fri, 15 Sep 2006 17:12:10 -0400
Message-ID: <20060915211210.GA11919@minastirith>
References: <200609151039.54079.alan.ezust@presinet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: <200609151039.54079.alan.ezust@presinet.com>
To: netfilter-devel@lists.netfilter.org
Content-disposition: inline
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

On Sep 15, 2006, alan ezust wrote:

> 
> I noticed that the string patch has been removed from patchomatic. I also 
> checked the netfilter source and noticed some relatively recent development 
> on iptables/extensions/libipt_string.c. So I guess my question is, has 
> the "string" patch been integrated into netfilter?
> 
> If I am using kernel 2.4.33.3 and netfilter 1.3.5, is there anything in the 
> string patch that is missing from netfilter now? 
> 
> Is there a file that lists the history/status of the patchlets that were 
> removed from the trunk of patchomatic? I'm curious to know the history of 
> these patchlets in particular: 
> mport goto pptp-conntrack-nat condition regex TCPLAG connrate.

I believe that there was a change in the kernel late in the 2.4 series
that allowed sk_buff structures to span non-contiguous memory, and this
broke the old string match extension in patch-o-matic.

As of 2.6.14, the string match extension is included with the stock
kernel after being re-written by Pablo Neira Ayuso.  So, you have two
options: upgrade to at least 2.6.14, or find an old version of
patch-o-matic laying around somewhere and patch an old 2.4 kernel that
is compatible with it, and I'm guessing that such a kernel would not be
later than 2.4.25 or so.

--
Michael Rash
http://www.cipherdyne.org/
Key fingerprint = 53EA 13EA 472E 3771 894F  AC69 95D8 5D6B A742 839F


 
