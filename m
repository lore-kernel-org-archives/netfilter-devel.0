From: "David S. Miller" <davem@davemloft.net>
Subject: Re: iptables as a state machine
Date: Thu, 30 Sep 2004 21:01:27 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040930210127.0ac9623c.davem@davemloft.net>
References: <20040930193955.6fa24afc.davem@davemloft.net>
	<61687.63.170.215.71.1096602469.squirrel@www.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: shemminger@osdl.org
In-Reply-To: <61687.63.170.215.71.1096602469.squirrel@www.osdl.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 30 Sep 2004 20:47:49 -0700 (PDT)
shemminger@osdl.org wrote:

> Have you looked at nf-hipac.  It works and is fast but is limited
> to 2.4 right now.  It's on my to do list...

nf-hipac is what I was indirectly referring to when I
said "B-Tree based schemes". :-)

nf-hipac is fast for lookups, but it does so at a huge
cost in memory usage.  It uses B-Trees and prefix
expansion, which is a well known technique for this
task.

How prefix expansion works is basically like the following.
Say you had a rule which matches on address "10.0.0.0/24"
Prefix expansion would duplicate this rule 256 times, one
for every address in that prefix'd range.

	10.0.0.1
	10.0.0.2
	...
	10.0.0.255

Then you can use whatever data structure you wish to do
an exact match lookup.  The nf-hipac folks choose a B-Tree
although at this point you could simply use a plain hash
as well.

It is a classic example, in fact, of a memory usage vs.
lookup performance tradeoff.

I warn you if you go looking at the existing nf-hipac, it's
big and complex :-)  My dislike of nf-hipac's approach is
one of the reasons I went looking for other possible schemes.
