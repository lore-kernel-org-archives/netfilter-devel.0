From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Unique IDs for rules?
Date: Mon, 19 Jan 2004 17:03:19 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401191700100.11664-100000@filer.marasystems.com>
References: <200401191331.42034.lists@edeca.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: david@edeca.net
In-Reply-To: <200401191331.42034.lists@edeca.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 19 Jan 2004, David Cannings wrote:

> I want to do similar with other rules elsewhere in the chain but I can't 
> be sure that they'll always be number 12, for example.  This makes 
> grepping for them a little harder.  Would it be possible to have some 
> sort of "comment" field for each rule so that some sort of token or 
> unique ID for the rule could be inserted.  That way, it would simply be a 
> case of "iptables -L -v | grep 'token'".  

There was a dummy match posted some time ago intended for this purpose, or 
at least it was discussed. This adds very little extra overhead provided 
the match is the last match used in the rule.

As an alternative you can always have the target rule in a custom chain
with a jump in the main chain. This way you always know where to look. 
This adds a about marginally more overhead than the above if done 
correctly.

Regards
Henrik
