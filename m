From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Discrete packaging of experimental modules
Date: Sat, 18 Sep 2004 18:45:41 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409181842420.17139@filer.marasystems.com>
References: <0D0567C424F9F491BBAACF88@[10.169.6.246]>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Kenneth Porter <shiva@sewingwitch.com>
In-Reply-To: <0D0567C424F9F491BBAACF88@[10.169.6.246]>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 17 Sep 2004, Kenneth Porter wrote:

> I was considering using the TARPIT module on my Fedora system but it seems 
> that to do that I'll need to compile a custom kernel. Seems like part of the 
> point of loadable drivers is to avoid this very thing. So is it feasible to 
> build and package single netfilter modules the way one does drivers? If so, 
> is it also feasible to build and package the userspace part as a dynamic 
> library to be pulled into iptables and friends on demand? Or is this all on 
> the future roadmap?

Extensions which is self-contained (header + c file, no patching of other 
files) can be compiled outside of the kernel just as any other kernel 
module, but there is no infrastructure in the netfilter project for doing 
this kind of out-of-kernel module builds and how to do this is left as an 
excersise to the reader.

Please note that you also need to build the userspace extension object.

Regards
Henrik
