From: Jonas Berlin <jberlin@niksula.hut.fi>
Subject: Re: Owner on Input table
Date: Mon, 14 Feb 2005 09:41:32 +0200
Message-ID: <4210562C.6090401@niksula.hut.fi>
References: <000101c51162$aceabfa0$9600a8c0@netcontent>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Egon Phillips <egon.phillips@sympatico.ca>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <000101c51162$aceabfa0$9600a8c0@netcontent>
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

Egon Phillips wrote:

>I read in the docs that the owner match as described below is not
>available on the input chain.
>
>    This module attempts to match various
>    characteristics of the packet creator, 
>    for locally-generated packets. It is 
>    only valid in the OUTPUT chain, and even
>    this some packets (such as ICMP ping responses)
>    may have no owner, and hence never match. 
>
>Are there any plans to change this policy?  If not, is this a limitation
>of the software or of the OS?  Is it not possible to use the destination
>ports process id to determine the owner?
>____________________________________________________
>The Brockton Initiative (http://brockton.dyndns.org)
>Egon Phillips, Chair
>  
>
Afaik the owner-socketlookup patch in patch-o-matic-ng does what you are 
asking for. It has been around for over a year now.

<snip>
The patch allows you to use the owner match in the INPUT chain to match
properties of the receiving socket. It is mainly intended to help filter 
weird
protocols like H.323 or IIOB without conntrack helpers, but could also come
handy for local user traffic accounting and similar stuff.
</snip>

-- 
- xkr47
