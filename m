From: pablo neira <pablo@eurodev.net>
Subject: ip_conntrack_get
Date: Wed, 12 Nov 2003 00:06:11 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FB16B63.8070603@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi everyone,

I've been for almost two weeks trying to understand netfilter code, at this point 
I'm trying to understand conntrack table code.

I have a problem with how conntrack manages the ip_conntrack_info stuff.

>From ip_conntrack_core.c

398 <http://lxr.linux.no/source/net/ipv4/netfilter/ip_conntrack_core.c#L398> __ip_conntrack_get <http://lxr.linux.no/ident?i=__ip_conntrack_get>(struct nf_ct_info <http://lxr.linux.no/ident?i=nf_ct_info> *nfct, enum ip_conntrack_info <http://lxr.linux.no/ident?i=ip_conntrack_info> *ctinfo)
399 <http://lxr.linux.no/source/net/ipv4/netfilter/ip_conntrack_core.c#L399> {
400 <http://lxr.linux.no/source/net/ipv4/netfilter/ip_conntrack_core.c#L400>         struct ip_conntrack <http://lxr.linux.no/ident?i=ip_conntrack> *ct
401 <http://lxr.linux.no/source/net/ipv4/netfilter/ip_conntrack_core.c#L401>                 = (struct ip_conntrack <http://lxr.linux.no/ident?i=ip_conntrack> *)nfct->master <http://lxr.linux.no/ident?i=master>;

I don't understand that casting at the line 400th/401th.

This is the definition of the structure nf_ct_info:

>From skbuff.h

92 <http://lxr.linux.no/source/include/linux/skbuff.h#L92> struct nf_ct_info <http://lxr.linux.no/ident?i=nf_ct_info> {
93 <http://lxr.linux.no/source/include/linux/skbuff.h#L93>         struct nf_conntrack <http://lxr.linux.no/ident?i=nf_conntrack> *master <http://lxr.linux.no/ident?i=master>;
94 <http://lxr.linux.no/source/include/linux/skbuff.h#L94> };

And the definition of nf_conntrack is:

87 <http://lxr.linux.no/source/include/linux/skbuff.h#L87> struct nf_conntrack <http://lxr.linux.no/ident?i=nf_conntrack> {
88 <http://lxr.linux.no/source/include/linux/skbuff.h#L88>         atomic_t <http://lxr.linux.no/ident?i=atomic_t> use;
89 <http://lxr.linux.no/source/include/linux/skbuff.h#L89>         void (*destroy)(struct nf_conntrack <http://lxr.linux.no/ident?i=nf_conntrack> *);
90 <http://lxr.linux.no/source/include/linux/skbuff.h#L90> };

Actually nf_conntrack doesn't look like ip_conntrack structure anyway.

I also don't understand the way ctinfo is calculate. This stuff...

403 <http://lxr.linux.no/source/net/ipv4/netfilter/ip_conntrack_core.c#L403>         *//* ctinfo is the index of the nfct inside the conntrack *//*
404 <http://lxr.linux.no/source/net/ipv4/netfilter/ip_conntrack_core.c#L404>         *ctinfo = nfct - ct->infos;


Don't blame me if it's obvious for you, I'm just a guy trying to understand a really 
really nice piece of code. Thanks!

cheers,
Pablo
