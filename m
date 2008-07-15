From: "Kevin Sookocheff" <kevin.sookocheff@gmail.com>
Subject: Re: Invalid size of target
Date: Tue, 15 Jul 2008 08:47:45 -0400
Message-ID: <48bd37870807150547r6211bb9bp74c1d3490c019000@mail.gmail.com>
References: <48bd37870807141225k7c8ed4c2o747bff281792b13f@mail.gmail.com>
	 <48bd37870807141226n4a5a8b8fwf1b5284d42b5a7b5@mail.gmail.com>
	 <alpine.LNX.1.10.0807142204050.13215@fbirervta.pbzchgretzou.qr>
	 <48bd37870807141336u3f821c32s5f9cb9ee0fe94370@mail.gmail.com>
	 <alpine.LNX.1.10.0807142313290.13215@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:39652 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253AbYGOMrt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:47:49 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1663246nfc.21
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Jul 2008 05:47:45 -0700 (PDT)
In-Reply-To: <alpine.LNX.1.10.0807142313290.13215@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Great, that worked wonderfully!

So, just out of curiosity and for completeness, do you know why this
error would present itself only on SMP kernels?  I'm presuming it has
something to do with what version of IPTables is compiled in the
kernel.

We need the extra .targetsize statement on kernel 2.6.20-1.2320.fc5smp
on an i686 but don't need it on a 2.6.15-1.2054_FC5 kernel on an i686.

Thanks for your help!

Kevin




On Mon, Jul 14, 2008 at 5:15 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Monday 2008-07-14 22:36, Kevin Sookocheff wrote:
>
>>OK.  That makes sense for what I'm seeing.
>>
>>What I have is the following struct:
>>
>>struct ipt_CSUM_info {
>>    u_int32_t       address;
>>    u_int8_t        addressCount;
>>    u_int16_t       port;
>>    u_int8_t        portCount;
>>    u_int8_t        interval;
>>    u_int8_t        maxFailures;
>>};
>
> There's padding involved between the 8/16.
>
>>and I register the following target in lib*.c:
>>
>>static struct iptables_target CSUM = {
>>    .next       = NULL,
>
> This line not needed.
>
>>    .name       = "CSUM",
>>    .version    = NETFILTER_VERSION,
>
> NETFILTER_VERSION?
>
>>    .size       = IPT_ALIGN(sizeof(struct ipt_CSUM_info)),
>>    .userspacesize  = IPT_ALIGN(sizeof(struct ipt_CSUM_info)),
>>    .help       = &help,
>>    .parse      = &parse,
>>    .final_check    = &final_check,
>>    .print      = &print,
>>    .save       = &save,
>>    .extra_opts = opts
>>};
>
> Seems like a really old module.
>
>>void _init(void)
>>{
>>    register_target(&CSUM);
>>}
>>
>>Then I try and register the target in the kernel C file which is where
>>it seems to fail:
>>
>>static struct ipt_target ipt_CSUM = {
>>    .name       = "CSUM",
>>    .target     = ipt_csum_target,
>>    .checkentry = ipt_csum_checkentry,
>>};
>
> Well well, where is .targetsize? No wonder it prints 0 != 12 ;-)
>
>>static int __init init(void)
>>{
>>    ipt_char_major = register_chrdev(0,"ipt_CSUM_char",&char_fops);
>>    init_timer(&csum_timer);
>>    csum_timer.function = timer_callback;
>>    init_waitqueue_head(&inqMSG);
>>    printk("register target\n");
>>    return ipt_register_target(&ipt_CSUM);
>>}
>>
>
