From: Dirk Morris <dmorris@neogenen.com>
Subject: NF_IP_PRE_ROUTING hook
Date: Tue, 8 Apr 2003 15:08:07 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030408150328.I60375-100000@neogenen.com>
References: <20030408215758.GA8715@home.tig-grr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20030408215758.GA8715@home.tig-grr.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


I have hacked up some hooks and targets over the past few months
They all seem to work fine except in the NF_IP_PRE_ROUTING table
(fine in FORWARD and POST ROUTING)

Is there something different about hooks/targets working there?
they are all accessing the network headers in the skb,
maybe those arent filled out until after PREROUTING?

they consitently cause a kernel panic, but its hard for me to see where.
Thanks for any help.

-dirk

//* */   dmorris   (* www.neogenen.com *)
main(){int _=0;for(;_!=1687193639&&putchar(" \
dn\nc@oge.m"[abs(_%11)]);_=(_*42913)+115127);}
