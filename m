From: Patrick McHardy <kaber@trash.net>
Subject: Re: Deadlocks
Date: Tue, 22 Jun 2004 11:52:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40D80156.3090806@trash.net>
References: <20040609180909.GA11445@linuxace.com> <1087156709.11287.8.camel@ws> <20040615044723.GA16891@linuxace.com> <40CE95DE.9090703@trash.net> <20040617155946.GA28564@linuxace.com> <40D1C4BF.8070605@trash.net> <20040618171214.GA750@linuxace.com> <40D62FDB.8090904@trash.net> <20040622043129.GA15906@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20040622043129.GA15906@linuxace.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Phil Oester wrote:

> Thanks for the tip on the ip_nf_assert patch - I'd been running with debugging
> enabled but wondered why I never saw anything...
> 
> Now that I enabled debugging (for real), I hit this one a few hundred times
> per minute:
> 
> NF_IP_ASSERT: net/ipv4/netfilter/ip_conntrack_core.c:717(init_conntrack)

Yes, this assertion is bogus, I need to update the patch in pom-ng.
Just delete the ASSERTION, it tests for conntrack->master, which is
assigned two lines below.

Hopefully we get to see something more interesting ..

Regards
Patrick
