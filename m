From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: More on LIST_DELETE message with kernels 2.4.23 through 2.4.25
Date: Thu, 1 Apr 2004 22:52:02 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404012250440.9369-100000@filer.marasystems.com>
References: <OF4647B020.55BDAE17-ON48256E69.0010A57F@legend.com.cn>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: wanghtb@legend.com.cn
In-Reply-To: <OF4647B020.55BDAE17-ON48256E69.0010A57F@legend.com.cn>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 1 Apr 2004 wanghtb@legend.com.cn wrote:

> And I think the compiling direction 
>  "#ifndef CONFIG_IP_NF_NAT_LOCAL"
> maybe not need, since in any situation, we should not 
> use ip_conntrack_reply() to change a confirmed ct, which 
> will make ct's hash value changed,  and make LIST_DELETE() dump a 
> warning: this entry is not in the correct bucket list :-)

This can only happen if CONFIG_IP_NF_NAT_LOCAL is not defined.

If it is defined then NAT properly registers mappings in all directions,
and the first (original) part of the if statement makes sure the packet is
not NAT:ed again on local->local traffic.

Regards
Henrik
