From: Maciek Zobniow <maciek@zobniow.net>
Subject: Re: [PATCH][MARKCB] Balancing connections betewen a few internet
 links with HA.
Date: Sun, 21 Sep 2003 23:59:04 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F6E1F28.7060805@zobniow.net>
References: <3F68C63E.4070309@zobniow.net> <20030921142233.GD20986@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20030921142233.GD20986@sunbeam.de.gnumonks.org>
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
> On Wed, Sep 17, 2003 at 10:38:22PM +0200, Maciek Zobniow wrote:
> 
>>The patch and explanation you can find on
>>http://markcb.zobniow.net
> 
> 
> Hi!
> 
> May I ask, why did you invent a special Target?
> 
> You can build a solution based on the CONNMARK target/match, together
> with the 'nth' match, the MARK target and policyrouting.
> 
> 
>>Best Regards
>>Maciej Zobniow
> 
> 

If I am good understanding what you mean, your suggested solution will 
have only WRR balancing algoritm, without HA. Additonaly related 
connections will have possability to go by diffrent ways. In my module 
you can chose another algorytm and I will extend the set of possibly 
balance algoritms (there is a lot of possibilites). Related connetions 
will go always by the same way (at least I hope so - did not test this 
funcionality yet). I have the HA.
Anyway, one from reasons why I like the *nix world is that in this world 
  for each problem you can find a few ways to solve it.
Best regards

-- 
Maciej Zobniow
Open Source - Free software for free people.
http://markcb.zobniow.net
http://mysql.zobniow.net
