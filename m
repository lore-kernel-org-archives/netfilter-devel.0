From: Anders Fugmann <afu@fugmann.dhs.org>
Subject: Re: remove usage of __MOD_XXX_USAGE_COUNT and derivatives
Date: Fri, 10 Jan 2003 16:21:16 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E1EE4EC.7010703@fugmann.dhs.org>
References: <3E1DEF2D.4080703@fugmann.dhs.org> <20030110131315.GS1353@sunbeam.de.gnumonks.org> <3E1ECF6B.5080109@fugmann.dhs.org> <20030110134959.GE9467@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20030110134959.GE9467@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:
> On Fri, Jan 10, 2003 at 02:49:31PM +0100, Anders Fugmann wrote:
 >
> I don't think that this is necessarry.  What is in fact necessarry, is
> increasing the module use count for every rule created.  Otherwise it
> would state 'iptable_filter:unused' in case you had 10 dropping rules.
> This used to be the old behaviour, but confused a couple of users... so
> we decided to change it.
Ok - I will split my answer up into two parts.
1. It seems that we agree upon modules should not have their module 
count increased because a new module is loaded. This is the current case.

2. If the general design goal is to have modules reflect all rules, I 
guess that the sum of all module counts should be equal or greater than 
the total number of rules. If this is the case, then where which module 
should be increased when inserting the rule "iptables -A INPUT". In 
general - Should not iptables_filter's module count be incremented for 
every inserted rule in the filter tabel (Same goes for NAT and MANGLE).

I'm asking, as I'm willing to spend some time understanding the system, 
and make patches for Netfilter.

Regards
Anders Fugmann
