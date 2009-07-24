From: Hugo Miguel Mendes <hugo-m-mendes@ptinovacao.pt>
Subject: NTP server
Date: Fri, 24 Jul 2009 20:48:57 +0100
Message-ID: <47A7F67C62706041BC49DB7822B1C9DB34D79A8733@INOAVREX11.ptin.corpPT.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail6.ptinovacao.pt ([194.65.138.99]:4710 "EHLO
	owa.ptinovacao.pt" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbZGXTyf convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Jul 2009 15:54:35 -0400
Content-Language: pt-PT
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear all,

I'm running netfilter on a router operating OpenWRT Kamikaze 8.09, kernel 2.6.25.17.

I have two computers on the router LAN which are programmed to get the time from an NTP server. This NTP server has a load balancing mechanism, so the computer that responds to the NTP request is not the same to where was sent the request. So the response is blocked by netfilter, because that connection wasn't started from the LAN. But the NTP server always keeps the same ports and always listens on port 123. So if you make the request from port 1024 to the port 123 of the server the response will come from 123 to 1024.
To overcome this situation I figured that a Connection Tracking Helper module would overcome the situation. I made the module based on the IRC conntrack module. The expectations are correctily entered on the conntrack expectations table, but the response packets from the NTP server all die on the router. For a first try I'm only using a single computer making the NTP requests.

The module has the following key points:

init function:

static struct nf_conntrack_helper fcn __read_mostly;

static int __init nf_conntrack_fcn_init(void)
{
    int ret = 0;

    memset(&fcn, 0, sizeof(struct nf_conntrack_helper));

    fcn.name = "full_cone_nat";
    fcn.me = THIS_MODULE;
    fcn.max_expected = 1;
    fcn.timeout = 10*60;

    fcn.tuple.src.l3num = AF_INET;

    fcn.tuple.dst.protonum = IPPROTO_UDP;
    fcn.tuple.src.u.udp.port = htons(port);    //port variable initialized at module load time to 123

    fcn.help = fcn_help;

    ret = nf_conntrack_helper_register(&fcn);

    if (ret) {
        nf_conntrack_fcn_exit();
        return ret;
    }

    return 0;
}

help function

if (dir == IP_CT_DIR_REPLY)
        return NF_ACCEPT;

    spin_lock_bh(&nf_fcn_lock);

    exp = nf_ct_expect_alloc(ct);

    if(exp == NULL) {
        ret = NF_DROP;
        goto out;
    }

    tuple = &ct->tuplehash[!dir].tuple;

    nf_ct_expect_init(exp, tuple->src.l3num,
              NULL, &tuple->dst.u3,
                   IPPROTO_UDP, &tuple->src.u.udp.port,
                &tuple->dst.u.udp.port);

    nf_nat_fcn = rcu_dereference(nf_nat_fcn_hook);
    if (nf_nat_fcn && ct->status & IPS_NAT_MASK) {
        ret = nf_nat_fcn(skb, ctinfo, exp);
    }
    else {
        if (nf_ct_expect_related(exp) != 0) {
            ret = NF_DROP;
        }
        else {
            ret = NF_ACCEPT;
        }
    }

    nf_ct_expect_put(exp);

out:
    spin_unlock_bh(&nf_fcn_lock);
    return ret;
}

The nf_nat_fcn function:

    exp->saved_proto.udp.port = exp->tuple.dst.u.udp.port;
    exp->dir = IP_CT_DIR_REPLY;

    exp->expectfn = nf_nat_follow_master;

    for (port = ntohs(exp->saved_proto.udp.port); port != 0; port++) {
        exp->tuple.dst.u.udp.port = htons(port);
        if (nf_ct_expect_related(exp) == 0)
            break;
    }

    return NF_ACCEPT;

Any idea why this doesn't work?

Thanks for your time.

Best Regards.

Hugo Mendes
