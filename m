From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] Die to NOTRACK/TRACE, long live MARK!
Date: Sun, 23 May 2004 19:00:49 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40B0D8C1.6040209@trash.net>
References: <Pine.LNX.4.33.0405211416341.8045-100000@blackhole.kfki.hu>	 <40AF6A60.70406@trash.net> <1085302540.969.51.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Philip Craig <philipc@snapgear.com>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1085302540.969.51.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Martin Josefsson wrote:

> Nice, I hope you succeed. We also need to rearrange struct ip_conntrack
> so often updated fields aren't sharing the same cacheline as mostly read
> fields. That and adding more test_bit() before we set_bit() (or
> something similar) will bring down the cache-trashing we have right now,
> especially on SMP.

I will make a test_bit patch on top of my memsave-patches (which are
on top of Joszef's conntrack patches). When we rearrange struct
ip_conntrack we should also try to get rid of the holes in the
structure, which are responsible for approximately 20bytes of wasted
memory.

Regards
Patrick
