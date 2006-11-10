From: Patrick McHardy <kaber@trash.net>
Subject: Re: new code; iptables-xml for iptables package.
Date: Fri, 10 Nov 2006 14:07:14 +0100
Message-ID: <45547982.2070606@trash.net>
References: <455311B5.5000600@ufomechanic.net> <455374BE.9050507@trash.net>
	<455457C8.4030205@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <455457C8.4030205@ufomechanic.net>
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

Amin Azez wrote:
> * Patrick McHardy wrote, On 09/11/06 18:34:
>>
>>We can do that, but the code needs some serious coding style
>>cleanup before that. Please look at Documentation/CodingStyle
>>from the kernel source, it pretty much applies to iptables as
>>well.
>>  
> 
> Thanks for the tip.
> 
> Does this meet with approval?

Much better, thanks. Two minor nitpicks: return is not a function,
so I prefer return x to return (x). Functions and function calls
should have their opening parens directly following the function
name (unlike loops etc. where we use a space). But don't bother
changing it unless you feel really motivated :)

One real comment below ..

> 		} else if ((buffer[0] == ':') && (curTable[0])) {
> 			/* New chain. */
> 			char *policy, *chain;
> 
> 			chain = strtok (buffer + 1, " \t\n");
> 			DEBUGP ("line %u, chain '%s'\n", line, chain);
> 			if (!chain) {
> 				exit_error (PARAMETER_PROBLEM,
> 					    "%s: line %u chain name invalid\n",
> 					    program_name, line);
> 				exit (1);
> 			}
> 
> 			DEBUGP ("Creating new chain '%s'\n", chain);
> 
> 			policy = strtok (NULL, " \t\n");
> 			DEBUGP ("line %u, policy '%s'\n", line, policy);
> 			if (!policy) {
> 				exit_error (PARAMETER_PROBLEM,
> 					    "%s: line %u policy invalid\n",
> 					    program_name, line);
> 				exit (1);
> 			}
> 
> 			struct ipt_counters count;
> 
> 			char *ctrs;

This doesn't compile with old gcc versions. Unlike the kernel we still
support gcc-2.95 (I think), so please make sure you have no declarations
after statements.
