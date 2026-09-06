Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B67A72621
	for <netfilter-devel@vger.kernel.org>; Sun,  6 Sep 2026 22:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788733217; cv=none; b=eOrr/kJAvgF9iUzEm7LrGFkrV4wymO+qMP0FLAK+umJI6nxKC8B1YJXllpDzTrNrumANH96Ujy5hIbE0oBU3gMmyoQ82F+a9mIQ3Ld7E24/a0q631/p3XBDIN46PEyX/8vpTMtuPmsWOY5nk2k6+/SouCXMJmt8kgJV1eGgiwms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788733217; c=relaxed/simple;
	bh=ckImEn7DqyVJSqZJ6PEvBDY2Lx6s5wXnqO5UO3q7wMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofgwAsMTnIIZxYp7IGIdI+mDDh/9nEd4jo2goXf9jJVXJmyWrpYepe0WxzFPGe3vjBJ9XLidwJ60ZyOD/f4dI112gzpkFoczV7nTE1BNh5GMFb/VDzwGn2J9io0gA35FDtz+KNQcqUrjYB7FiuSjWYjAmtMHoafBlDG2Zl617Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kn5eJUJT; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kn5eJUJT"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-484374f54d0so1621992f8f.3
        for <netfilter-devel@vger.kernel.org>; Sun, 06 Sep 2026 15:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788733214; x=1789338014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0y/3Y+Meqv4n9defUV1o/zEilZlTljWXe0KE7nGDkdM=;
        b=Kn5eJUJTGy73NvA2643VZxUVfwwJFh4G9cP++ZDOEzCqYZ2pjlsljKEov5MteUVn6k
         4Wh4HMZSCpOUOiGWharyKxPimfzIGqlGY45B+7uJTGFGOGp/3EoYfR+SmoH2/Mwr6Bop
         1ojQlJ/VnL1N4dAfgALNYIbgLZWWYUdaF2rGnHyH3+Xu40U6nMfBwJXjvxljWBEjRHPt
         nLHrOtx3mHE8JvEEnfN+cigbzq+EYhD/haDD1wSRZ6jRtxTBFu9jacZnvwa+uN06eSOo
         52i+JMI46IX36B8wd4SnWzmLPAiA7R/Ve/kn3yGoQRn9BP+xXMpaa9A6RhIsMWLjNahp
         XtCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788733214; x=1789338014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0y/3Y+Meqv4n9defUV1o/zEilZlTljWXe0KE7nGDkdM=;
        b=eg5f7iSYZYHeyAX+5GyE/ugMbuu3+Xk789LD9Xa2dpgkFHEXMn6KZVw83tMCEOxfYq
         dlf010r/ZDE7fz9kdmdVeToF/kDezNiDCPcUAE79ci/+Me0eutNCZ5g4OvfAyl1Ge/tO
         fj7jqFq33BXyC0f78vWsVmVTSMQqMhqmK9WuJCeTrd14eI6qPSiOKG2Xy1lxlOIT3+fi
         uFkaongur6dqEKKc32jLlVvHZY8QyZh9YE4X70hZfNRQ4IqO3tYtUKaV7B/ZLxud93OQ
         AoVvV7whEQBrrNSor6e8/JaX2bNEVTxFkXqWdJcgjRAjjPp9jhmgwvDix3zMz1TL/IkI
         iUng==
X-Forwarded-Encrypted: i=1; AKwUvBwikAji4f5z6b1v0MqRf4wrRoSoYHGrWPtBknfgCC0fpOnY92fW/Y9ycfo3xmwo/yJGRXznv4RDBqnMwnd0Kmk=@vger.kernel.org
X-Gm-Message-State: AFuF++mN3on+wt+Y5Pk7lfzDdxrKSCyFGh3MKQpDPFTNUf442okgL1A4
	5lrY8XbglIlUi+pgfcFK2kW9ltqqCK+4DQYpMJOP9HZntxLLNH29dm6u
X-Gm-Gg: AYBFou2oDXyAUBeKm7G3GJ7jT4vdWJwfNr+ysV4bweGDE/PItRExPe+tHnIfE74gI2C
	308FNY6C4XpLNf88P2rFeK6KC4HLIkpXs3hY74/QDahws6wV320UBz8xHFVvQM9kr5hT6Nn4wEr
	/RE8x9xr6D2nWcuestLY7OKsfJDZHcJJdf3NIdc515wEh4Z7Sxm31SxQ/P/KrTxRpFyGVTzHCMH
	5HgtXFHiU8prjszoBFuFfTbGorat88icR7XCJD+Dru1l1Y7NtLqyMTRVsmPmYlL3j7yDoVWhbSp
	/6lA2KJDDSbqSPcOGqoPacpy4jD7OI8fyXOHduXJJQbqQBrmbNW8xry+xUKUFWc4NIoLPiszw5d
	9A5FXMjplBSBQqSNtuetOszBdy+DA7a8knwWie9kkGNAHesffwfRS3w+qjBWfnzvpd0FPM7Sts7
	Wja4hudgxiDE//asIKk/63JRLPUMYZ+/C4NCj3ItCN8FBZYl9Sc+vW9I23CtWM04a7chzcC8bSX
	QlYVpImWeK0rxMOGVYXef4IGBd6kMrsC0bwS76ek67691/l3I50qcoiO3qz9uOT5/jZJeiByXri
	VvYIZ1H2S/Rs7jwrjuBiPLiizLYt6Jg5Gse4tIMXMu5QfZ2Suhxct0oSnK20qNQB17U=
