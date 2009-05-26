From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: pull: minor tidbits
Date: Tue, 26 May 2009 13:37:56 +0200
Message-ID: <4A1BD494.9090105@netfilter.org>
References: <1243337187-18216-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44587 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034AbZEZLxJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 May 2009 07:53:09 -0400
In-Reply-To: <1243337187-18216-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

Jan Engelhardt wrote:
> Please pull from
> 	git://dev.medozas.de/iptables master
> 
> to receive non-API-touching minor cosmetics and a few fixes
> to recently-reported issues:
> 
> 	xtables: use extern "C"
> 	extensions: add const qualifiers in print/save functions
> 	iptables: replace open-coded sizeof by ARRAY_SIZE
> 	addrtype: fix one manpage type
> 	manpages: do not include v4-only modules in ip6tables manpage

This all look sane to me :). I'm going to apply them unless Patrick does
it faster than me ;).

BTW, one minor cosmetic comment:
+		for (i = 0; i < ARRAY_SIZE(sctp_chunk_names); ++i)
 			if (strcasecmp(sctp_chunk_names[i].name, ptr) == 0) {
 				DEBUGP("Chunk num %d\n", sctp_chunk_names[i].chunk_type);
 				SCTP_CHUNKMAP_SET(einfo->chunkmap,
@@ -206,7 +194,6 @@ parse_sctp_chunk(struct xt_sctp_info *einfo,
 				found = 1;
 				break;
 			}
-		}

I like the brackets in the for() statement, it's good to disambiguate.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
