From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: "ip_conntrack_core: Frag of proto 17." error and memory leak?
Date: Sat, 20 Sep 2003 14:11:16 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1064059876.2500.54.camel@tux.rsn.bth.se>
References: <3F65EC33.2060906@wp.pl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter@tux.rsn.bth.se,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: c0g <c0g@wp.pl>
In-Reply-To: <3F65EC33.2060906@wp.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2003-09-15 at 18:43, c0g wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hi,
> I'm getting this error, my kern.log is flooded, it is logged many
> hundred of thousands times. I read in ip_conntrack_core.c it should
> "never happen" (so it's kind of assertion). Why does this assertion fail?
> 
> I'm using 2.4.22 kernel with CVS p-o-m 20030907. I'm using only
> following major netfilter patches:
> 
> TCPLAG.patch
> ipt_REJECT-fake-source.patch
> raw.patch

Are you using the NOTRACK target in raw/PREROUTING?

This is the only source of this I can see and it is indeed a bug. This
message shouldn't be printed for this case. It doesn't defrag packets
and calls get_tuple() for all packets, even the fragments and
get_tuple() barfs. This causes only the first fragment to be marked as
untracked and leaves the rest of the fragments to conntrack which tries
to defrag them but that won't succeed since conntrack will never see the
first packet. And thus the kernel keeps lots of fragments in memory
until they time out and are dropped.

We'll look into how to best solve this if this is what is causing the
problem for you.

-- 
/Martin
