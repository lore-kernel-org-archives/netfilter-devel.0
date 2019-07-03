Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48C81C06511
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 10:43:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E477218A0
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 10:43:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="Mo7L+Un5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfGCKnm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 06:43:42 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51152 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfGCKnl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 06:43:41 -0400
Received: by mail-wm1-f65.google.com with SMTP id n9so1694832wmi.0
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Jul 2019 03:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UsJdfQ3kFOEpjq3npj0/cKJVQ/CAeYwFwNGHz+UuQEE=;
        b=Mo7L+Un5qawi0Ud2xyzwa+vtDRNMAl2JlQnhTgT+jKVPdep728lSG1VOlDolRBR32z
         o9CIihoj0ORs/0mlGJYg/eBM84SjBA5/FrNSdCsz0OUnqF6LjNVE6pi6Wp6uZGMYfGfN
         kSSvZZxKVdNenN48LGfCgScJ3VzwuB3PcUGxCbUcCIjmv9B3I0yPJ7USlI1awB/+V6LQ
         GDB3TN01fDA9cI4fmdidUm4LK3wmfhv6/fyIMcEpHGSdoSk9TnGAotu+eR36P1QOA6BG
         J6vpj7PsTmBeGmrcJ2esm4S1fpF0KZ74ZGMNhEsGIfsP8pBQfZCvcLi26E2TEyFtwNP6
         6tlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UsJdfQ3kFOEpjq3npj0/cKJVQ/CAeYwFwNGHz+UuQEE=;
        b=E55ldzZkb3Lppw2GfCRrPy0ustVpSfwbS2ddJs2i/gcKdm9yjgDjxtcKEtJSC+ijFf
         kgeFOCrtqG3eae24kO6UZLjs+fvGTQcM7z6DnrviZwFSwX8AFxXVPgdMDMZ7pTgyk8Wq
         ilBpxEF/vKm+/entEZfvHwM50aR3a0N5oq6Bp6g2jsQtfYQW+jmObCZ/VL0MfxNAsIcD
         wIo/RY+pvy6HTuucoRSnndrsBxuFA2+/RSLIiYFONdCsViWuBmludABB6C7M8+UoEnjN
         gEE/dY8pCwyrdR0LAhubkvGSTiwrpwonFooCo27P7g0LqpJhhvP12uWPaINw1Z4od9vA
         DWmg==
X-Gm-Message-State: APjAAAVh3iTpdIuDFgJa8lrvdwnoqRiNMYZ7qyQNlWE9hqkX9hq3yT7J
        f4qy32KWQvVa1J7mp0WqB3yqbw==
X-Google-Smtp-Source: APXvYqyKM5q4kA/2N5Nl1bUVzdA5jHOFGeHjEnp+NM9nCJ5f+TRg/STP5PpMxj7IEA1K54O+G3CXGA==
X-Received: by 2002:a1c:e356:: with SMTP id a83mr7928808wmh.38.1562150619486;
        Wed, 03 Jul 2019 03:43:39 -0700 (PDT)
Received: from localhost (ip-213-220-235-213.net.upcbroadband.cz. [213.220.235.213])
        by smtp.gmail.com with ESMTPSA id l11sm1647582wrw.97.2019.07.03.03.43.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 03:43:39 -0700 (PDT)
Date:   Wed, 3 Jul 2019 12:43:38 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        santosh@chelsio.com, madalin.bucur@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com,
        saeedm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        cphealy@gmail.com
Subject: Re: [PATCH net-next 04/12] net: sched: add tcf_block_setup()
Message-ID: <20190703104338.GV2250@nanopsycho>
References: <20190620194917.2298-1-pablo@netfilter.org>
 <20190620194917.2298-5-pablo@netfilter.org>
 <20190621171603.GF2414@nanopsycho.orion>
 <20190625083154.jfzhh22zsl3fu2ik@salvia>
 <20190626121256.GA2424@nanopsycho>
 <20190626131626.ihkjqvs2iciski2o@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626131626.ihkjqvs2iciski2o@salvia>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Wed, Jun 26, 2019 at 03:16:26PM CEST, pablo@netfilter.org wrote:
>On Wed, Jun 26, 2019 at 02:12:56PM +0200, Jiri Pirko wrote:
>> Tue, Jun 25, 2019 at 10:31:54AM CEST, pablo@netfilter.org wrote:
>> >On Fri, Jun 21, 2019 at 07:16:03PM +0200, Jiri Pirko wrote:
>> >> Thu, Jun 20, 2019 at 09:49:09PM CEST, pablo@netfilter.org wrote:
>> >> 
>> >> [...]
>> >> 
>> >> > 
>> >> >+static LIST_HEAD(tcf_block_cb_list);
>> >> 
>> >> I still don't like the global list. Have to go throught the code more
>> >> carefully, but why you can't pass the priv/ctx from tc/netfilter. From
>> >> tc it would be tcf_block as it is now, from netfilter something else.
>> >
>> >This tcf_block_cb_list should go away at some point, once drivers know
>> >how to deal with multiple subsystems using the setup block
>> >infrastructure. As I said in my previous email, only one can set up
>> >the block at this stage, the ones coming later will hit busy.
>> 
>> The driver should know if it can bind or is busy. Also, the bind cmd
>> should contain type of binder (tc/nft/whatever) or perhaps rather binder
>> priority (according to the hook order in rx/tx).
>
>OK, so I see two possible paths then:
>
>#1 Add global list and allow one single subsystem to bind by now. Then
>   later, in a follow up patchset. Add binder type and priority once
>   there is a driver that can handle the three subsystems, remove
>   this global list and each driver deals/knows what to do from the
>   binder path.
>
>#2 Remove the global list now, each driver maintains a list of flow blocks
>   internally, allow one single flow block by now. This will need a bit more
>   code, since there will be code in the driver to maintain the list of
>   existing flow blocks, per driver, instead of global. So it will be
>   a per-driver global local to check if there is a flow block with
>   this [ cb, cb_ident ] already in place.
>
>#1 is almost ready - it's this batch :-) -  then #2 may need more code -
>this batch is slightly large.
>
>I understand though that path #2 may make it easier for the first
>driver client allowing for the three subsystems to bind.
>
>Let me know what path your prefer.

I definitelly prefer #2. Thanks!


>
>Thanks for reviewing.
