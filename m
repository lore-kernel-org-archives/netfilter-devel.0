Return-Path: <SRS0=37vH=RQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00BB0C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 10:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7CA22087C
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 10:13:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="BUAmeni+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbfCMKN7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 06:13:59 -0400
Received: from mx1.riseup.net ([198.252.153.129]:53542 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbfCMKN7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 06:13:59 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 4D49A1A5A48;
        Wed, 13 Mar 2019 03:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1552472038; bh=2vtASCAkALfthhXdY6R18Mxhd1/7ytMotwmp04jttTk=;
        h=Subject:To:References:From:Cc:Date:In-Reply-To:From;
        b=BUAmeni+GKLIo/M0orwDYYcOLmZxobzWcUYmPMf8VL1wkW02vycMxE46QRrYOmG5a
         u+7I6mSJIiEoQzE3WOZRFg37XBZ1/dZk0zIHd40sV/BcfCfvYKc3dxi0B4RJt05OOS
         NDcOX9FvGXf/FvDi3u0fBX882KZ/StMliy5cJnIY=
X-Riseup-User-ID: B5AE679B8D103A78E740307E0D7098A68F9F59C977930ED0296C2BC4769E747B
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 842671203C3;
        Wed, 13 Mar 2019 03:13:57 -0700 (PDT)
Subject: Re: [PATCH nft v2 1/6] osf: add version fingerprint support
To:     netfilter-devel@vger.kernel.org
References: <20190311151417.17772-1-ffmancera@riseup.net>
 <20190313094424.GA11433@orbyte.nwl.cc>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Cc:     Phil Sutter <phil@nwl.cc>
Message-ID: <b1d98d09-3cf7-3de1-1fb3-479244da560b@riseup.net>
Date:   Wed, 13 Mar 2019 11:14:04 +0100
MIME-Version: 1.0
In-Reply-To: <20190313094424.GA11433@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On 3/13/19 10:44 AM, Phil Sutter wrote:
> Hi Fernando,
> 
> On Mon, Mar 11, 2019 at 04:14:12PM +0100, Fernando Fernandez Mancera wrote:
>> Add support for version fingerprint in "osf" expression. Example:
>>
>> table ip foo {
>> 	chain bar {
>> 		type filter hook input priority filter; policy accept;
>> 		osf ttl skip name "Linux"
>> 		osf ttl skip name version "Linux:4.20"
>> 	}
>> }
> 
> The syntax seems overly complicated to me, although I'm not really
> familiar with OSF so may lack background knowledge. Any reason why you
> didn't go with 'osf ttl skip name "Linux" version "4.20"' instead?
> 

You are right, 'osf ttl skip name "Linux" version "4.20"' was my first
thought but in compilation time the parser applies shift-reduce to the
expression.. I decided 'osf ttl skip name version "Linux:4.20"' to avoid
a complex workaround in the parser.

The fingerprints database syntax is "genre:version:subtype:details" so
the nft 'osf' expression syntax is like the original one.

> Also with regards to your patch to json_parser, I guess you should
> introduce an enum for flag values, something like:
> 
> | enum osf_flags {
> | 	OSF_FLAG_INVALID = 0x0,
> | 	OSF_FLAG_VERSION = 0x1
> | };
> | 
> | const char *osf_flag_names[] = {
> | 	[OSF_VERSION] = "version"
> | };
> 
> What do you think?
> 

This patch already introduces an enum for flags values, you can find it
below. Do you think we need another one? Sorry if I am misunderstanding
you. Thanks!

diff --git a/include/linux/netfilter/nf_tables.h
b/include/linux/netfilter/nf_tables.h
index 37036be..09a7b9e 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -944,15 +944,21 @@ enum nft_socket_keys {
  *
  * @NFTA_OSF_DREG: destination register (NLA_U32: nft_registers)
  * @NFTA_OSF_TTL: Value of the TTL osf option (NLA_U8)
+ * @NFTA_OSF_FLAGS: flags (NLA_U32)
  */
 enum nft_osf_attributes {
 	NFTA_OSF_UNSPEC,
 	NFTA_OSF_DREG,
 	NFTA_OSF_TTL,
+	NFTA_OSF_FLAGS,
 	__NFTA_OSF_MAX
 };
 #define NFT_OSF_MAX		(__NFTA_OSF_MAX - 1)

+enum nft_osf_flags {
+	NFT_OSF_F_VERSION	= 1 << 0,	/* check fingerprint version */
+};
+
 /**
  * enum nft_ct_keys - nf_tables ct expression keys
  *

> Cheers, Phil
> 
