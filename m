From: Patrick Schaaf <bof@bof.de>
Subject: Re: Private data structure for each iptables rule using
Date: Wed, 6 Jul 2005 08:55:13 +0200
Message-ID: <20050706065513.GG29624@oknodo.bof.de>
References: <005a01c581f1$cbbe1260$aa0ba8c0@l7.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Vincent <cs83152@csie.chu.edu.tw>
Content-Disposition: inline
In-Reply-To: <005a01c581f1$cbbe1260$aa0ba8c0@l7.com.tw>
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

> I am writing a individual netfilter module currently currently. I am
> encountering a problem that is how can I keep a private data structure
> for each 
> iptables rule in each connection.

What would that be used for?

> When packets traverses the first rule, I want to keep some private data
> in the connection tracking data structure. 
> But I think these private data are possible modified by the later
> "mymodule" rules. 

Only if you code them to do such modification.

> 2. Any suggestion to prevent different rule modify the same data
> structure of connection tracking?

A) What is it that would identify individual rules?
B) How do you add _any_ information to connection tracking?

If you can answer both questions precisely, keep a linked list of per-rule
nodes, with the head pointer in the connection tracking entry, and every
node storing which rule it belongs to.

Answering B) should be easy. A) is the tricky part. Think about
occasional modifications to the rulesets, and what should happen
to the then-current connection tracking stuff...

best regards
  Patrick
