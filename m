From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] Fix possible oops in ipt_REDIRECT
Date: Mon, 27 Oct 2003 00:07:39 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031027000739.25c99485.davem@redhat.com>
References: <200310251728.56938.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
In-Reply-To: <200310251728.56938.bdschuym@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 25 Oct 2003 17:28:56 +0200
Bart De Schuymer <bdschuym@pandora.be> wrote:

> When a device doesn't have an IP address, as in ifconfig eth0 0.0.0.0, then
> dev->ip_ptr->ifa_list == NULL.

Indeed, fix looks good to me.

Applied, thanks Bart.
