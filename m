From: Patrick McHardy <kaber@trash.net>
Subject: Re: NFNL_NFA_NEST
Date: Thu, 22 Mar 2007 12:00:59 +0100
Message-ID: <460261EB.4000402@trash.net>
References: <4600BDBB.8020205@trash.net> <4601B796.5030100@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4601B796.5030100@netfilter.org>
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
> Patrick McHardy wrote:
> 
>>One of the worst mistakes in nfnetlink in my opinion was the
>>introduction of the NFNL_NFA_NEST bit. It prevents us from
>>using a large part of the generic netlink stuff, since that
>>just interprets it as a really huge attribute type. Since
>>its not used even for anything, this is really annoying.
> 
> 
> I'm using this bit to convert attribute headers from host byte order to
> network byte order in conntrackd. I'm unsure about how I would do the
> conversion if we remove such bit.


That was the original idea behind it. But where do we use host byte
order?

>>Unfortunately there is no easy way to get rid of it, current
>>userspace code sends it to the kernel, so even if we stop
>>including it in the kernel, we need to deal with it for
>>compatibilty.
> 
> 
> We have a field in the nfnetlink that contains the protocol version that
> we can use for this kind of changes without breaking backward.


If we still support the old stuff we can't get rid of it.
I would really like to remove all the duplicated code and
use the much nicer netlink infrastructure we have today.
