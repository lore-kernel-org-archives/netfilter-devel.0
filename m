From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] Fix hang on netfilter module unload
Date: Tue, 15 Mar 2005 11:46:02 -0800
Message-ID: <20050315194602.GA3487@linuxace.com>
References: <20050315050641.GA334@linuxace.com>
	<20050315172330.GA3130@linuxace.com> <4237369D.8080408@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, pablo@eurodev.net
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4237369D.8080408@trash.net>
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

On Tue, Mar 15, 2005 at 08:25:17PM +0100, Patrick McHardy wrote:
> I guess by leaking you mean doesn't pull them of the receive queue.
> Anyhow, the reference to the conntrack is dropped before packets
> are delivered to the protocols, so this can't be the reason. Do
> you have a reproducable test-case ?

On a box with modular iptables, a DHCP interface, and NetworkManager
set to run on boot:

1) boot box
2) verify ip_conntrack_count and wc -l /proc/net/ip_conntrack are both 0
3) NetworkManager stop
4) ifdown eth0
5) NetworkManager start

NM seems to never release the reference to at least one of its
conntracks (sometimes more than one).  At this point, a conntrack
has been cleaned from lists but not destroyed, and the counts
shown in #2 will not match.  

It seems to me we should still track conntracks which are cleaned
but not yet destroyed, no?  Isn't it possible for a malicious
app to screw us here by intentionally getting the counts out of
whack?

Phil
