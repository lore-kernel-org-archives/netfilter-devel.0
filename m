From: Max Kellermann <max@duempel.org>
Subject: Re: [PATCH 2.6] Allow dynamic helper-port assignment
Date: Sun, 13 Feb 2005 18:34:02 +0100
Message-ID: <20050213173402.GA4688@roonstrasse.net>
References: <20050213165638.GM20269@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050213165638.GM20269@sunbeam.de.gnumonks.org>
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

On 2005/02/13 17:56, Harald Welte <laforge@netfilter.org> wrote:
> Ideally, we would actually have conntrack helpers be iptables targets,
> this way allowing totally dynamic assignemnt.  Maybe yet another
> pkttables todo.

Good idea.

The downside is, to use a helper, you have to explicitly configure
it. That is so easy currently - add the helper to the kernel, and it
just works (on the default ports, that is). But that's ok for me.

> Meanwhile, the following patch uses the same mechanism as CLUSTERIP:
> 
> Add port 2121 to ftp helper:
> 	echo "+2121" > /proc/net/ip_conntrack_helper/ftp
> 
> Remove port 6669 from irc helper:
> 	echo "-6669" > /proc/net/ip_conntrack_helper/irc
> 
> Show registered ports for amanda helper:
> 	cat /proc/net/ip_conntrack_helper/amanda

Why don't you use the existing /sys/module/XX/parameters/YY interface?
That includes static modules. We could even use a custom setter
function for the "port" property.

 cat /sys/module/ip_conntrack_irc/parameters/ports

That already works, it's just not writable (yet).

> If nobody complains, we should push this for 2.6.12.

*complain*

Why push a solution which will go away soon anyway to the mainstream
kernel? When people understand how to use that change, it's already
gone.

Max
