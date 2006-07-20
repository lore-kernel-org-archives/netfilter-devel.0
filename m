From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] BUG: libiptc chain references bug
Date: Thu, 20 Jul 2006 18:52:06 +0200
Message-ID: <44BFB4B6.3050307@trash.net>
References: <Pine.LNX.4.61.0607121722360.13610@ask.diku.dk>
	<Pine.LNX.4.61.0607131303220.29013@tyr.diku.dk>
	<Pine.LNX.4.61.0607141427230.31153@tyr.diku.dk>
	<44BA54E1.1000908@netfilter.org>
	<Pine.LNX.4.61.0607162125500.31595@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: hawk@comx.dk, netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jesper Dangaard Brouer <hawk@diku.dk>
In-Reply-To: <Pine.LNX.4.61.0607162125500.31595@ask.diku.dk>
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

Jesper Dangaard Brouer wrote:
> 
> On Sun, 16 Jul 2006, Pablo Neira Ayuso wrote:
> 
>> I don't like too much the is-the-rule-in-list checking in
>> delete_entry, please, could you tell me what you think about the patch
>> attached? I think it's cleaner. Thanks.
> 
> 
> First of all, (no offence) your patch will not work, as it does not
> catch all control-flow cases. That is, if no match was found your patch
> does not decrement the refcount. Hint, look at the places free(r) is
> called.
> 
> I have attached a patch, that does catch all cases.  This is achived by
> adding a else statement to the if statement where iptcc_map_target is
> called.
> 
> I did consider, your strategy, but the reason I decided not to, was that
> I though it was cleaner to always call "iptcc_delete_rule" when we want
> to delete a rule, instead of free'ing it manually.
> 
> Well, I think Patrick should make the decision. As long as we fix the
> bug, I don't care which patch goes in.


I like the second patch better than the first one, so I've applied
this one. Thanks Jesper.
