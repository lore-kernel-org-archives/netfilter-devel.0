From: Andre Uratsuka Manoel <andre@insite.com.br>
Subject: Re: using a hash table for netfilter tables?
Date: Thu, 24 Apr 2003 23:14:54 -0300 (BRT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0304242311250.8241-100000@fantomas.insite.com.br>
References: <20030424230112.GP8524@ns.snowman.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick Schaaf <bof@bof.de>,
	"netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephen Frost <sfrost@snowman.net>
In-Reply-To: <20030424230112.GP8524@ns.snowman.net>
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
> > 	I have to have different rules for 5.000 different IP addresses 
> > and I have to be able to change them any time in any order, in a very 
> > small time. 
> 
> Interesting.  What would you say to a netfilter module which allowed you
> to specify a table for each IP address to jump to with a hash table
> implementation thus giving you a constant-time lookup?

	That would be exactly what I need :)

	The idea of using this tree of chains was the first that occured 
me. At the number of chains I had until now, it was very good. My problems 
started when I decided that I needed to have 10 times as many chains...

> I'll think about this some more but I think it should be possible to do
> that.

	Thank you

	Andre
	
