From: Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH 00/12] Ethernet: Add and use ether_<type>_addr
	globals
Date: Thu, 5 Apr 2018 15:27:49 +0200
Message-ID: <e0ab9616-64fa-cdbc-7a77-7e25d70c1a52@nbd.name>
References: <cover.1522479607.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org,
	brcm80211-dev-list@cypress.com
To: Joe Perches <joe@perches.com>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	bridge@lists.linux-foundation.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Return-path: <bridge-bounces@lists.linux-foundation.org>
In-Reply-To: <cover.1522479607.git.joe@perches.com>
Content-Language: en-US
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

On 2018-03-31 09:05, Joe Perches wrote:
> There are many local static and non-static arrays that are used for
> Ethernet broadcast address output or comparison.
> 
> Centralize the array into a single separate file and remove the local
> arrays.
I suspect that for many targets and configurations, the local arrays
might actually be smaller than exporting a global. You have to factor in
not just the .text size, but the fact that referencing an exported
symbol needs a .reloc entry as well, which also eats up some space (at
least when the code is being built as module).

In my opinion, your series probably causes more bloat in common
configurations instead of reducing it.

You're also touching several places that could easily use
eth_broadcast_addr and eth_zero_addr. I think making those changes would
be more productive than what you did in this series.

- Felix
