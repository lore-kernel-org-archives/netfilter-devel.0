From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: ebtables: CONFIG_COMPAT: don't
 trust userland offsets
Date: Sun, 25 Feb 2018 20:08:00 +0100
Message-ID: <20180225190800.ejtbrzn6ssidi6u3@salvia>
References: <94eb2c0efc1e07b3450565848616@google.com>
	<20180219002415.18461-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: syzkaller-bugs@googlegroups.com, bridge@lists.linux-foundation.org,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <bridge-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20180219002415.18461-1-fw@strlen.de>
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

On Mon, Feb 19, 2018 at 01:24:15AM +0100, Florian Westphal wrote:
> We need to make sure the offsets are not out of range of the
> total size.
> Also check that they are in ascending order.
> 
> The WARN_ON triggered by syzkaller (it sets panic_on_warn) is
> changed to also bail out, no point in continuing parsing.
> 
> Briefly tested with simple ruleset of
> -A INPUT --limit 1/s' --log
> plus jump to custom chains using 32bit ebtables binary.

Also applied, thanks.
