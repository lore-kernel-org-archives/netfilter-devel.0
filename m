From: Matthew Strait <quadong@users.sourceforge.net>
Subject: Re: [PATCH] l7-filter for pom
Date: Sun, 5 Sep 2004 17:00:12 -0500 (CDT)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409051644250.6562@localhost.localdomain>
References: <Pine.LNX.4.60.0408151944550.15521@localhost.localdomain>
	<20040819104443.GG3921@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.60.0408231825530.4521@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: l7-filter-developers@lists.sourceforge.net,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <Pine.LNX.4.60.0408231825530.4521@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> I see that conntrack-acct is 2.6 only.  I'd rather not lose 2.4 
> compatibility.  Should I:
>
> 1) Put separate 2.4 and 2.6 patches in p-o-m, one of which uses 
> conntrack-acct and one of which doesn't.  (Ugly.)
>
> 2) Only submit a 2.6 patch to you and maintain my 2.4 patch outside p-o-m. 
> (Clunky.)
>
> 3) Ask for conntrack-acct to be made 2.4 compatible.  (Work for you.)

I don't know what the etiquette about re-asking unanswered questions is 
around here.  I hope two weeks is a long enough time-out...

I can't continue development for p-o-m until I know what is required to 
get accepted.  If either (1) or (2) above would be ok, please let me know 
and I'll choose myself.

Thanks,
matthew