X-Received: by 2002:a05:6000:4694:b0:484:3310:710c with SMTP id ffacd0b85a97d-48587290c78mr31955580f8f.24.1788733214009;
        Sun, 06 Sep 2026 15:20:14 -0700 (PDT)
Received: from localhost.localdomain (p2003010827046e6b7ce92663474df7af.dip0.t-ipconnect.de. [2003:108:2704:6e6b:7ce9:2663:474d:f7af])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4858e239862sm18666508f8f.9.2026.09.06.15.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 15:20:13 -0700 (PDT)
From: Bernard Ladenthin <bernard.ladenthin@gmail.com>
To: pablo@netfilter.org
Cc: akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	kunit-dev@googlegroups.com,
	davem@davemloft.net,
	Bernard Ladenthin <bernard.ladenthin@gmail.com>
Subject: Re: [PATCH 1/4] lib/ts_bm: advance state->offset past the reported match
Date: Mon,  7 Sep 2026 00:19:54 +0200
Message-ID: <20260906221955.6311-1-bernard.ladenthin@gmail.com>
X-Mailer: git-send-email 2.49.0.windows.1
In-Reply-To: <aoIfn1SzxQKa5t8m@chamomile>
References: <20260816170541.3384-2-bernard.ladenthin@gmail.com> <aoIfn1SzxQKa5t8m@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, Aug 16, 2026 at 10:37:51PM +0200, Pablo Neira Ayuso wrote:
> > A caller looping until UINT_MAX never terminates.
>
> Yes, for a good reason.

Thanks for the review. Let me start with the question I actually have.

One interface, three implementations. The same test, unchanged, run
against each of them. kmp passes it, bm fails it. I cannot find where
that difference is written down, and that is what I would like to
understand.

Where I looked. include/linux/textsearch.h:20 describes the field as

   * @offset: offset for next match

and lib/textsearch.c:72 says

 *   Subsequent occurrences can be found by calling textsearch_next()
 *   regardless of the linearity of the data.

Both are from 2005 and neither has changed. ts_bm.c does record one
deviation from the other algorithms, in its file header, that a match
spread over multiple blocks will be missed and that kmp should be used
when that matters. It says nothing about repeating the same offset.

If what you mean is that the algorithm as Boyer and Moore published it
stops at the first match and therefore defines no shift after one, that
is true, and it may well be how this came about. kmp_find() faces the
same question and answers it in two lines, and patch 1 is those same two
lines:

  kmp:  state->offset = consumed + i + 1;
        return state->offset - kmp->pattern_len;

  bm:   state->offset = consumed + shift + 1;
        return state->offset - bm->patlen;

So the question is not really about Boyer-Moore. It is about why two
backends of one interface answer the same question differently, with
nothing saying which answer is the intended one.

> With bm, it reports offset 6, because it looks from right to left,
> this is how the original Boyer-Moore algorithm works.

I put that into a test case. The diff at the end adds it,
parameterised like the others, so it makes the same claim about kmp and
about bm. Applying it turns the suite red on purpose.

Patch 2 applies without patch 1 and does not touch lib/ts_bm.c, so this
describes today's behaviour:

  echo CONFIG_KUNIT=y > .kunitconfig
  echo CONFIG_TEXTSEARCH_KUNIT_TEST=y >> .kunitconfig
  ./tools/testing/kunit/kunit.py run --arch=um \
      --kunitconfig=.kunitconfig "textsearch.*"

In the output below I cut the "at lib/tests/..." suffix so the lines
fit, nothing else is changed:

  ============ ts_first_match_is_last_occurrence  ============
  [FAILED] kmp
      # ts_first_match_is_last_occurrence: EXPECTATION FAILED
      Expected pos == 6, but
          pos == 2 (0x2)

  first match reported
  [FAILED] bm
      # ts_first_match_is_last_occurrence: EXPECTATION FAILED
      Expected pos == 6, but
          pos == 2 (0x2)

  first match reported

Both report 2, so the first match is the same for either algorithm. If
that case asserts the wrong thing, please tell me what it should assert.
The run also gives

  # Totals: pass:17 fail:5 skip:0 total:22

Two of the five are that case, red by design. The other three are bm, in
ts_next_advances, ts_next_finds_all and ts_blocks_iteration_terminates.
Every kmp case passes.

> Why? What do you get by setting state->offset?
>
> What are you trying to fix?

