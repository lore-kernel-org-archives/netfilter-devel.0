From: Andre Uratsuka Manoel <andre@insite.com.br>
Subject: Re: using a hash table for netfilter tables?
Date: Thu, 24 Apr 2003 19:56:54 -0300 (BRT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0304241547520.8241-100000@fantomas.insite.com.br>
References: <20030424184706.GM8524@ns.snowman.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick Schaaf <bof@bof.de>,
	"netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephen Frost <sfrost@snowman.net>
In-Reply-To: <20030424184706.GM8524@ns.snowman.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 24 Apr 2003, Stephen Frost wrote:

> * Andre Uratsuka Manoel (andre@insite.com.br) wrote:
> > 	That's interesting. I'm checking it out, it just doesn't seem to
> > be ready for what I need to do... I have a simpler solution, that just
> > requires lots of tables. BTW, it already works, but I have to multiply the 
> > number of tables an order of magnitude now.
> 
> I'm just curious but what is it that you're doing that requires so many
> tables?  Perhaps there's a better way to do it...

	I knew that would come up. :)

	I have to have different rules for 5.000 different IP addresses 
and I have to be able to change them any time in any order, in a very 
small time. 

	If I keep them in a single chain, the filtering code will have to
do n/2 comparisons on average (2500) for every single packet, so I divide
them in groups of 16, and join those 16 by 16 and so on. I have roughly
n/15 different chains and so I do, on average, 8*(16/2) comparisons for
every packet, that is, around 64, no matter how many IPs are behind my
firewall.

	Regards,
	Andre
