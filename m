From: Brian Gunlogson <bmg300@yahoo.com>
Subject: Re: Matching 10000's of IP ranges (solution)
Date: Wed, 5 Jan 2005 13:01:22 -0800 (PST)
Message-ID: <20050105210122.49276.qmail@web41511.mail.yahoo.com>
References: <1104776274.3277.22.camel@jasiiitosh.opensourcedevel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter developers list <netfilter-devel@lists.netfilter.org>,
	Netfilter users list <netfilter@lists.netfilter.org>
Return-path: <netfilter-bounces@lists.netfilter.org>
To: "John A. Sullivan III" <jsullivan@opensourcedevelopmentcorp.com>
In-Reply-To: <1104776274.3277.22.camel@jasiiitosh.opensourcedevel.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Your solutions were way too slow. So I wrote a module that does a binary search to find ip ranges
in a sorted list. Would netfilter be interested in the source code? I don't have the desire to put
it into patch-o-matic format, but that shouldn't be hard to do. Also, It was built to read the
ranges from a file, but I don't know how to pass a dynamic ammount of memory from iptables to the
kernel module so they must be hardcoded into the module.

Brian G.

--- "John A. Sullivan III" <jsullivan@opensourcedevelopmentcorp.com> wrote:

> > What is a reasonable way to match around 80000 IP ranges with iptables?
> The iprange patch will enable you to define ranges in iptables.  If you
> do not want to patch, you can use SubnetCreator
> (http://subnetcreator.sourceforge.net).
> 
> You will also want to ensure that you load the rules with iptables-
> restore or iptables-restore -n rather than using a script with lots of
> iptables commands.  At your size, individual iptables commands would
> take forever to load.
> -- 
> John A. Sullivan III



		
__________________________________ 
Do you Yahoo!? 
Read only the mail you want - Yahoo! Mail SpamGuard. 
http://promotions.yahoo.com/new_mail 
