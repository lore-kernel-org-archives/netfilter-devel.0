From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Invalid size of target
Date: Mon, 14 Jul 2008 23:15:18 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807142313290.13215@fbirervta.pbzchgretzou.qr>
References: <48bd37870807141225k7c8ed4c2o747bff281792b13f@mail.gmail.com>  <48bd37870807141226n4a5a8b8fwf1b5284d42b5a7b5@mail.gmail.com>  <alpine.LNX.1.10.0807142204050.13215@fbirervta.pbzchgretzou.qr>
 <48bd37870807141336u3f821c32s5f9cb9ee0fe94370@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kevin Sookocheff <kevin.sookocheff@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57661 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbYGNVPU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jul 2008 17:15:20 -0400
In-Reply-To: <48bd37870807141336u3f821c32s5f9cb9ee0fe94370@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-07-14 22:36, Kevin Sookocheff wrote:

>OK.  That makes sense for what I'm seeing.
>
>What I have is the following struct:
>
>struct ipt_CSUM_info {
>    u_int32_t       address;
>    u_int8_t        addressCount;
>    u_int16_t       port;
>    u_int8_t        portCount;
>    u_int8_t        interval;
>    u_int8_t        maxFailures;
>};

There's padding involved between the 8/16.

>and I register the following target in lib*.c:
>
>static struct iptables_target CSUM = {
>    .next       = NULL,

This line not needed.

>    .name       = "CSUM",
>    .version    = NETFILTER_VERSION,

NETFILTER_VERSION?

>    .size       = IPT_ALIGN(sizeof(struct ipt_CSUM_info)),
>    .userspacesize  = IPT_ALIGN(sizeof(struct ipt_CSUM_info)),
>    .help       = &help,
>    .parse      = &parse,
>    .final_check    = &final_check,
>    .print      = &print,
>    .save       = &save,
>    .extra_opts = opts
>};

Seems like a really old module.

>void _init(void)
>{
>    register_target(&CSUM);
>}
>
>Then I try and register the target in the kernel C file which is where
>it seems to fail:
>
>static struct ipt_target ipt_CSUM = {
>    .name       = "CSUM",
>    .target     = ipt_csum_target,
>    .checkentry = ipt_csum_checkentry,
>};

Well well, where is .targetsize? No wonder it prints 0 != 12 ;-)

>static int __init init(void)
>{
>    ipt_char_major = register_chrdev(0,"ipt_CSUM_char",&char_fops);
>    init_timer(&csum_timer);
>    csum_timer.function = timer_callback;
>    init_waitqueue_head(&inqMSG);
>    printk("register target\n");
>    return ipt_register_target(&ipt_CSUM);
>}
>
