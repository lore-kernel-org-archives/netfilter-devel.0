From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Oops in replace_in_hashes (ip_net_core.c) 2.4.19
Date: 01 Jul 2003 23:05:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1057093550.720.58.camel@tux.rsn.bth.se>
References: <S261808AbTGAJfh/20030701093537Z+14616@vger.kernel.org>
	 <20030701.024732.71580915.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: mikesmith1@btconnect.com, linux-net@vger.kernel.org,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
In-Reply-To: <20030701.024732.71580915.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2003-07-01 at 11:47, David S. Miller wrote:

> I believe 2.4.21 has a fix for this, but the netfilter
> experts will know better.

(Dave, it's netfilter-devel@lists.netfilter.org)
(to the rest, the original report can be found on linux-net)

It looks like list-corruption.

ip_conntrack_core.c:665
byipsproto[ipsprotohash].next points into space.

I can't see anything obvious right now, my eyelids are very heavy so
I'll continue looking tomorrow.

There's a small possibility that this is caused by the modify-after-free
bug that's fixed in 2.4.21 (but unfortunately introduced some
refcounting bugs, patches are on the way to Dave, they can be found in
netfilter patch-o-matic as well).

-- 
/Martin
