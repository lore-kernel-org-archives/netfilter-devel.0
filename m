Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC2524169E;
	Wed,  9 Jul 2025 23:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752102490; cv=none; b=WnIsnNSiu2SuwD7nICr9IkAQRgUEfxJlF697UW95K+xqDJs8ReE19MOlwWD/QkyLIlIISWouUEyxoEgxyOmSA/TG3oExZLfD6qmv3YsyaW84PfC0nN+7i9/yajxRB/T+ikKqOoOOQ2gYTgu+r4jVhzmNo3bTokys75Z+giALzgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752102490; c=relaxed/simple;
	bh=lN+HdSs+M71XVyqCjYsxfW2xQ/2suTkluOOvdlfVMyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8h0t7i0RjAInQyfxZZ0dO+qNIwJUPPFsXn2GmCz385OZWBhsjOOr3jtuQWTnU+BJm1PLsYIZTbnFzUuYv7JwaO8ViXQFlbn6XI2W5IKoOchhkIix4TEngBt+PZu96B6043vPfLb3I6fNLKNoOYLJ63CPsP93f4MTfKncQ7veIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A7A35607AC; Thu, 10 Jul 2025 01:08:05 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: netfilter@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	pavelpribylov01@gmail.com
Subject: [PATCH nft] doc: expand on gc-interval, size and a few other set/map keywords
Date: Thu, 10 Jul 2025 01:07:52 +0200
Message-ID: <20250709230800.30997-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <CANnZF1bKkHctvnpG6JnhtMpUzj6FC5crn1bDqt+eq-G_+mR_Eg@mail.gmail.com>
References: <CANnZF1bKkHctvnpG6JnhtMpUzj6FC5crn1bDqt+eq-G_+mR_Eg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reported-by: <pavelpribylov01@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.txt | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 1be2fbac05c1..8712981943d7 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -596,6 +596,8 @@ Sets are element containers of a user-defined data type, they are uniquely
 identified by a user-defined name and attached to tables. Their behaviour can
 be tuned with the flags that can be specified at set creation time.
 
+See Set and Map flags below for more details.
+
 [horizontal]
 *add*:: Add a new set in the specified table. See the Set specification table below for more information about how to specify properties of a set.
 *delete*:: Delete the specified set.
@@ -636,6 +638,27 @@ string: performance [default], memory
 automatic merge of adjacent/overlapping set elements (only for interval sets) |
 |=================
 
+The *gc-interval* doesn't affect element timeout, but it does affect memory reclaim.
+A large set that rarely has elements that time out can use a higher (less frequent) garbage
+collection to save cpu time, whereas sets that see many updates with short-lived elements
+will benefit from a lower interval.
+Lower intervals ensure the set stays below its maximum size.
+Internally, a timed-out entry stays around until it is removed by the garbage collector, which
+also decrements the sets element count.
+This also means that it is possible to have a set that can not accept more elements, even
+if all elements timed out, if the *gc-interval* is set too large.
+
+The *size* defines the upper limit of the amount of elements that the set can support.
+Mandatory for sets that are added to from the ruleset with the *add* and *update* keywords.
+Providing the *size* keyword for sets that are only added to via *nft add element* allows for
+a more compact (memory conserving) set implementation selection, but it is not required.
+
+The optional *policy* keyword can be used to request a more memory-conserving set implementation.
+
+*auto-merge* instructs the nftables frontend to merge adjacent and overlapping ranges.
+Example: When the set contains range *1.2.3.1-1.2.3.4*, then adding element *1.2.3.2* has no
+effect.  Adding *1.2.3.5* changes the existing range to cover *1.2.3.1-1.2.3.5*.
+Without this flag, *1.2.3.2* can not be added and *1.2.3.5* is inserted as a new entry.
 
 MAPS
 -----
@@ -684,6 +707,8 @@ If a required flag is missing, the ruleset might still work, as
 nftables will auto-enable features if it can infer this from the ruleset.
 This may not work for all cases, however, so it is recommended to
 specify all required features in the set/map definition manually.
+Also, some features are mutually exclusive.  For example, it is not possible
+for a set to support intervals and insertion from the packet path.
 
 .Set and Map flags
 [options="header"]
@@ -691,7 +716,7 @@ specify all required features in the set/map definition manually.
 |Flag		| Description
 |constant	| Set contents will never change after creation
 |dynamic	| Set must support updates from the packet path with the *add*, *update* or *delete* keywords.
-|interval	| Set must be able to store intervals (ranges)
+|interval	| Set must be able to store intervals (ranges). Cannot be combined with the *dynamic* flag.
 |timeout	| Set must support element timeouts (auto-removal of elements once they expire).
 |=================
 
-- 
2.49.0

