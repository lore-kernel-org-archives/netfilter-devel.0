From: Andre Uratsuka Manoel <andre@insite.com.br>
Subject: Re: using a hash table for netfilter tables?
Date: Thu, 24 Apr 2003 15:28:17 -0300 (BRT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0304241510150.8241-100000@fantomas.insite.com.br>
References: <20030424062148.GE3374@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20030424062148.GE3374@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 24 Apr 2003, Patrick Schaaf wrote:

> On Thu, Apr 24, 2003 at 02:19:58AM -0300, Andre Uratsuka Manoel wrote:
> > 
> > 	I need to replace the current list-based netfilter code for 
> > something using hashtables. The reason is that I have hundreds of tables 
> > in a project, but set up times are killing me.
> 
> I assume you already use iptables-restore to load them in one go?
> If not, you want to do that!

	That is something I really have to do, but I don't, yet. But I 
still don't think it will speed it up that much...

> Apart from that, what you appear to think you could do, is NOT easy.
> 
> Three very basic easy questions for you:
> 
> 1) what, exactly, is the key material you'll compute the hash function on?

	table name.

> 2) for any given iptables match line, a multitude of keys could match.
>    What do you do?

	collisions would be dealt with by means of a linked list.

> 3) Each iptables line is a combination of several matches. Each of them
>    can represent a range of matching values. Sometimes, that range is
>    not even known when the rule is loaded. Consider stateful matches
>    like 'limit' and 'random'.  What do you do?  

	I don't think I made myself clear. What I want is not to replace 
the normal rule evaluation inside a table. What I actually want is to be 
able to find a table in constant time. Not when a packet is traversing the 
filters, but when the rules are changed. To replace a rule, netfilter has 
to traverse the linked list of tables until it finds the table with the 
correct name, before it does any work. I want to avoid this time, since I 
have those hundreds of tables.

> There is an ongoing attempt at meeting the challenges for a noninterpretive
> lookup structure. See http://www.hipac.org/. I have no personal experience
> with that code, though. They solve 1) by giving a list of the key
> material (see the site), and they are solving 2) and 3) step by
> step, by building their own tool parallel to iptables, with only
> the features they can efficiently represent. The result is emphatically
> NOT iptables, and can't be.

	That's interesting. I'm checking it out, it just doesn't seem to
be ready for what I need to do... I have a simpler solution, that just
requires lots of tables. BTW, it already works, but I have to multiply the 
number of tables an order of magnitude now.


	Regards,

	Andre

	
