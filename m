Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF49EC433DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Feb 2021 12:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7333A64E2E
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Feb 2021 12:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbhBVMFd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Feb 2021 07:05:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50093 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230147AbhBVMFP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Feb 2021 07:05:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613995427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ms6y8yb/F+MbNzES5cuimnkGfN4sf4e7TLlkcm39OgU=;
        b=A2c0QXKOnwulU5/qUZ15EoWQw5Z3P+f/9VyULdTke0QIjsvCw8MDkAZBZixoMv8Iasrqwo
        utYSW9WruVL26S7OlHa8faKWrcD0iBWuXXwPHy/CsoN5WaAxVN7WI57kex9uTfEDV/Bgtq
        ZxhXT/YNO2tUrwHFKRPpDpATuXEhhA4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-XNixf3TeMg2eIRgJ_3vDVA-1; Mon, 22 Feb 2021 07:03:46 -0500
X-MC-Unique: XNixf3TeMg2eIRgJ_3vDVA-1
Received: by mail-ed1-f70.google.com with SMTP id i21so6853246edq.2
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Feb 2021 04:03:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ms6y8yb/F+MbNzES5cuimnkGfN4sf4e7TLlkcm39OgU=;
        b=BNhjWqbaMvfgyWiibyCjoI8E0GpVCQpkOmerlBJdyAeZ/YF2ZCMFGAQXNwSV2KRRdS
         MwZyuU5DiunlSNOadTStaNG8+vWchOiunHtgnIUNhGnt4BZLsONdharuT0W9EBJwaKfs
         qNGmrjXNIJiIjHV2DBHR5xS7jmqbNP8VF42Of2VV5d6XPq3EO8IBlFOHcy1tM3RcbBbl
         zEfZLY4NtP4RmIqWPNM5uIg0L6Y3OMSHWS0TlzBlttJZjh13i3yAISyU4KiqqA2mlNfB
         DEM/9bEvfLheNm7BuIVDn1Smj/OZ1ljvCVc8Dh7Q+KT8crL9EjCHK5RuTXNrfdVeW38I
         pyEQ==
X-Gm-Message-State: AOAM533/5iJIy64y8tKdXbZByzdLda6FGUZStRilE+U/Gv+Yst75Rfkz
        qfpt4RD1HhknHKjuQ72HHWNkgU7nKwBUnnmdE81UQPcZqPUQcWArM0Kw25xK7NhzAIy7nbnUR5l
        PXBB93RB3BJdk2cE4TtGm6q8Lu8EzETziF1XuTFZGMBx7nQxKfV46Hwj7tY/aTFvo53ttY9HI6V
        8QXw==
X-Received: by 2002:a17:906:7485:: with SMTP id e5mr5215326ejl.86.1613995424813;
        Mon, 22 Feb 2021 04:03:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwhVQWJ69mW8XHYszBZKI4v8G0VQlllZd+jV2Yqpf8VF5rUjl8jNoWw5cA39wEnISWpMG5kwA==
X-Received: by 2002:a17:906:7485:: with SMTP id e5mr5215303ejl.86.1613995424607;
        Mon, 22 Feb 2021 04:03:44 -0800 (PST)
Received: from localhost ([185.112.167.35])
        by smtp.gmail.com with ESMTPSA id k6sm10071245ejb.84.2021.02.22.04.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 04:03:44 -0800 (PST)
From:   =?UTF-8?q?=C5=A0t=C4=9Bp=C3=A1n=20N=C4=9Bmec?= <snemec@redhat.com>
To:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 2/2] doc: nft: fix some typos and formatting issues
Date:   Mon, 22 Feb 2021 13:03:20 +0100
Message-Id: <20210222120320.2252514-2-snemec@redhat.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210222120320.2252514-1-snemec@redhat.com>
References: <20210222120320.2252514-1-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Trying to escape asciidoc (9.1.0) * with \ preserves the backslash in
the formatted man page. Bare * works as expected.

