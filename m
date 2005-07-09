From: Patrick McHardy <kaber@trash.net>
Subject: Re: Unable to add rule on Chain with 30 characters.
Date: Sat, 09 Jul 2005 03:11:24 +0200
Message-ID: <42CF243C.4010405@trash.net>
References: <42CEDD9D.5020808@interage.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rafael Dreher <dreher@interage.com.br>
In-Reply-To: <42CEDD9D.5020808@interage.com.br>
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

Rafael Dreher wrote:
> Hi,
> 
> I'm trying do add a rule on a user-defined chain, on the NAT table, with 
> exactly 30 characters.
> 
> The chain have bee added without any problem, but when I add the rule, 
> iptables says that it's unable do find the chain.
> 
> If I reduce the chain to 28 characters, it works. I'm trying to migrate 
> a set of rules form iptables-1.2.11 to 1.3.1,
> and I don't want to rewrite the rules.

The maximum name length for matches and targets (and user-defined
chains) has been reduced by one to make room for a versioning byte.
You seem to be the first unlucky person that uses all available
bytes. The only possible solution is to reduce the length of your
chain-names.

Regards
Patrick
