From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] Add mark to packet from libipq
Date: Thu, 16 Oct 2003 09:08:24 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310160902520.6046-100000@filer.marasystems.com>
References: <1066262957.20541.15.camel@porky>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, <nufw-devel@nongnu.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Eric Leblond <eric@regit.org>
In-Reply-To: <1066262957.20541.15.camel@porky>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 16 Oct 2003, Eric Leblond wrote:

> Hi,
> 
> I've done really slight modification to the ip_queue module and to
> lip_ipq to add a fonction that can change the mark of a packet and set a
> verdict to it (its name is ipq_set_vwmark).
> 
> It permits to NuFW to add a mark equal to user id on packet, thus
> enabling to set up a users based QOS, accounting, ... 

I have one question regarding the mark mask value in the kernel message..  
what is the purpose of this? Todays implementation looks rather wasteful
as the userspace may just as well apply the mask before the value is sent
to the kernel.

If you are to have a mask I propose this mask indicates which bits to save 
of the original mark, not a mask to the new mark value. I.e. something 
like this:

            /* set mark of associated skb */
            entry->skb->nfmark = vmsg->nfmark | (entry->skb->nfmark & vmsg->mask);

(alernately mask may be inverted)

but in reality this is not needed either as the userspace knows the
original mask and can a apply whatever transformations it likes 
when giving the new verdict mask.

Regards
Henrik
