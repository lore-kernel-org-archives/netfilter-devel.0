From: Matt Ayres <matta@tektonic.net>
Subject: Re: Panic in ipt_do_table with 2.6.16.13-xen
Date: Mon, 15 May 2006 20:01:45 -0400
Message-ID: <44691669.4080903@tektonic.net>
References: <4468BE70.7030802@tektonic.net> <4468D613.20309@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <xen-devel-bounces@lists.xensource.com>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4468D613.20309@trash.net>
List-Unsubscribe: <http://lists.xensource.com/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> Matt Ayres wrote:
>> I have been noticing this same problem dozens of times and have finally
>> caught a full trace.  I have run it through ksymoops, but there is no
>> /proc/ksyms.  Is there a better method for getting information out of
>> the Code line than using ksymoops in 2.6 kernels?
> 
> 
> CONFIG_KALLSYMS will make the kernel decode the oops itself.
> 

That's odd, I had thought that too.  This is what "zcat /proc/config.gz 
| grep KALL" shows:

CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
# CONFIG_KALLSYMS_EXTRA_PASS is not set

I take it my run through ksymoops was of no help in diagnosing the 
problem?  The panic is _always_ in ipt_do_table.

>> The kernel is for Xen, but it does not appear to be related to Xen.
> 
> 
> We haven't had problems in that code for ages, so my initial feeling
> is that it probably is related to Xen. Do you have any other patches
> applied besides Xen? Please also post the full ruleset you're using
> and anything else that might appear special about your setup.
> 

I had initially sent my traces to the Xen guys.  They have not stated it 
is NOT specific to Xen, just that's it's unlikely.  I did not experience 
the problem with kernel 2.6.12, just with 2.6.16 (up to .13 bugfix 
release).  I have completely disabled all support for SCTP 
(protocol/netfilter/conntrack) as I know it is still quite buggy.  I 
know Xen touches the network code a lot, but nothing specific to 
iptables.  I had contacted them twice before LKML as I didn't want to 
post patch specific problems here.  I have no other patches applied 
besides the Xen patch.

My ruleset is pretty bland.  2 rules in the raw table to tell the system 
to only track my forwarded ports, 2 rules in the nat table for 
forwarding (intercepting) 2 ports, and then in the FORWARD tables 2 
rules per VM to just account traffic.

I've CC'ed xen-devel on this in case they can provide some insight.  I 
am not subscribed to LKML so please make sure to reply to me also in 
responses.

Thank you,
Matt Ayres
