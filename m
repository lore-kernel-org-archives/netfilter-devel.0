From: Philip Craig <philipc@snapgear.com>
Subject: Re: Developing a user space library for filtering
Date: Wed, 23 May 2007 10:29:27 +1000
Message-ID: <46538AE7.8040405@snapgear.com>
References: <46521CB9.2040309@Sun.COM>
	<46522166.1090603@gmx.net>	<465222C0.8050601@Sun.COM>	<Pine.LNX.4.61.0705220826110.4452@yvahk01.tjqt.qr>	<20070522064613.GA27619@oknodo.bof.de>
	<4653578C.3070407@Sun.COM>	<20070522211404.GC24990@ipom.com>	<1179874698.18674.22.camel@henriknordstrom.net>
	<465382DB.3080106@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Phil Dibowitz <phil@ipom.com>,
	Henrik Nordstrom <henrik@henriknordstrom.net>
To: Darren.Reed@Sun.COM
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <465382DB.3080106@Sun.COM>
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

Darren.Reed@Sun.COM wrote:
> Henrik Nordstrom wrote:
>> Having an API which says things like "Add a rule to accept this kind of
>> traffic" is only possible cross the different firewall implementations
>> if there also is a defined firewall ruleset structure requirement
>> defining suitable places in the ruleset where this API can make it's
>> modifications.
>>  
>>
> 
> Which means that coming up with a design that works won't
> necessarily be a slam-dunk.

It means the API must an interface to a firewall policy, not to a kernel
mechanism.  For example, the API should enable you to tell shorewall
that you want to accept something, rather than directly generating
an iptables rule.  (Although a simple implementation for the case where
you have no firewall policy may directly generate an iptables rule.)
