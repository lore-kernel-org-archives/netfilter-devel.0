From: Balazs Scheidler <bazsi@balabit.hu>
Subject: NAT, not doing route_me_harder?
Date: Wed, 26 Jun 2002 10:41:36 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020626084136.GA25908@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
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

I was wondering what the reason is for NAT not rerouting modified packets?

If anything important is modified by a mangle rule that affects routing, the
routing decision is automatically redone as this code fragment shows:

        ret = ipt_do_table(pskb, hook, in, out, &packet_mangler, NULL);
        /* Reroute for ANY change. */
        if (ret != NF_DROP && ret != NF_STOLEN && ret != NF_QUEUE
            && ((*pskb)->nh.iph->saddr != saddr
                || (*pskb)->nh.iph->daddr != daddr
                || (*pskb)->nfmark != nfmark
                || (*pskb)->nh.iph->tos != tos))
                return ip_route_me_harder(pskb) == 0 ? ret : NF_DROP;

NAT doesn't do anything like this. So given an SNAT rule changes the source
address in POSTROUTING, the routing tables are not looked up again, so
source address dependant policy routing rules are not applied.

It might not be the best to change this by default, but it could be
implemented by a match, e.g.

iptables -t nat -A POSTROUTING -p tcp -d 0/0 --dport 25 -m reroute -j SNAT --to-source 1.2.3.4

-m reroute would flag the packet as one which needs rerouting (using for
example a flag in nfcache). Packets flagged as such would be rerouted after
do_bindings() is called.

Opinions?

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
