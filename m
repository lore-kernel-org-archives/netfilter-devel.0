From: Matthew Strait <quadong@users.sourceforge.net>
Subject: Re: [PATCH] l7-filter for pom (2)
Date: Mon, 23 Aug 2004 20:16:40 -0500 (CDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.60.0408232015230.4521@localhost.localdomain>
References: <Pine.LNX.4.60.0408151944550.15521@localhost.localdomain>
 <20040819104443.GG3921@sunbeam.de.gnumonks.org>
 <Pine.LNX.4.60.0408231825530.4521@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org,
    l7-filter-developers@lists.sourceforge.net
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <Pine.LNX.4.60.0408231825530.4521@localhost.localdomain>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

>> - Don't have printk() in per-packet codepath without net_ratelimit() or
>>  you will be DoS'ed
>
> The code should not print anything unless debugging is enabled.  I'm assuming 
> that no one will enable debugging unless they are in a controlled 
> environment.  And when debugging, it would be bad to have most of the 
> messages dropped.  Is this still not ok in your view?

(Replying to self.)  Sorry, I wasn't thinking hard enough.  Obviously, I 
should have rate limits on the error messages, if not the debugging 
messages.

-matthew
