From: Patrick Schaaf <bof@bof.de>
Subject: Re: netfilter language
Date: Sun, 20 Apr 2003 21:50:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030420195012.GB1003@oknodo.bof.de>
References: <200304181524.44951.fabrice@netfilter.org> <20030418113906.98028.qmail@web13906.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott MacKay <scottmackay@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20030418113906.98028.qmail@web13906.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

>     I was wondering, can C++ be used in developing
> netfilter modules, or is it really limited more to C? 

ANY kernel development is limited to C - Gnu gcc, to be exact.

> Also, are there any references to the order
> in which my work would be called?

See the definition of 'enum nf_ip_hook_priorities' in the file
include/linux/netfilter_ipv4.h. These go into the 'priority' field
of the 'struct nf_hook_ops' (declaration in include/linux/netfilter.h).

You define such a 'struct nf_hook_ops', and pass it to nf_register_hook(),
in your module initialization code.

> Because of it's nature, I would need to be called before any other
> handler module (especially conn track).

Just use a priority numerically lower than -200 (NF_IP_PRI_CONNTRACK).

best regards
  Patrick
