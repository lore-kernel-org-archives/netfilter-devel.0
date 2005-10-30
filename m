From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_conntrack_lock not readlocked
Date: Sun, 30 Oct 2005 16:37:06 +0100
Message-ID: <4364E8A2.60603@trash.net>
References: <2497.194.242.39.2.1130240392.squirrel@webmail.piekna.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Daniel Chojecki <boka@piekna.pl>
In-Reply-To: <2497.194.242.39.2.1130240392.squirrel@webmail.piekna.pl>
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

Daniel Chojecki wrote:
> Hi !
> 
> I have a firewall on Dell 1850 (3353540k of RAM) with:
> 
> - vanilla kernel: 2.4.31 with openwall patches - version 1 and pptp. -
> iptables 1.3.3
> - patch-o-matic-ng-20050904
> 
> Errors in /var/log/messages occurs when users (approx. 320) use internet
> and dmz connection.
> 
> Oct 21 08:24:06 router kernel: ASSERT ip_conntrack_core.c:94
> &ip_conntrack_lock readlocked
> Oct 21 08:24:06 router kernel: ASSERT ip_conntrack_core.c:94
> &ip_conntrack_lock readlocked

You could try to get a backtrace by replacing the printk
in MUST_BE_READ_WRITE_UNLOCKED (include/linux/netfilter_ipv4/lockhelp.h)
by a BUG().
