From: Max Kellermann <max@duempel.org>
Subject: Re: [PATCH] SIP/SDP conntrack and NAT helper
Date: Sat, 14 May 2005 10:41:48 +0200
Message-ID: <20050514084148.GA16615@roonstrasse.net>
References: <1115493770.1949.9.camel@www.l-chr.com.ar>
	<20050508205821.GE393@oknodo.bof.de>
	<1115588688.2031.11.camel@www.l-chr.com.ar>
	<20050512080820.GA19043@roonstrasse.net>
	<1115953825.2050.22.camel@www.l-chr.com.ar>
	<20050513054309.GA5962@roonstrasse.net>
	<1116027586.1954.18.camel@www.l-chr.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Christian Hentschel <chentschel@arnet.com.ar>
Content-Disposition: inline
In-Reply-To: <1116027586.1954.18.camel@www.l-chr.com.ar>
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

On 2005/05/14 01:39, Christian Hentschel <chentschel@arnet.com.ar> wrote:
> > What if length_of(dptr) happens to be smaller than hnfo->lnlen?
> > strncmp() will violate dptr's boundary => kernel crashing.
> > 
> 
> Again, you are wrong. 
> Look at the while() 2 lines before and you will see that there's where
> the limit is.
> A strncmp() here is the same as calling memcmp(), may be u got confused
> because of this.

I see. The 'limit' variable guarantees that length_of(dptr) is always
equal or bigger than hnfo->lnlen, although you do not explicitly check
the same for hnfo->snlen. In ct_sip_hdrs, hnfo->lnlen>=nfo->snlen is
always true, so this is not a real problem here.

However, this is dangerous when someone changes ct_sip_hdrs later and
does not notice that ct_sip_get_info() may produce a buffer overflow
in this case (the assumption is not documented there). I'd rather
produce code without this danger and lose some performance (which is
so small you can't even measure it).

But I insist that ct_sip_get_info() is bugged - e.h. a "\r\nl:" at the
end of the packet is never found - that would exceed 'limit', which is
so small because "Content-Length:" is such a big string.

btw. why don't you use memcmp() here? In strncmp(), the known size of
one of the strings as parameter is redundant. You'd better pass
limit-dptr (rest length of dptr) here, and set 'limit' to
dptr+dlen. This would be safe and would parse correctly. In addition,
you could remove hnfo->lnlen and hnfo->snlen (which looks ugly in the
initializers anyway).

Max
