Return-Path: <SRS0=Yj8l=43=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A90FC10F27
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Mar 2020 13:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A56920675
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Mar 2020 13:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgCJNhl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Mar 2020 09:37:41 -0400
Received: from correo.us.es ([193.147.175.20]:53534 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726898AbgCJNhl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Mar 2020 09:37:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D1C8DFB44C
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2020 14:37:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C05ADDA3A3
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2020 14:37:19 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B5B81DA39F; Tue, 10 Mar 2020 14:37:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E988CDA72F;
        Tue, 10 Mar 2020 14:37:17 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 10 Mar 2020 14:37:17 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CB8E842EE38E;
        Tue, 10 Mar 2020 14:37:17 +0100 (CET)
Date:   Tue, 10 Mar 2020 14:37:38 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Frank Myhr <fmyhr@fhmtech.com>
Cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: Restoring rulesets containing dynamic sets with counters
Message-ID: <20200310133738.zi3axvy62xqihrod@salvia>
References: <5e5cfaed-d2c6-02e1-8019-dd6ba2613034@fhmtech.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="rw3ul6nmkiyk2q4q"
Content-Disposition: inline
In-Reply-To: <5e5cfaed-d2c6-02e1-8019-dd6ba2613034@fhmtech.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--rw3ul6nmkiyk2q4q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 09, 2020 at 07:35:15PM -0400, Frank Myhr wrote:
> Hi,
> 
> I've created a ruleset that contains several dynamic sets with counters that
> are incremented from the packet path using rules like:
> update @suspect { ip saddr counter }
> 
> After awhile in operation, "nft list ruleset" produces output like:
> table ip ip_filter {
> 	set suspect {
> 		type ipv4_addr
> 		size 65535
> 		flags dynamic,timeout
> 		timeout 30d
> 		gc-interval 1d
> 		elements = { 1.2.3.4 expires 19d23h52m27s576ms counter packets 51 bytes
> 17265 }
> 	}
> 
> But "nft -f" then chokes when loading the saved ruleset, with
> "Error: syntax error, unexpected counter, expecting comma or '}'".
> 
> For now I can use sed to blank the counter text before reloading the ruleset
> (as after reboot). That's bit clunky, and obviously loses the counter
> values.
> 
> I do want to keep the dynamically-added elements across reboot. Is there a
> better way to do so?

This is the userspace patch to update the syntax. Still missing
remaining bits, but it is doable.

--rw3ul6nmkiyk2q4q
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/include/expression.h b/include/expression.h
index 87c39e5de08a..9cd21b0e1dad 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -276,6 +276,11 @@ struct expr {
 			uint64_t		expiration;
 			const char		*comment;
 			struct stmt		*stmt;
+			struct {
+				bool		enabled;
+				uint64_t	packets;
+				uint64_t	bytes;
+			} counters;
 			uint32_t		elem_flags;
 		};
 		struct {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 26ce4e089e1e..afd29a208e4e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3671,7 +3671,7 @@ meter_key_expr_alloc	:	concat_expr
 			;
 
 set_elem_expr		:	set_elem_expr_alloc
-			|	set_elem_expr_alloc		set_elem_options
+			|	set_elem_expr_alloc		set_elem_expr_options
 			;
 
 set_elem_expr_alloc	:	set_lhs_expr
@@ -3701,6 +3701,37 @@ set_elem_option		:	TIMEOUT			time_spec
 			}
 			;
 
+set_elem_expr_options	:	set_elem_expr_option
+			{
+				$<expr>$	= $<expr>0;
+			}
+			|	set_elem_expr_options	set_elem_expr_option
+			;
+
+set_elem_expr_option	:	TIMEOUT			time_spec
+			{
+				$<expr>0->timeout = $2;
+			}
+			|	EXPIRES		time_spec
+			{
+				$<expr>0->expiration = $2;
+			}
+			|	COUNTER
+			{
+				$<expr>0->counters.enabled = true;
+			}
+			|	COUNTER	PACKETS	NUM	BYTES	NUM
+			{
+				$<expr>0->counters.enabled = true;
+				$<expr>0->counters.packets = $3;
+				$<expr>0->counters.bytes = $5;
+			}
+			|	comment_spec
+			{
+				$<expr>0->comment = $1;
+			}
+			;
+
 set_lhs_expr		:	concat_rhs_expr
 			|	wildcard_expr
 			;

--rw3ul6nmkiyk2q4q--