Signed-off-by: Štěpán Němec <snemec@redhat.com>
---
 doc/nft.txt | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 2642d8903787..32261e266aa6 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -130,7 +130,7 @@ semicolon (;). +
 A hash sign (#) begins a comment. All following characters on the same line are
 ignored. +
 
-Identifiers begin with an alphabetic character (a-z,A-Z), followed zero or more
+Identifiers begin with an alphabetic character (a-z,A-Z), followed by zero or more
 alphanumeric characters (a-z,A-Z,0-9) and the characters slash (/), backslash
 (\), underscore (_) and dot (.). Identifiers using different characters or
 clashing with a keyword need to be enclosed in double quotes (").
@@ -148,9 +148,9 @@ relative path) or / for file location expressed as an absolute path. +
 
 If *-I*/*--includepath* is not specified, then nft relies on the default
 directory that is specified at compile time. You can retrieve this default
-directory via *-h*/*--help* option. +
+directory via the *-h*/*--help* option. +
 
-Include statements support the usual shell wildcard symbols (\*,?,[]). Having no
+Include statements support the usual shell wildcard symbols (*,?,[]). Having no
 matches for an include statement is not an error, if wildcard symbols are used
 in the include statement. This allows having potentially empty include
 directories for statements like **include "/etc/firewall/rules/"**. The wildcard
@@ -164,7 +164,7 @@ SYMBOLIC VARIABLES
 *$variable*
 
 Symbolic variables can be defined using the *define* statement. Variable
-references are expressions and can be used initialize other variables. The scope
+references are expressions and can be used to initialize other variables. The scope
 of a definition is the current block and all blocks contained within.
 
 .Using symbolic variables
@@ -396,7 +396,7 @@ further quirks worth noticing:
   hook.
 
 The *priority* parameter accepts a signed integer value or a standard priority
-name which specifies the order in which chains with same *hook* value are
+name which specifies the order in which chains with the same *hook* value are
 traversed. The ordering is ascending, i.e. lower priority values have precedence
 over higher ones.
 
@@ -435,7 +435,7 @@ the others. See the following tables that describe the values and compatibility.
 Basic arithmetic expressions (addition and subtraction) can also be achieved
 with these standard names to ease relative prioritizing, e.g. *mangle - 5* stands
 for *-155*.  Values will also be printed like this until the value is not
-further than 10 form the standard value.
+further than 10 from the standard value.
 
 Base chains also allow to set the chain's *policy*, i.e.  what happens to
 packets not explicitly accepted or refused in contained rules. Supported policy
@@ -492,7 +492,7 @@ table inet filter {
 		ip saddr 10.1.1.1 tcp dport ssh accept # handle 5
 	  ...
 # delete the rule with handle 5
-# nft delete rule inet filter input handle 5
+nft delete rule inet filter input handle 5
 -------------------------
 
 SETS
@@ -534,7 +534,7 @@ identified by a user-defined name and attached to tables. Their behaviour can
 be tuned with the flags that can be specified at set creation time.
 
 [horizontal]
-*add*:: Add a new set in the specified table. See the Set specification table below for more information about how to specify a sets properties.
+*add*:: Add a new set in the specified table. See the Set specification table below for more information about how to specify properties of a set.
 *delete*:: Delete the specified set.
 *list*:: Display the elements in the specified set.
 *flush*:: Remove all elements from the specified set.
@@ -553,7 +553,7 @@ expression to derive the data type from
 set flags |
 string: constant, dynamic, interval, timeout
 |timeout |
-time an element stays in the set, mandatory if set is added to from the packet path (ruleset).|
+time an element stays in the set, mandatory if set is added to from the packet path (ruleset)|
 string, decimal followed by unit. Units are: d, h, m, s
 |gc-interval |
 garbage collection interval, only available when timeout or flag timeout are
@@ -563,7 +563,7 @@ string, decimal followed by unit. Units are: d, h, m, s
 elements contained by the set |
 set data type
 |size |
-maximum number of elements in the set, mandatory if set is added to from the packet path (ruleset).|
+maximum number of elements in the set, mandatory if set is added to from the packet path (ruleset)|
 unsigned integer (64 bit)
 |policy |
 set policy |
@@ -628,7 +628,7 @@ ____
 Element-related commands allow to change contents of named sets and maps.
 'key_expression' is typically a value matching the set type.
 'value_expression' is not allowed in sets but mandatory when adding to maps, where it
-matches the data part in it's type definition. When deleting from maps, it may
+matches the data part in its type definition. When deleting from maps, it may
 be specified but is optional as 'key_expression' uniquely identifies the
 element.
 
-- 
2.29.2

