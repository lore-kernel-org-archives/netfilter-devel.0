From: "Taylor, Grant" <gtaylor@riverviewtech.net>
Subject: Re: Problem with two addrtype matches in one iptables rule.
Date: Tue, 17 May 2005 00:48:33 -0500
Message-ID: <428985B1.9080701@riverviewtech.net>
References: <42883902.7030909@riverviewtech.net> <42894A5B.5050000@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	netfilter@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42894A5B.5050000@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> This is a known limitation of iptables:
> 
> /* FIXME: This scheme doesn't allow two of the same
>    matches --RR */

*nod*  This explains a few things.  Thank you for the input.

> It looks like fixing it would break compatibility because currently
> arguments to matches can occur at any position:

Hmm...

> I suggest you add the second match to a new chain and jump to it
> from the first match.

I was afraid that I would have to do such.  It looks like I'll be playing with the GOTO target extension then.



Grant. . . .
