From: Max Kellermann <max@duempel.org>
Subject: Re: nfsim problem with NAT
Date: Wed, 19 Jan 2005 00:32:25 +0100
Message-ID: <20050118233225.GA11615@roonstrasse.net>
References: <20050118231729.GA11445@roonstrasse.net>
	<41ED9B96.5010105@cookinglinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <41ED9B96.5010105@cookinglinux.org>
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

On 2005/01/19 00:28, Samuel Jean <sj-netfilter@cookinglinux.org> wrote:
> >14:iptables -t nat -A POSTROUTING -o eth1 -p tcp --dport 1720 -j SNAT 
> >--to-source 192.168.0.100
> > iptables: Invalid argument
> > iptables: command failed
> > Script failed at line 14: 
> > iptables failed
> 
> both userspace and kernelspace use same structure ?

What do you mean by that?

> NOTE: I use SVN iptables. but shouldn't matter. I think.

Just tried that. No change.

Max
