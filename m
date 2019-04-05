Return-Path: <SRS0=Hnfl=SH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66ECAC4360F
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Apr 2019 12:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2178121855
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Apr 2019 12:57:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="n3EtaJOb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfDEM5O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Apr 2019 08:57:14 -0400
Received: from mx1.riseup.net ([198.252.153.129]:36066 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbfDEM5O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Apr 2019 08:57:14 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 695D91A0DDB;
        Fri,  5 Apr 2019 05:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1554469033; bh=FEc8hMiAUoBeeV3GKoMPGN8CzE9hOVT56admDYaQ3eE=;
        h=To:Cc:From:Subject:Date:From;
        b=n3EtaJOb1NWqMS8QojZzRCJjNJXZMTOCuJmixJVmuOQ+BkIzXqIBbFpanJT+gZwx5
         SyTeFK/kVmc541Jb1HWu25MjVb7vmMH1RmmffGUbOpjGD5xbeMDNDV1A2mJV4GfYyW
         c2m8pTLhFYyx+EKdVAlZmNf6gwFKJxrk7cyDXvwg=
X-Riseup-User-ID: 2215A8BD68A4606706BFE57876DB567A67A32563F0F3157C92CDD7FEFC640100
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id AD511120540;
        Fri,  5 Apr 2019 05:57:12 -0700 (PDT)
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Subject:  nft - Extracting the value from a variable_expr
Message-ID: <ce9dfbe1-06ba-29a8-3f53-ad46742b0a4a@riseup.net>
Date:   Fri, 5 Apr 2019 14:57:21 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I am trying to extract the value from a symbol which comes from a
variable_expr. This variable is a simple string i.e "define foo = bar".

I am doing something like that:

char *example_function(struct expr *variable)
{
	struct *sym;
	char *sym_value;

	sym = variable->sym;
	sym_value = mpz_get_str(NULL, 10, sym->expr->value);

	return sym_value;
}


But this doesn't work so probably I am misundestanding something. Thanks!




