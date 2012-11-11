From: Aft nix <aftnix@gmail.com>
Subject: Target extension with nf_hooks
Date: Sun, 11 Nov 2012 16:56:14 +0600
Message-ID: <CAGuaRCtEa2VGPb3-jYvuK9+t++L44xTeOm15xpsFXmzLHoui3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61398 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab2KKK4O (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Nov 2012 05:56:14 -0500
Received: by mail-ie0-f174.google.com with SMTP id k13so7799714iea.19
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Nov 2012 02:56:14 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Is there any technical difficulties associated with the following scenario:

1) its invoked with $iptables -t mangle -A PREROUTING -j MY_TARGET

2) My target module is initialized as :

static struct xt_target obsf_tg_reg __read_mostly = {

        .name = "OBSF",
        .family = NFPROTO_UNSPEC,
        .target = obsf_tg,
        .checkentry = obsf_tg_check,
        .targetsize = sizeof(struct xt_OBSF_tginfo),
        .me = THIS_MODULE,
};

static int __init obsf_tg_init(void)
{
    return xt_register_target(&obsf_tg_reg);
}

2) Now inside the module, it also registers a nf_hook:


static struct nf_hook_ops inward_obsf_ops __read_mostly = {
    .pf = NFPROTO_IPV4,
    .priority = 1,
    .hooknum = NF_INET_PRE_ROUTING,
    .hook = ibss_obsf_inward_begin,
};

/*
 * Module init and exit functions
 * No need ot worry about them
 */

static int __init ibss_obsf_inward_init(void)
{
    printk(KERN_ALERT "\nPacket_Inward module started ...");
    return nf_register_hook(&inward_obsf_ops);
}

My question is

a) Between ibss_obsf_inward_begin() and obsf_tg() who will be called first?

b) Does this design lead to any inconsistencies?

c) Should i register ibss_ofsf_inward_begin() with different hook ,
say NF_INET_LOCAL_INPUT?

Only example i could find inside 3.7.rc3 kernel tree is :

net/ipv4/ipt_CLUSTERIP.c:540

540 static struct nf_hook_ops cip_arp_ops __read_mostly = {
541         .hook = arp_mangle,
542         .pf = NFPROTO_ARP,
543         .hooknum = NF_ARP_OUT,
544         .priority = -1
545 };

I'm not sure i can do the same for ordinary netfilter module.


--
-aft
