From: Patrick McHardy <kaber@trash.net>
Subject: Re: SO_ORIGINAL_DST does not work in nat/OUTPUT anymore
Date: Sun, 10 Jul 2005 18:18:53 +0200
Message-ID: <42D14A6D.4000900@trash.net>
References: <42D12E28.7020707@hoelldampf.net>
	<20050710153234.GM20465@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050710153234.GM20465@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> On Sun, Jul 10, 2005 at 04:18:16PM +0200, Jens Hoelldampf wrote:
> 
>>the upstream patch from
>>
>>https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=91
>>
>>destroys the functionality of SO_ORIGINAL_DST for local generated
>>packets. It returns the local address the connection is redirected to
>>instead of the original destination address. As a result you cannot use
>>local transparent proxies anymore.
> 
> ouch.  It seems like we really need to revert that change and find a
> different solution for conntrack unloading :(
> 
> Thanks for reporting this.
> 
> Patrick, are you already working on this?

I was thinking about reverting it because of the RST over loopback
problem reported in another thread, but wanted to discuss it with
you first. I don't see how this change can affect SO_ORIGINAL_DST
though, all it does is look up the conntrack entry by a tuple
generated from data stored in the socket. It never even gets to
see a packet.

Regards
Patrick
