Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D6440872
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2024 13:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709298285; cv=none; b=cUmZqg8w4GnqL4O6TVV82PF/kkrkOZyXoKWgrbNm9GAtsllmWX2OLAPLhDZ0TS0Odz/0kaA0cX2KjAHWR3NnMFdv574g1TRgkpG9pC9QgtAAVi1McSCDrQZa/VYVKXRI2j1p2wiMLZTgmS5vzZreR+Y9Xb6V8IOWMRL3w/kuwEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709298285; c=relaxed/simple;
	bh=BY0o0nQqNppZRRoEbaexvltXcStNgkVuLSRtKFFq9BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0Av6xU9oPN3CYVo0JSDT+lJLkPIFSohdranG9ZKR818MMdxiaXcJN6YU+r/RsBcuRQ241XvKWlZ/AASCyED+rGoA4E52olCgPMZxPzZx5y3P9tXYANRqOQuF+wx4GRx0IE2gVUeFsIUggl/ptFkLGyCuSgEnziEeRqeOTc7E3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rg2Z7-0002N0-I8; Fri, 01 Mar 2024 14:04:41 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/3] parser: allow to define maps that contain ct helpers
Date: Fri,  1 Mar 2024 13:59:37 +0100
Message-ID: <20240301125942.20170-3-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240301125942.20170-1-fw@strlen.de>
References: <20240301125942.20170-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Its currently not possible to use ct helpers in objref maps.

Simply adding "CT HELPER" to "map_block_obj_type" does not work
due to a conflict with the "ct helper" ct_expr block.

  map m {
    type ipv4_addr : ct helper ..

... declares a map storing ip addresses and conntrack helper names
(string type).  This does not make sense, there is no way
to use the associated value (the names) in any sensible way:

ct helper "ftp" - this matches if the packet has a conntrack entry that
was accepted via the "ftp" conntrack helper. In nft vm terms, this is
translated to:

 [ ct load helper => reg 1 ]
 [ cmp eq reg 1 0x00707466 0x00000000 0x00000000 0x00000000 ]

Or one can query a set, e.g. 'ct helper { "ftp", "sip" }'.
"ftp" and "sip" are the kernel-defined names of these connection
tracking helpers.

ct helper set "ftp" is something else, however:

This is used to assign a *userspace defined helper objrect reference*.
Nftables will translate this to:

 [ objref type 3 name ftp ]

.. where "ftp" is a arbitrary user-chosen name.

  ct helper "ftp" {
    type "ftp" protocol tcp
    l3proto ip
  }

IOW, "ct helper" is ambiguous.  Without the "set" keyword (first case),
it places the kernel-defined name of the active connection tracking helper
in the chosen register (or it will cancel rule evaluation if no helper was
active).

With the set keyword (second case), the expected argument is a user-defined
object reference which will then tell the connection tracking engine to
monitor all further packets of the new flow with the given helper template.

This change makes it so that

  map m {
    type ipv4_addr : ct helper ..

declares a map storing ct helper object references suitable for
'ct helper set'.

The better alternative would be to resolve the ambiguity
by adding an additional postfix keyword, for example

 ct helper name (case one)
 ct helper object (case two).

But this needs a kernel change that adds
NFT_CT_HELPER_NAME and NFT_CT_HELPER_OBJECT to enum nft_ct_keys.

While a new kernel could handle old nftables binaries that still use
NFT_CT_HELPER key, new nftables would need to probe support first.

Furthermore,

 ct helper name set "foo"

... would make no sense, as the kernel-defined helper names are
readonly.

 ct helper object "foo"

... would make no sense, unless we extend the kernel to store
the nftables userspace-defined name in a well-known location
in the kernel.  Userdata area cannot work for this, because the
nft conntrack expression in the kernel would need to know how to
retrieve this info again.

Also, I cannot think of a sensible use case for this.
So the only remaining, useful commands are:

ct helper name "ftp"
ct helper object set "foo"

... which is identical to what we already support, just with
extra keyword.

So a much simpler solution that does not need any kernel changes
is make "ct helper" have different meaning depending on wheter it
is placed on the key side, i.e.:

    "typeof ct helper", "typeof ct helper : $value"

versus when its on placed on the data (value) side of maps:

    "typeof $key : ct helper".

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 05861c3e2f75..bdb73911759c 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2329,9 +2329,16 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 				}
 
 				$1->key = $3;
-				$1->data = $5;
 
-				$1->flags |= NFT_SET_MAP;
+				if ($5->etype == EXPR_CT && $5->ct.key == NFT_CT_HELPER) {
+					$1->objtype = NFT_OBJECT_CT_HELPER;
+					$1->flags  |= NFT_SET_OBJECT;
+					expr_free($5);
+				} else {
+					$1->data = $5;
+					$1->flags |= NFT_SET_MAP;
+				}
+
 				$$ = $1;
 			}
 			|	map_block	TYPE
-- 
2.43.0

