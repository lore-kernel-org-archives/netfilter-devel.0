From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: chain_cache
Date: Fri, 21 May 2004 13:25:25 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405211320490.24649-100000@filer.marasystems.com>
References: <40ADDB5D.7070806@aiqa.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ozgur Akan <akan@aiqa.com>
In-Reply-To: <40ADDB5D.7070806@aiqa.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 21 May 2004, Ozgur Akan wrote:

> Another problem is when we delete a rule the, the rule before the rule 
> we deleted and the rule after the rule we deleted may be the same. This 
> must be also checked. (I mean if we delete rule number 4, 3rd and 5th 
> rules must be checked)  Because of this reason modificaiton of 
> insert_rule is not enough.

Not sure this is good. You do not want your ruleset to get rejected only
because you deleted another rule.

But what you could do if this is really what you want is to write a 
validator function which validates the table before it is uploaded to the 
kernel. This involves walking all the chains, and has the added benefit 
that it shold not be hard to add additional verifications later on.

Regards
Henrik