I should be plain about the scope. Nothing in the tree calls
textsearch_next(), and as far as I can tell nothing ever has. I checked
the whole history with git log -S over 1.46 million commits back to
2.6.12-rc2, which covers the entire life of lib/textsearch.c. So this
repairs no reported breakage, and I am not claiming otherwise.

What led me here is that lib/ts_bm.c has needed five correctness fixes
in twenty-one years. In 2008 a pattern at the very start of the text was
never found, "abc" in "abcdefg" returned nothing, and that had been true
since 2005. In 2023 an iptables rule with --algo bm silently stopped
matching, reported through bugzilla.netfilter.org #1390 and fixed by
6f67fbf8192d. Neither was caught by a test, because there were none.

That is why patch 2 exists, and it is the patch I care about most.

Which brings me to a basic question. Why has this code never had tests?
I looked and found none, and git ls-tree agrees with me, but I may have
missed them. If there are any, I would rather extend those than add a
new file.

I ask because the suite does find two of those old bugs when they are
put back on a current tree:

  the 2008 one, shift = bm->patlen instead of bm->patlen - 1
      ts_find_at_start               red for bm, green for kmp

  the 2023 one, revert 6f67fbf8192d
      ts_blocks_match_within_block   red for bm, green for kmp

Not all five, to be clear. The 2026 overflow it does not catch, because
textsearch_prepare() rejects the zero length before the algorithm sees
it. The two from 2006 I did not try to put back, the code around them
has moved too far for that to mean anything.

> > Which algorithm a caller selected should not decide whether that
> > works.
>
> Why?

Because the promise is made at the interface, not per algorithm.
lib/textsearch.c and include/linux/textsearch.h describe
textsearch_next() without naming one, while lib/ts_bm.c lists its own
deviation in its own header. And xt_string.c:56 hands conf->algo
straight from userspace to textsearch_prepare(), so the caller cannot
know in advance which of the two behaviours it will get.

> Yes, and people that use it rely on the current behaviour, so you have
> to explain what you are aiming at fixing.

Nothing observable changes for them. The returned value is the same
expression:

  before:  consumed + (shift - (bm->patlen - 1))
  after:   state->offset - bm->patlen,
           with state->offset = consumed + shift + 1

Both are consumed + shift + 1 - bm->patlen. The patch only writes down
the offset the return statement already implied. skb_find_text() keeps
its ts_state on its own stack and uses only the return value, and
xt_string reads only that return value, so no netfilter path can observe
the write.

> You are not specifying any tree for this patches.

Sorry about that. get_maintainer.pl points at LIBRARY CODE for these
files, so the series is aimed at Andrew Morton, and I should have said
so in the subject. I will use a prefix on the next posting.

So my request is not that patch 1 be applied. It is that the difference
be explained or written down. If bm is meant to be single shot, I will
send a patch saying so in the same place the multi-block limitation is
already stated, and drop patch 1. And if the Fixes: tag looks wrong for
something nothing can reach today, I am happy to drop that too and let
patch 1 stand as a follow-on to the tests.

The case below is not meant for merging. It is your sentence written
as a test.

Thanks,
Bernard

---
--- a/lib/tests/textsearch_kunit.c
+++ b/lib/tests/textsearch_kunit.c
@@ -302,6 +302,26 @@
 	KUNIT_EXPECT_EQ(test, PTR_ERR(conf), -EINVAL);
 }
 
+/*
+ * Not part of the contract the other cases check, and not meant to be
+ * merged. It encodes the description that "bm" reports the last
+ * occurrence first, so that the claim can be run. It is parameterised
+ * like the rest, so it makes the same claim about kmp and about bm.
+ */
+static void ts_first_match_is_last_occurrence(struct kunit *test)
+{
+	static const char text[] = "xxABxxABxx";
+	static const char pattern[] = "AB";
+	struct ts_config *conf = ts_conf_get(test, pattern);
+	struct ts_state state;
+	unsigned int pos;
+
+	pos = textsearch_find_continuous(conf, &state, text, strlen(text));
+	KUNIT_EXPECT_EQ_MSG(test, pos, 6, "first match reported");
+
+	textsearch_destroy(conf);
+}
+
 static struct kunit_case textsearch_test_cases[] = {
 	KUNIT_CASE_PARAM(ts_find_middle, ts_algo_gen_params),
 	KUNIT_CASE_PARAM(ts_find_at_start, ts_algo_gen_params),
@@ -313,6 +333,7 @@
 	KUNIT_CASE_PARAM(ts_blocks_iteration_terminates, ts_algo_gen_params),
 	KUNIT_CASE_PARAM(ts_get_pattern, ts_algo_gen_params),
 	KUNIT_CASE_PARAM(ts_prepare_zero_len, ts_algo_gen_params),
+	KUNIT_CASE_PARAM(ts_first_match_is_last_occurrence, ts_algo_gen_params),
 	{}
 };
 
