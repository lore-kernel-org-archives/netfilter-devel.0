From: David Cannings <lists@edeca.net>
Subject: Re: Unique IDs for rules?
Date: Mon, 19 Jan 2004 17:38:26 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401191738.26995.lists@edeca.net>
References: <Pine.LNX.4.44.0401191700100.11664-100000@filer.marasystems.com>
Reply-To: david@edeca.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0401191700100.11664-100000@filer.marasystems.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Monday 19 January 2004 4:03 pm, Henrik Nordstrom wrote:
> On Mon, 19 Jan 2004, David Cannings wrote:
> > I want to do similar with other rules elsewhere in the chain but I
> > can't be sure that they'll always be number 12, for example.  This
> > makes grepping for them a little harder.  Would it be possible to
> > have some sort of "comment" field for each rule so that some sort of
> > token or unique ID for the rule could be inserted.  That way, it
> > would simply be a case of "iptables -L -v | grep 'token'".
>
> There was a dummy match posted some time ago intended for this purpose,
> or at least it was discussed. This adds very little extra overhead
> provided the match is the last match used in the rule.
>
> As an alternative you can always have the target rule in a custom chain
> with a jump in the main chain. This way you always know where to look.
> This adds a about marginally more overhead than the above if done
> correctly.

An excellent idea, thank you.  Doing it this way, I will also be able to 
count bytes in/out of specific ports (such as HTTP) which will let me 
graph even more useless statistics!  One last question, however.  I've 
created a new chain called COUNTER.  In this chain, I've got two rules:

iptables -A COUNTER -i eth0
iptables -A COUNTER -o eth0

To count packets in and out of eth0, respectively.  I then jump to this 
chain from the top of both INPUT and OUTPUT, using a rule:

iptables -I INPUT -j COUNTER
iptables -I OUTPUT -j COUNTER

Is it "safe" to jump like this from both input and output chains to one 
shared chain?  As I am not affecting the destiny of the packet (and seems 
iptables lets me) I feel it must be, however I thought I would check 
first.

Thanks again,

David
