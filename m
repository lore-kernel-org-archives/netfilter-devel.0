From: Nicolas Bouliane <nib@cookinglinux.org>
Subject: Re: [PATCH 13/18] Netfilter: Multiport revision with port ranges
 (replaces "mport")
Date: Wed, 05 Jan 2005 00:32:18 -0500
Message-ID: <41DB7BE2.70502@cookinglinux.org>
References: <1104896159.20582.79.camel@localhost.localdomain>
	<20050105043027.GA23546@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20050105043027.GA23546@linuxace.com>
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

Phil Oester wrote:
> On Wed, Jan 05, 2005 at 02:35:59PM +1100, Rusty Russell wrote:
> 
>>The multiport match doesn't support ranges of ports, so a new match
>>called "mport" was written.  Now we have versioning of matches and
>>targets, we can simply put this extension in multiport revision 1.
> 
> 
> While I agree the above is a useful change, why not also add inversion
> to multiport in the process -- as long as you're making a new revision?
> Or should that be done in revision 2?
> 
> Phil
> 

AFAIK iptables already support ranges of ports.

iptables -A INPUT -p tcp --sport 10:40


Cheers :)

-acidfu
