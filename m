From: Eric Leblond <eric@inl.fr>
Subject: Re: nfsim updates
Date: Thu, 23 Sep 2004 14:41:49 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1095943308.3478.24.camel@coati>
References: <20040919223457.GL1307@sunbeam.de.gnumonks.org>
	<1095732625.1940.166.camel@bach>  <200409222104.36526.jk@ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200409222104.36526.jk@ozlabs.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2004-09-23 at 03:04, Jeremy Kerr wrote:
> This would probably be the best way to go - It also depends on how the 
> netfilter testsuite is going to be developed - would using the subversion 
> repository cause any problems, rather than rolling it into netfilter cvs?

That's not completly related but it's a simulation question. For the
nufw project we need to simulate a consequent number of clients having 
standard user activities to bench our server (I mean doing
pop,smtp,web).

Does someone know a sofware able to do so ?

By the way, nufw is now able to do application and os filtering for
remote users on top of its primary tasks user filtering. More
informations on http://www.nufw.org

BR, 
-- 
Eric Leblond <eric@inl.fr>
INL
