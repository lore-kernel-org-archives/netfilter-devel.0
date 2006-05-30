From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Unconditionaly push mark to conntrack structure
Date: Wed, 31 May 2006 01:43:38 +0200
Message-ID: <447CD8AA.2040502@trash.net>
References: <E1Fh0am-0003Ct-Ph@fydelkass.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <E1Fh0am-0003Ct-Ph@fydelkass.inl.fr>
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

Eric Leblond wrote:
> This is needed in userspace as the mark can be used to select 
> efficiently a subset of the conntrack events to work on.

I'm a bit reluctant to special case mark, but mostly because I wonder
whether we shouldn't just behave like all other networking subsystems
and send update messages containing the entire new state. If you look
at the optional information:

- status bits are only 4 byte.
- timeout is currently transmitted for every packet anyway - its better
  to just reduce the event rate (we even had a patch for this for ages)
- protoinfo: at least for the majority of traffic (tcp) included in
  every message as well
- helpinfo: most connections don't have helpers

The mark is currently missing entirely (your patch is on top of one
of my patches I didn't submit yet), another 4 bytes.

So basically we have an extra 8 bytes per message and reduce complexity
for users by sending the entire state .. a good tradeoff in my opinion.
With the patch to reduce timer events we should still need _a lot_ less
bandwidth than today.
