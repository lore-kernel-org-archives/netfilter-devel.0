From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: SNAT of icmp: fragmentation-needed (fwd)
Date: Tue, 2 Jul 2002 12:57:20 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0207021253390.14697-100000@blackhole.kfki.hu>
References: <Pine.LNX.4.44.0207021245580.4796-100000@albert.ha-vel.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: <jakub@angel.cz>
In-Reply-To: <Pine.LNX.4.44.0207021245580.4796-100000@albert.ha-vel.cz>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2 Jul 2002 jakub@angel.cz wrote:

> I would like to SNAT icmp fragmentation-needed messages that have source
> address from private network range (RFC1918). Because these packets are
> part of valid TCP connection, they are processed by ip_conntrack module
> and cannot be SNATed...

Just to explain why it is required, one has to draw the topology:

                   MTU
                  small

    ----- router1 ---- router2 ----
routeable        private       routeable
addresses        addresses     addresses

Currently there is no way to solve the problem by netfilter.
As the raw table will be ready, it will make possible to solve it.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
