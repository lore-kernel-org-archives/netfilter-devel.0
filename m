From: "Kevin Sookocheff" <kevin.sookocheff@gmail.com>
Subject: Re: Invalid size of target
Date: Mon, 14 Jul 2008 16:36:56 -0400
Message-ID: <48bd37870807141336u3f821c32s5f9cb9ee0fe94370@mail.gmail.com>
References: <48bd37870807141225k7c8ed4c2o747bff281792b13f@mail.gmail.com>
	 <48bd37870807141226n4a5a8b8fwf1b5284d42b5a7b5@mail.gmail.com>
	 <alpine.LNX.1.10.0807142204050.13215@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:25462 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877AbYGNUhB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jul 2008 16:37:01 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1562830nfc.21
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Jul 2008 13:36:56 -0700 (PDT)
In-Reply-To: <alpine.LNX.1.10.0807142204050.13215@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

OK.  That makes sense for what I'm seeing.

What I have is the following struct:

struct ipt_CSUM_info {
    u_int32_t       address;
    u_int8_t        addressCount;
    u_int16_t       port;
    u_int8_t        portCount;
    u_int8_t        interval;
    u_int8_t        maxFailures;
};

and I register the following target in lib*.c:

static struct iptables_target CSUM = {
    .next       = NULL,
    .name       = "CSUM",
    .version    = NETFILTER_VERSION,
    .size       = IPT_ALIGN(sizeof(struct ipt_CSUM_info)),
    .userspacesize  = IPT_ALIGN(sizeof(struct ipt_CSUM_info)),
    .help       = &help,
    .parse      = &parse,
    .final_check    = &final_check,
    .print      = &print,
    .save       = &save,
    .extra_opts = opts
};

void _init(void)
{
    register_target(&CSUM);
}

Then I try and register the target in the kernel C file which is where
it seems to fail:

static struct ipt_target ipt_CSUM = {
    .name       = "CSUM",
    .target     = ipt_csum_target,
    .checkentry = ipt_csum_checkentry,
};

static int __init init(void)
{
    ipt_char_major = register_chrdev(0,"ipt_CSUM_char",&char_fops);
    init_timer(&csum_timer);
    csum_timer.function = timer_callback;
    init_waitqueue_head(&inqMSG);
    printk("register target\n");
    return ipt_register_target(&ipt_CSUM);
}




On Mon, Jul 14, 2008 at 4:07 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Monday 2008-07-14 21:26, Kevin Sookocheff wrote:
>
>>Hi everyone,
>>
>>I am having a problem developing an IPTables module.
>>
>>I get the following error (CSUM is the name of my module):
>>
>>ip_tables: CSUM target: invalid size 0 != 12
>>
>>The first question is why this error appears,
>
> Because your xt_CSUM.c file and libxt_CSUM.c do not agree on
> the private structure (size).
>
>>and why does it only appear for SMP kernels?
>
> Perhaps you only have a specific change in an SMP kernel?
> Or maybe because your private structure contains bad members.
> Nobody knows until code is seen.
>
> Read more about the process in
> http://jengelh.medozas.de/documents/Netfilter_Modules.pdf
>
