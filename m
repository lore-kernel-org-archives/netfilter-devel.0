From: Andre Uratsuka Manoel <andre@insite.com.br>
Subject: Re: using a hash table for netfilter tables?
Date: Thu, 24 Apr 2003 22:47:54 -0300 (BRT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0304242243530.8241-100000@fantomas.insite.com.br>
References: <Pine.LNX.4.44.0304241208400.24242-200000@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>
In-Reply-To: <Pine.LNX.4.44.0304241208400.24242-200000@localhost>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 24 Apr 2003, Chris Wilson wrote:

> > I need to replace the current list-based netfilter code for something
> > using hashtables. The reason is that I have hundreds of tables in a
> > project, but set up times are killing me. I took a peek at the code and
> > it looked easy to do, since the current list-based code already takes
> > care of locking, that's a huge problem I don't have to care about.
> >
> > Is there something I should know abot? Any tips? Is this stupid?
> 
> If, as Patrick Schaaf suggested, you are already using iptables-restore, 
> then it could be that you are having the same problems as us. Would you be 
> willing to try Robert Olsson's kernel patch, to see if it makes a 
> difference to your ruleset loading time? Our cleaned-up version of the 
> patch is attached, or we can give you the original if you prefer.

	I wasn't using iptables-restore, but I gave it a try and it takes
about 2 minutes to load 600 chains. The time seems to be inside
iptables-restore, and not in the kernel.

	I will try the patch, but that will have to wait a few days, since
I have to take care of some other business before that. I took a quick
peek at it, and didn't understand it yet...

	Later, though, I will have to deal with changing rules and those 
still require linear-time searches...

	Thank you for your help.

	Andre

	
