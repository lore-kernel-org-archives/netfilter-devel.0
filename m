From: Maciek Zobniow <maciek@zobniow.net>
Subject: Re: [PATCH][MARKCB] Balancing connections betewen a few internet
 links with HA.
Date: Mon, 22 Sep 2003 11:28:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F6EC0A5.2040701@zobniow.net>
References: <3F68C63E.4070309@zobniow.net> <20030921142233.GD20986@sunbeam.de.gnumonks.org> <3F6E1ED5.4080304@zobniow.net> <20030921222853.GA30961@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
 netfilter-devel@lists.netfilter.org
In-Reply-To: <20030921222853.GA30961@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:
> On Sun, Sep 21, 2003 at 11:57:41PM +0200, Maciek Zobniow wrote:
> 
>>>You can build a solution based on the CONNMARK target/match, together
>>>with the 'nth' match, the MARK target and policyrouting.
>>
>>If I am good understanding what you mean, your suggested solution will 
>>have only WRR balancing algoritm, without HA. 
> 
> 
> This is true, at least as long as you only use 'nth'.  There are also
> the 'fuzzy' and 'random' matches, which would give slightly different
> behaviour.
> 
> 
>>Additonaly related connections will have possability to go by diffrent
>>ways. 
> 
> 
> No, since CONNMARK givs us the inherited connection mark (and thus the
> needed persistency for related connections)
> 
> 
>>In my module you can chose another algorytm and I will extend the set
>>of possibly balance algoritms (there is a lot of possibilites).
> 
> 
> yes.  However, you implement thos algorithms specifically for your
> module.  If the algorithm was somehow implemented as iptables match,
> everybody could use it [even for a different purpose].

I think that it can not working as iptables match. There is a diffrent 
betewen normal matchs in iptables and match algoritms in markcb module. 
In this module, when new connection is coming it try to chose a mark for 
this connection. It operate on collected data (configuration from user 
or lines loading) about links, not connections. I tried to abstract this 
module as much as possible, therefore it only marking this connections 
by chosen algoritm and could be use for another purpose.
This is also the advantage of markcb module to your suggested solution - 
it can keep and process data in real time, therefore more complex 
balance algoritms are possible.

Best regards

-- 
Maciej Zobniow
Open Source - Free software for free people.
http://markcb.zobniow.net
http://mysql.zobniow.net
