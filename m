From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Fri, 07 Jun 2002 09:31:12 +1000
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <E17G6im-0000FK-00@wagner.rustcorp.com.au>
References: <20020606220914.A14542@groar.org>
Cc: Mikkel Christiansen <mixxel@cs.auc.dk>,
	Mikkel Refsgaard Bech <mrb@cs.auc.dk>,
	Torben Vinther Schmidt <mariachi@cs.auc.dk>,
	Carsten Stiborg <stiborg@cs.auc.dk>,
	Emmanuel Fleury <fleury@cs.auc.dk>, netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Denis Ducamp <Denis.Ducamp@groar.org>
In-Reply-To: Your message of "Thu, 06 Jun 2002 22:09:14 +0200."
             <20020606220914.A14542@groar.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <20020606220914.A14542@groar.org> you write:
> > iptables -A FORWARD -p tcp -m state --state ESTABLISHED -j ACCEPT
> > iptables -A FORWARD -p tcp -m state --state NEW -j ACCEPT
> > iptables -A FORWARD -p tcp -j DROP
> 
> The meaning of --state NEW is the number one misunderstanding of netfilter's
> dynamic filtering (*).

Hi all,

	I disagree.  Consider the original complaint: that --state NEW
allowed TCP ACK packets through, which allowed an ack scan.  This
surprised the observers, who then blocked acks.

	Of course, you can still use SYNs to scan the network, so they
haven't actually won anything here, except that if their firewall
reboots, established connections will die.

	The confusion here comes from the "TCP connection" vs
"connection tracking connection" distinction, which is subtle and
usually harmless.

Hope that helps,
Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
