From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: bridge: ebt_among: add missing
 match size checks
Date: Sun, 25 Feb 2018 20:04:45 +0100
Message-ID: <20180225190445.ixdsjfe6ri57nlpe@salvia>
References: <001a1144b3d60d448f0565848646@google.com>
	<20180219020145.30899-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
	bridge@lists.linux-foundation.org, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <bridge-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20180219020145.30899-1-fw@strlen.de>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/bridge>,
	<mailto:bridge-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/bridge/>
List-Post: <mailto:bridge@lists.linux-foundation.org>
List-Help: <mailto:bridge-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/bridge>,
	<mailto:bridge-request@lists.linux-foundation.org?subject=subscribe>
Sender: bridge-bounces@lists.linux-foundation.org
Errors-To: bridge-bounces@lists.linux-foundation.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Feb 19, 2018 at 03:01:45AM +0100, Florian Westphal wrote:
> ebt_among is special, it has a dynamic match size and is exempt
> from the central size checks.
> 
> Therefore it must check that the size of the match structure
> provided from userspace is sane by making sure em->match_size
> is at least the minimum size of the expected structure.
> 
> The module has such a check, but its only done after accessing
> a structure that might be out of bounds.
> 
> tested with: ebtables -A INPUT ... \
> --among-dst fe:fe:fe:fe:fe:fe
> --among-dst fe:fe:fe:fe:fe:fe --among-src fe:fe:fe:fe:ff:f,fe:fe:fe:fe:fe:fb,fe:fe:fe:fe:fc:fd,fe:fe:fe:fe:fe:fd,fe:fe:fe:fe:fe:fe
> --among-src fe:fe:fe:fe:ff:f,fe:fe:fe:fe:fe:fa,fe:fe:fe:fe:fe:fd,fe:fe:fe:fe:fe:fe,fe:fe:fe:fe:fe:fe

Applied, thanks Florian.
