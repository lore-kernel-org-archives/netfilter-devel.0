From: "David S. Miller" <davem@redhat.com>
Subject: Re: Per site de-window-scaling
Date: Thu, 2 Sep 2004 13:17:15 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040902131715.7b83805f.davem@redhat.com>
References: <20040902120144.0b811b73@dell_ss3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Stephen Hemminger <shemminger@osdl.org>
In-Reply-To: <20040902120144.0b811b73@dell_ss3.pdx.osdl.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2 Sep 2004 12:01:44 -0700
Stephen Hemminger <shemminger@osdl.org> wrote:

> Is there a simple way with netfilter to do per-site TCP SYN mangling
> to remove the window scale option?  That way sites that have window-scale
> corrupting firewalls could be blacklisted.

We could make this a routing metric, RTAX_MAX_WINDOW or something.
