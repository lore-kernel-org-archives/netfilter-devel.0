From: Aft nix <aftnix@gmail.com>
Subject: Re: no extension found for this protocol
Date: Mon, 24 Sep 2012 19:49:57 +0600
Message-ID: <CAGuaRCuk57_ZddVXU9ndOLsNjwACeX0tvCLg5UvA+OYzyANFww@mail.gmail.com>
References: <CAGuaRCvtBG4dn70f=gjkB_ep7LDtWn_eHZJ+2PVtU2sikS94AQ@mail.gmail.com>
	<alpine.LNX.2.01.1209241431310.12534@nerf07.vanv.qr>
	<CAGuaRCu2tFRhg2euL7UFKQmHzKAUFpZ90aa2nOs7niGeKJaMqg@mail.gmail.com>
	<alpine.LNX.2.01.1209241506300.17187@nerf07.vanv.qr>
	<CAGuaRCub-iGfVvAQZNErFQQMcV2NoMM_DMzU1CtbMD60EF3npg@mail.gmail.com>
	<alpine.LNX.2.01.1209241528230.18274@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34713 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab2IXNt5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:49:57 -0400
Received: by ieak13 with SMTP id k13so10844464iea.19
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Sep 2012 06:49:57 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1209241528230.18274@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 24, 2012 at 7:28 PM, Jan Engelhardt <jengelh@inai.de> wrote:
>
> On Monday 2012-09-24 15:14, Aft nix wrote:
>>>
>>> Specify the command you ran, and the _exact_ error message. There is
>>> no "No extension found for this protocol" string anywhere in the code
>>> to spot.
>>$iptables -t mangle -A PREROUTING -p udp --dport 9090 -j OBSF --key
>>"abc" --enc-type "arc4" --enc
>>$/usr/local/lib/xtables/libxt_OBSF.so : no "OBSF" extension found for
>>this protocol.
>>$iptables v1.4.15: unknown option "--key"
>
> (in libxt_OBSF.c): You do not have a _init function that actually
> registers obsf_target.

libxt_OBSF.c :

static struct xtables_target obsf_target = {
				.family  = NFPROTO_UNSPEC,
				.name    = "OBSF",
				.version = XTABLES_VERSION,
				.size    = XT_ALIGN(sizeof(struct xt_OBSF_tginfo)),
				.userspacesize = XT_ALIGN(sizeof(struct xt_OBSF_tginfo) -
sizeof(struct xt_obsf_priv *)),
				.help = OBSF_help,
				.print = OBSF_print,
				.save = OBSF_save,
				.x6_options = OBSF_opts,
};

static void __init(void)
{
	xtables_register_target(&obsf_target);
}

I do have a __init function.
-- 
-aft
