From: Patrick McHardy <kaber@trash.net>
Subject: Re: [iptables 1.3.0 / libiptc patch] sort chains by hooknum/names
Date: Fri, 04 Mar 2005 23:38:23 +0100
Message-ID: <4228E35F.4010609@trash.net>
References: <20050304212114.130e2a7c@coruscant>
	<20050304220827.GA23938@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050304220827.GA23938@linuxace.com>
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

Phil Oester wrote:
> On Fri, Mar 04, 2005 at 09:21:14PM +0100, Olaf Rempel wrote:
>>
>>I've created two patches to revert it to the "old" behavior:
>>first buildin chains, sorted by hooknum, than userdefined chains, sorted by name.
> 
> Why is the old behaviour better than the current?  Any scripts you have
> should be smart enough to check for '^Chain ______' to determine chain.

Unfortunately not all are, so best chance of no breakage is keeping the
old behaviour. I can't remember where, but someone already reported a
broken script because of this change.

Regards
Patrick
