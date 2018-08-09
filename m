From: "Andrey Jr. Melnikov" <temnota.am@gmail.com>
Subject: Re: [PATCH] netfilter: nf_queue: Replace conntrack entry
Date: Thu, 9 Aug 2018 17:09:37 +0300
Message-ID: <vhut3f-tel.ln1@banana.localnet>
References: <20180503140745.26588-1-kristian.evensen@gmail.com>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

In gmane.comp.security.firewalls.netfilter.devel Kristian Evensen <kristian.evensen@gmail.com> wrote:
> SKBs are assigned a conntrack entry before being passed to any NFQUEUEs,
> and if no entry is found then a new one is created. This behavior causes
> problems for some traffic patterns. For example, if two UDP packets
> to/from the same host (using the same ports) arrive at the "same" time,
> both are assigned a new conntrack entry. After the first packet have
> traversed all chains, the conntrack entry will be inserted into the
> global table. The second packet will then be dropped during the
> insertion step, as an entry for the same flow already exists. One type
> of application that frequently generates this traffic pattern, is DNS
> resolvers.

> This commit introduces a new function that checks, and potentially
> replaces, the conntrack entry for any additional "new" SKBs mapping to
> an existing flow. While not a perfect solution, there are still
> situations where to-be-dropped SKBs can slip through, the situations is
> improved considerably. On the routers I have used for testing, packets
> belonging to the same UDP flow are let through (when generating the
> traffic pattern described above). Without the change in this commit, all
> packets except the first one was dropped.

> With the change in this commit, a user can implement "perfect" solutions
> in user-space. An application can for example keep track of seen UDP
> flows, and then only release packets belonging to one flow when the
> entry has been created. Without the change, and SKB is stuck with the
> original conntrack entry.

PING
Any progress on this patch?

> Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
> ---
>  net/netfilter/nfnetlink_queue.c | 68 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 68 insertions(+)

[...]
