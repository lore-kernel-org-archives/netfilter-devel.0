From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: inner structure of iptables
Date: Wed, 17 Mar 2004 08:25:00 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403170822170.4188-100000@filer.marasystems.com>
References: <40571962.5070701@aiqa.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ozgur AKAN <akan@aiqa.com>
In-Reply-To: <40571962.5070701@aiqa.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 16 Mar 2004, Ozgur AKAN wrote:

> In the 4th line "e = iptc_first_rule(chain, &h)" we get the adress of
> the first rule of the first chain and by the loop it goes to next rule
> until there is no next rule. How does it know that it is the last rule
> of this chain? Why doesn`t it continue to read the first rule of next
> chain? (Because there is no chain information here -> e =
> iptc_next_rule(e, &h))

Because iptc_first_rule remembered where the end of this chain is in the
handle.

See TC_FIRST_RULE/TC_NEXT_RULE in libiptc/libiptc.c

Regards
Henrik
