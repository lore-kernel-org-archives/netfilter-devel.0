From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [RFC v2] nf_tables: Transaction API proposal
Date: Tue, 02 Apr 2013 11:26:23 +0300
Message-ID: <515A962F.5010504@linux.intel.com>
References: <20130328100415.GA7848@localhost> <1364478773-13302-1-git-send-email-tomasz.bursztyka@linux.intel.com> <20130328170217.GA8859@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48551 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244Ab3DBI00 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:26:26 -0400
In-Reply-To: <20130328170217.GA8859@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

>> About the commit, you are right Pablo: only one at a time, this is mandatory.
>> I missed the point on my first proposal.
>>   
>> To do so I introduced a mutex. If it's already locked it return -EAGAIN, so it's up
>> to the client to retry. I guess this is anyway not going to happen very often.
>> I don't know if we could get something better here, at least now no client can
>> lock up the other indefinitely, it enables per-client transaction...
> Races may still occur if we try to support simultaneous transactions.
>
> client 1
> start transaction                 client 2
> add rule X1, table Y1, chain Z1   start transaction
> ... more rule updates             delete all rules in table Y1, chain Z1
> ... more rule updates             commit

1 line is missing
     notifications (other rules deleted)   notifications (ok chain Z1 
has no rules)

> commit

and:
     notifications (own rules added)      notifications (hum, new rules 
added. ok)

> client 2 will see rules in table Y1, chain Z1 after its commit but
> will not know why. However, if it hits -EBUSY because another client
> was performing a transaction, it can retry a fresh update with the
> current rule-set, not based on the stale one.

Your example is wrong: it is valid, as it would be also in a unique 
transaction based approach as your are proposing:
client 2 - start / delete all rules / commit
client 2 - notifications: see no rules
client 1 - start / add rules / commit
client 2 - notifications: see rules again.
=> exact same result, which is a legitimate one in both case.

As long as transaction n cannot mess up with any other transaction m, 
there is definitely no race condition between transactions.
It would be a race condition in your example if client 2 can delete the 
rule updates of client 1.
But this must not be the case, and that's also why we should not dump 
the non-active rules to anybody BUT to the owner.
--> As long as a rule is not active: it does not exist but in a transaction.
With transaction you never know the result as long as it did not end up 
to a commit, so there is no point to tell everybody about it before.

I still think it's really wrong to propose unique transaction approach: 
if the client is bogus (and they will! ^^) and never commit/abort its 
transaction, it locks all others.

Anyway, there are issues in my proposal I agree: it's an RFC not a patch.
For instance:
In your proposal, as long a the transaction is "going on" no other 
manipulation can be done to the rule base. It's wrong because it locks 
all other clients (even on untouched tables/chains by the transaction) 
but it "fixes" the case where non-transaction based manipulation could 
be done: these are locked as well. And it does that to all 
manipulations, whatever table/chain is in the game.

--> in my RFC, getting non-transaction based manipulation could lead to 
troubles: what if a non-atomic manipulation removes all rules and the 
chain itself, where a transaction was working? (yes that one is a valid 
race condition ;-) )
Here we could fix it, if there is a transaction going on in that 
specific chain, either by killing the entire transaction and notifying 
its owner (I would prefer that one), or like you are doing: return 
ebusy. But I don't like the idea of a transaction being able to lock 
anyone (I repeat myself, sorry).
To me, non-transaction (so non-atomic) based manipulation should always 
have the highest priority versus any transactions, unless a commit is 
going on of course. We have to maintain this difference of transaction 
and non-transaction based manipulation.

We have to think properly about that: how we store the transaction in an 
efficient way so it would not be a performance issue to look-up for a 
table/chain in transaction list. Things like that.
I am sure we can get something still simple and reliable from API point 
of view but way more flexible than your approach. And with nobody being 
able to lock this subsystem. We are not in a hurry anyway.

> +
> +static void nf_tables_transaction_remove(struct nft_transaction *transaction)
> +{
> +	nfnl_lock();
> Won't work. nfnl_lock is already held when calling this function. Note
> that all nfnetlink functions are currently protected by nfnl_lock.

Indeed, did that patch too quickly. Loosely looked at nf_tables_expressions.

> +	/* Check if a commit is on-going */
> +	if (mutex_trylock(&nf_tables_commit_lock))
> +		return -EAGAIN;
> You should use -EBUSY. -EAGAIN is used internally by nfnetlink to
> retry on module autoload.

Ok good to know.

Br,

Tomasz
