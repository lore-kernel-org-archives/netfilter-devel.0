From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Ruleset creation process.
Date: Sun, 3 Oct 2004 18:07:05 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0410031804410.16241@filer.marasystems.com>
References: <415E83B5.5090301@inventum.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Padam J Singh <padam.singh@inventum.cc>
In-Reply-To: <415E83B5.5090301@inventum.cc>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2 Oct 2004, Padam J Singh wrote:

> Is there are document that specifies the ruleset creation process?

What part of the ruleset creation process?

> I recently had an issue with destroy being called for old rules when adding a 
> new rule for the same target.

Destroy of what, where?

If you refer to the match/target destroy functions being called then this 
is by design of iptables. Each modification to an iptable results in a 
new table being installed in the kernel and the old deleted.

Regards
Henrik
