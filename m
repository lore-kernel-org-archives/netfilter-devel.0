From: Pablo Neira <pablo@eurodev.net>
Subject: Re: ip_ct_refresh lock issue
Date: Sat, 28 Feb 2004 16:04:26 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4040ADFA.4030107@eurodev.net>
References: <Pine.LNX.4.44.0402281547520.9609-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.44.0402281547520.9609-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi henrik,

Henrik Nordstrom wrote:

>But maybe there is some complication from NAT or related connections
>requiring this locking?
>  
>
Actually a quick view at:

http://lxr.linux.no/ident?v=2.6.1&i=ip_ct_refresh

show me that this function is only called from conntrack related stuff, 
specifically from protocol and helpers, so i can't see that complication 
from NAT nor with related connections. Anyway, I'm not sure at all... 
that's why i need some feedback.

>If not the lock should probably be moved down to the is_confirmed case. If
>the connections is not yet confirmed then the only reference should be
>from this packet (not yet in the hashes) and there should never be any
>concurrent accesses.
>  
>
yes, this is exactly what i had in mind :-).

thanks,
Pablo
