From: Phil Oester <kernel@linuxace.com>
Subject: Re: Deadlocks
Date: Mon, 21 Jun 2004 21:31:29 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040622043129.GA15906@linuxace.com>
References: <20040609180909.GA11445@linuxace.com> <1087156709.11287.8.camel@ws> <20040615044723.GA16891@linuxace.com> <40CE95DE.9090703@trash.net> <20040617155946.GA28564@linuxace.com> <40D1C4BF.8070605@trash.net> <20040618171214.GA750@linuxace.com> <40D62FDB.8090904@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <40D62FDB.8090904@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jun 21, 2004 at 02:46:19AM +0200, Patrick McHardy wrote:
> Not sure either, but it's a start. Have you tried running the box with
> netfilter debugging enabled ? Please also apply the ip_nf_assert fix
> from pom-ng, otherwise CONFIG_NETFILTER_DEBUG won't help much.
> BTW: Is the box a router or is conntrack running on the FTP server
> itself ?

The box is a router -- the ftp server is a separate box.

Thanks for the tip on the ip_nf_assert patch - I'd been running with debugging
enabled but wondered why I never saw anything...

Now that I enabled debugging (for real), I hit this one a few hundred times
per minute:

NF_IP_ASSERT: net/ipv4/netfilter/ip_conntrack_core.c:717(init_conntrack)

which is in this chunk of code:

        if (expected) {
                DEBUGP("conntrack: expectation arrives ct=%p exp=%p\n",
                        conntrack, expected);
                /* Welcome, Mr. Bond.  We've been expecting you... */
                IP_NF_ASSERT(master_ct(conntrack));
                __set_bit(IPS_EXPECTED_BIT, &conntrack->status);
                conntrack->master = expected;
                expected->sibling = conntrack;
                LIST_DELETE(&ip_conntrack_expect_list, expected);
                expected->expectant->expecting--;
                nf_conntrack_get(&master_ct(conntrack)->infos[0]);
        }


Other than being mildly annoying, this doesn't explain the deadlocks,
so I'll let it run for a few more days...

Phil
