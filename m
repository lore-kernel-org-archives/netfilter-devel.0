Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF55C64E7B
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Nov 2020 20:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA5692067C
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Nov 2020 20:53:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="hKzEVDAv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729338AbgK3Uxk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Nov 2020 15:53:40 -0500
Received: from mx1.riseup.net ([198.252.153.129]:32892 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728687AbgK3Uxk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Nov 2020 15:53:40 -0500
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Nov 2020 15:53:40 EST
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4ClHHk43FnzFdtk;
        Mon, 30 Nov 2020 12:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1606768998; bh=2TrR6qhfB28okYAQiXaM6v9vTZKmiOKY9zFwfDICNkg=;
        h=Subject:To:References:From:Cc:Date:In-Reply-To:From;
        b=hKzEVDAvbi34/X1muXzxjhCIACJcmzIXLZpM9KAuckk5va7pc6AzxdMzhd17o81MB
         dj1zTo0hQAlxZtL0/ZZR5ScVoRakBn56uS6OabHCNnvOgSY+WWr2bYkudggGwZ019P
         CPB/jJTSZBSIRML+ODGMmEtnTuIOqgz+cISYHN2s=
X-Riseup-User-ID: 3E1DFFE6E5BFEB4B38BC316D3ECAD2CA427BAF370050E515ED2D56EEF11564E8
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 4ClHHc2vkdzJqcY;
        Mon, 30 Nov 2020 12:43:08 -0800 (PST)
Subject: Re: [nft PATCH] json: echo: Speedup seqnum_to_json()
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>
References: <20201120191640.21243-1-phil@nwl.cc>
 <20201121121724.GA21214@salvia> <20201122235612.GP11766@orbyte.nwl.cc>
From:   "Jose M. Guisado" <guigom@riseup.net>
Cc:     netfilter-devel@vger.kernel.org, Derek Dai <daiderek@gmail.com>
Message-ID: <62770c7d-8c44-e50a-a1dd-9829e660e499@riseup.net>
Date:   Mon, 30 Nov 2020 21:43:04 +0100
MIME-Version: 1.0
In-Reply-To: <20201122235612.GP11766@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 23/11/20 0:56, Phil Sutter wrote:
> Hi,
> 
> On Sat, Nov 21, 2020 at 01:17:24PM +0100, Pablo Neira Ayuso wrote:
>> On Fri, Nov 20, 2020 at 08:16:40PM +0100, Phil Sutter wrote:
>>> Derek Dai reports:
>>> "If there are a lot of command in JSON node, seqnum_to_json() will slow
>>> down application (eg: firewalld) dramatically since it iterate whole
>>> command list every time."
>>>
>>> He sent a patch implementing a lookup table, but we can do better: Speed
>>> this up by introducing a hash table to store the struct json_cmd_assoc
>>> objects in, taking their netlink sequence number as key.
>>>
>>> Quickly tested restoring a ruleset containing about 19k rules:
>>>
>>> | # time ./before/nft -jeaf large_ruleset.json >/dev/null
>>> | 4.85user 0.47system 0:05.48elapsed 97%CPU (0avgtext+0avgdata 69732maxresident)k
>>> | 0inputs+0outputs (15major+16937minor)pagefaults 0swaps
>>>
>>> | # time ./after/nft -jeaf large_ruleset.json >/dev/null
>>> | 0.18user 0.44system 0:00.70elapsed 89%CPU (0avgtext+0avgdata 68484maxresident)k
>>> | 0inputs+0outputs (15major+16645minor)pagefaults 0swaps
>>
>> LGTM.
>>
>> BTW, Jose (he's on Cc) should rewrite his patch to exercise the
>> monitor path when --echo and --json are combined _and_ input is _not_
>> json.

IIRC v4 of the patch already takes into account this situation. 
Specifically this piece of code inside netlink_echo_callback. Returning 
the json_events_cb (the path leading to the seqnum_to_json call) when 
input is json.

-	if (nft_output_json(&ctx->nft->output))
-		return json_events_cb(nlh, &echo_monh);
+	if (nft_output_json(&nft->output)) {
+		if (!nft->json_root) {
+			nft->json_echo = json_array();
+			if (!nft->json_echo)
+				memory_allocation_error();
+			echo_monh.format = NFTNL_OUTPUT_JSON;
+		} else
+			return json_events_cb(nlh, &echo_monh);
+	}

  	return netlink_events_cb(nlh, &echo_monh);
  }

I also remember Eric Garver ran firewalld tests with this patch.

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20200804103846.58872-1-guigom@riseup.net/#2499299

>> Hence, leaving --echo and --json where input is json in the way you
>> need (using the sequence number to reuse the json input
>> representation).
>>
>> OK?
> 
> Yes, that's fine with me!

It's been some time, but I think this patch was ready to be merged back 
then and that does not interfere with the json_events_cb path. Just 
adding echo+json capability when reading native syntax.


Regards!
