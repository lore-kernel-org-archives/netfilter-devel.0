From: Patrick Schaaf <bof@bof.de>
Subject: Re: about "struct ct_foo_info" in hacking howto
Date: Fri, 28 Jun 2002 08:43:33 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020628084333.K2890@oknodo.bof.de>
References: <02062812013300.10824@luoqiang>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: luoqiang <luoqiang@ict.ac.cn>
Content-Disposition: inline
In-Reply-To: <02062812013300.10824@luoqiang>; from luoqiang@ict.ac.cn on Fri, Jun 28, 2002 at 12:01:33PM +0800
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

>                        /* save information important for NAT in
>                                ct->help.ct_foo_info;   */
>                                ~~~~~~~~~~~~~~~~~~~~here!!
> 
> but in ip_conntrack.help,there is no member ct_foo_info in union help.

The "foo" was an _example_, of course it is not in the real codebase.
It stands for a data structure that is defined anew for each helper.

> how can I do? Fill in ct->nat.info?

Define your own helper specific 'struct ct_XXX_info', and put that into
the definition of the ct->help union type (found somewhere under
include/linux/netfilter_ipv4/ - grep is your friend, as always)

best regards
  Patrick
