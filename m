From: Matthew Strait <quadong@users.sourceforge.net>
Subject: Re: l7-filter patch for p-o-m
Date: Wed, 22 Jun 2005 12:57:23 -0500 (CDT)
Message-ID: <Pine.LNX.4.62.0506221253060.9129@localhost.localdomain>
References: <Pine.LNX.4.61.0505312259080.6304@localhost.localdomain>
	<42AB00FB.9030900@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42AB00FB.9030900@trash.net>
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

>> 8 months later, here's a l7-filter patch for patch-o-matic again.
>
> I have no general objections against including this, but IIRC you need
> some extra files for userspace. Would it make sense to add them as well?

Since I included an iptables extension in my patch, I assume you mean the 
protocol definition files.  I don't think it would make sense to include 
them in p-o-m, since they are frequently updated and it would be very 
clunky to make you guys deal with every update.  They are intended to be 
modular anyway.

-matthew
