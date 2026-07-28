Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C3541F370
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 10:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785233460; cv=none; b=HyvtP41CdkP8SRAZaEgaOrM4GnERV/OsqhYBrnnZS5BmDL9WweiVK4zebl3wq1t7MmCXHv2vjm6bUBay4Z6lVFRGCmKVxNPMhoNjEWVeXfoz6uW6wb2IMsKN2nMvjkASAVZklx6WPgaLv9RV2AsyOBlHKCZ7BaivObkJXcwPr+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785233460; c=relaxed/simple;
	bh=3R+BkYqgmoA5snpqGx7/HlKc3dCN+ws6txV51wT2apg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dp1v1124leBykCfb4ROudGru5yYg3jsvCuozn9BZeusrrpZSBNZVbb1ltm7KALmJIJkcsjghOs6BY82D4XdwyUrzVxO1nxvaFkJBfso759VTGN+WCwFGLa5xU/AHpylrfKwy4uw4x1uciQdLdnbo7IyV1Eq6Eefge295+uRjwZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ErlpiqTT; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ErlpiqTT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=K1VdtZIVUkUV/eqUqgkAFSX77IAdAGVM17jiaIxhFD8=; b=ErlpiqTT99xJj2p5BRtIjU3eJq
	7epfsDbzGnJLZedGjdcbztRUs1PF+hzkgzjCrSG80W9PHzwZNLPB+KRWk48VcrwqWfCcPn5dMkKe7
	5OCQ1OQW9gQkNdvjy2fjrTTPUGVKpR6MxsxDnmUSReT1kN7tEVUpTllnTsJCo46PuK91VDx/GMJhX
	TTfNUXrDX9EYa3kYFv++xF3TwyuI7fiPQOwKG7I/x3Ly1N/s25BOZdASxCSLeVjMH2Y4jbDnQLmQn
	9TM+MCETPqnCcstd96kkM/m97yAk5ahWnWb0PwV8EyPYoWwGQ3begJg/4qXFlNYATbNMP+cK/yIa2
	WJvCNrNQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1woeln-000000005a1-3wVW;
	Tue, 28 Jul 2026 12:10:44 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/2] m4: Add missing AX_PROG_BISON macro
Date: Tue, 28 Jul 2026 12:10:38 +0200
Message-ID: <20260728101038.1213031-2-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260728101038.1213031-1-phil@nwl.cc>
References: <20260728101038.1213031-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It requires AX_COMPARE_VERSION internally, add both.

Fixes: b315dd551dd96 ("parser_bison: Fix for bison < 3.6")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 m4/ax_compare_version.m4    | 177 ++++++++++++++++++++++++++++++++++++
 m4/ax_prog_bison_version.m4 |  69 ++++++++++++++
 2 files changed, 246 insertions(+)
 create mode 100644 m4/ax_compare_version.m4
 create mode 100644 m4/ax_prog_bison_version.m4

diff --git a/m4/ax_compare_version.m4 b/m4/ax_compare_version.m4
new file mode 100644
index 0000000000000..ffb4997e8b146
--- /dev/null
+++ b/m4/ax_compare_version.m4
@@ -0,0 +1,177 @@
+# ===========================================================================
+#    https://www.gnu.org/software/autoconf-archive/ax_compare_version.html
+# ===========================================================================
+#
+# SYNOPSIS
+#
+#   AX_COMPARE_VERSION(VERSION_A, OP, VERSION_B, [ACTION-IF-TRUE], [ACTION-IF-FALSE])
+#
+# DESCRIPTION
+#
+#   This macro compares two version strings. Due to the various number of
+#   minor-version numbers that can exist, and the fact that string
+#   comparisons are not compatible with numeric comparisons, this is not
+#   necessarily trivial to do in a autoconf script. This macro makes doing
+#   these comparisons easy.
+#
+#   The six basic comparisons are available, as well as checking equality
+#   limited to a certain number of minor-version levels.
+#
+#   The operator OP determines what type of comparison to do, and can be one
+#   of:
+#
+#    eq  - equal (test A == B)
+#    ne  - not equal (test A != B)
+#    le  - less than or equal (test A <= B)
+#    ge  - greater than or equal (test A >= B)
+#    lt  - less than (test A < B)
+#    gt  - greater than (test A > B)
+#
+#   Additionally, the eq and ne operator can have a number after it to limit
+#   the test to that number of minor versions.
+#
+#    eq0 - equal up to the length of the shorter version
+#    ne0 - not equal up to the length of the shorter version
+#    eqN - equal up to N sub-version levels
+#    neN - not equal up to N sub-version levels
+#
+#   When the condition is true, shell commands ACTION-IF-TRUE are run,
+#   otherwise shell commands ACTION-IF-FALSE are run. The environment
+#   variable 'ax_compare_version' is always set to either 'true' or 'false'
+#   as well.
+#
+#   Examples:
+#
+#     AX_COMPARE_VERSION([3.15.7],[lt],[3.15.8])
+#     AX_COMPARE_VERSION([3.15],[lt],[3.15.8])
+#
+#   would both be true.
+#
+#     AX_COMPARE_VERSION([3.15.7],[eq],[3.15.8])
+#     AX_COMPARE_VERSION([3.15],[gt],[3.15.8])
+#
+#   would both be false.
+#
+#     AX_COMPARE_VERSION([3.15.7],[eq2],[3.15.8])
+#
+#   would be true because it is only comparing two minor versions.
+#
+#     AX_COMPARE_VERSION([3.15.7],[eq0],[3.15])
+#
+#   would be true because it is only comparing the lesser number of minor
+#   versions of the two values.
+#
+#   Note: The characters that separate the version numbers do not matter. An
+#   empty string is the same as version 0. OP is evaluated by autoconf, not
+#   configure, so must be a string, not a variable.
+#
+#   The author would like to acknowledge Guido Draheim whose advice about
+#   the m4_case and m4_ifvaln functions make this macro only include the
+#   portions necessary to perform the specific comparison specified by the
+#   OP argument in the final configure script.
+#
+# LICENSE
+#
+#   Copyright (c) 2008 Tim Toolan <toolan@ele.uri.edu>
+#
+#   Copying and distribution of this file, with or without modification, are
+#   permitted in any medium without royalty provided the copyright notice
+#   and this notice are preserved. This file is offered as-is, without any
+#   warranty.
+
+#serial 13
+
+dnl #########################################################################
+AC_DEFUN([AX_COMPARE_VERSION], [
+  AC_REQUIRE([AC_PROG_AWK])
+
+  # Used to indicate true or false condition
+  ax_compare_version=false
+
+  # Convert the two version strings to be compared into a format that
+  # allows a simple string comparison.  The end result is that a version
+  # string of the form 1.12.5-r617 will be converted to the form
+  # 0001001200050617.  In other words, each number is zero padded to four
+  # digits, and non digits are removed.
+  AS_VAR_PUSHDEF([A],[ax_compare_version_A])
+  A=`echo "$1" | sed -e 's/\([[0-9]]*\)/Z\1Z/g' \
+                     -e 's/Z\([[0-9]]\)Z/Z0\1Z/g' \
+                     -e 's/Z\([[0-9]][[0-9]]\)Z/Z0\1Z/g' \
+                     -e 's/Z\([[0-9]][[0-9]][[0-9]]\)Z/Z0\1Z/g' \
+                     -e 's/[[^0-9]]//g'`
+
+  AS_VAR_PUSHDEF([B],[ax_compare_version_B])
+  B=`echo "$3" | sed -e 's/\([[0-9]]*\)/Z\1Z/g' \
+                     -e 's/Z\([[0-9]]\)Z/Z0\1Z/g' \
+                     -e 's/Z\([[0-9]][[0-9]]\)Z/Z0\1Z/g' \
+                     -e 's/Z\([[0-9]][[0-9]][[0-9]]\)Z/Z0\1Z/g' \
+                     -e 's/[[^0-9]]//g'`
+
+  dnl # In the case of le, ge, lt, and gt, the strings are sorted as necessary
+  dnl # then the first line is used to determine if the condition is true.
+  dnl # The sed right after the echo is to remove any indented white space.
+  m4_case(m4_tolower($2),
+  [lt],[
+    ax_compare_version=`echo "x$A
+x$B" | sed 's/^ *//' | sort -r | sed "s/x${A}/false/;s/x${B}/true/;1q"`
+  ],
+  [gt],[
+    ax_compare_version=`echo "x$A
+x$B" | sed 's/^ *//' | sort | sed "s/x${A}/false/;s/x${B}/true/;1q"`
+  ],
+  [le],[
+    ax_compare_version=`echo "x$A
+x$B" | sed 's/^ *//' | sort | sed "s/x${A}/true/;s/x${B}/false/;1q"`
+  ],
+  [ge],[
+    ax_compare_version=`echo "x$A
+x$B" | sed 's/^ *//' | sort -r | sed "s/x${A}/true/;s/x${B}/false/;1q"`
+  ],[
+    dnl Split the operator from the subversion count if present.
+    m4_bmatch(m4_substr($2,2),
+    [0],[
+      # A count of zero means use the length of the shorter version.
+      # Determine the number of characters in A and B.
+      ax_compare_version_len_A=`echo "$A" | $AWK '{print(length)}'`
+      ax_compare_version_len_B=`echo "$B" | $AWK '{print(length)}'`
+
+      # Set A to no more than B's length and B to no more than A's length.
+      A=`echo "$A" | sed "s/\(.\{$ax_compare_version_len_B\}\).*/\1/"`
+      B=`echo "$B" | sed "s/\(.\{$ax_compare_version_len_A\}\).*/\1/"`
+    ],
+    [[0-9]+],[
+      # A count greater than zero means use only that many subversions
+      A=`echo "$A" | sed "s/\(\([[0-9]]\{4\}\)\{m4_substr($2,2)\}\).*/\1/"`
+      B=`echo "$B" | sed "s/\(\([[0-9]]\{4\}\)\{m4_substr($2,2)\}\).*/\1/"`
+    ],
+    [.+],[
+      AC_WARNING(
+        [invalid OP numeric parameter: $2])
+    ],[])
+
+    # Pad zeros at end of numbers to make same length.
+    ax_compare_version_tmp_A="$A`echo $B | sed 's/./0/g'`"
+    B="$B`echo $A | sed 's/./0/g'`"
+    A="$ax_compare_version_tmp_A"
+
+    # Check for equality or inequality as necessary.
+    m4_case(m4_tolower(m4_substr($2,0,2)),
+    [eq],[
+      test "x$A" = "x$B" && ax_compare_version=true
+    ],
+    [ne],[
+      test "x$A" != "x$B" && ax_compare_version=true
+    ],[
+      AC_WARNING([invalid OP parameter: $2])
+    ])
+  ])
+
+  AS_VAR_POPDEF([A])dnl
+  AS_VAR_POPDEF([B])dnl
+
+  dnl # Execute ACTION-IF-TRUE / ACTION-IF-FALSE.
+  if test "$ax_compare_version" = "true" ; then
+    m4_ifvaln([$4],[$4],[:])dnl
+    m4_ifvaln([$5],[else $5])dnl
+  fi
+]) dnl AX_COMPARE_VERSION
diff --git a/m4/ax_prog_bison_version.m4 b/m4/ax_prog_bison_version.m4
new file mode 100644
index 0000000000000..4090332a9392b
--- /dev/null
+++ b/m4/ax_prog_bison_version.m4
@@ -0,0 +1,69 @@
+# ===========================================================================
+#  https://www.gnu.org/software/autoconf-archive/ax_prog_bison_version.html
+# ===========================================================================
+#
+# SYNOPSIS
+#
+#   AX_PROG_BISON_VERSION([VERSION],[ACTION-IF-TRUE],[ACTION-IF-FALSE])
+#
+# DESCRIPTION
+#
+#   Makes sure that bison version is greater or equal to the version
+#   indicated. If true the shell commands in ACTION-IF-TRUE are executed. If
+#   not the shell commands in commands in ACTION-IF-TRUE are executed. If
+#   not the shell commands in ACTION-IF-FALSE are run. Note if $BISON is not
+#   set (for example by running AC_CHECK_PROG or AC_PATH_PROG) the macro
+#   will fail.
+#
+#   Example:
+#
+#     AC_PATH_PROG([BISON],[bison])
+#     AX_PROG_BISON_VERSION([3.0.2],[ ... ],[ ... ])
+#
+#   This will check to make sure that the bison you have is at least version
+#   3.0.2 or greater.
+#
+#   NOTE: This macro uses the $BISON variable to perform the check.
+#
+# LICENSE
+#
+#   Copyright (c) 2015 Jonathan Rajotte-Julien <jonathan.rajotte-julien@efficios.com>
+#
+#   Copying and distribution of this file, with or without modification, are
+#   permitted in any medium without royalty provided the copyright notice
+#   and this notice are preserved. This file is offered as-is, without any
+#   warranty.
+
+#serial 3
+
+AC_DEFUN([AX_PROG_BISON_VERSION],[
+    AC_REQUIRE([AC_PROG_SED])
+    AC_REQUIRE([AC_PROG_GREP])
+
+    AS_IF([test -n "$BISON"],[
+        ax_bison_version="$1"
+
+        AC_MSG_CHECKING([for bison version])
+        changequote(<<,>>)
+        bison_version=`$BISON --version 2>&1 \
+          | $SED -n -e '/bison (GNU Bison)/b inspect
+b
+: inspect
+s/.* (\{0,1\}\([0-9]*\.[0-9]*\.[0-9]*\))\{0,1\}.*/\1/;p'`
+        changequote([,])
+        AC_MSG_RESULT($bison_version)
+
+	AC_SUBST([BISON_VERSION],[$bison_version])
+
+        AX_COMPARE_VERSION([$bison_version],[ge],[$ax_bison_version],[
+	    :
+            $2
+        ],[
+	    :
+            $3
+        ])
+    ],[
+        AC_MSG_WARN([could not find bison])
+        $3
+    ])
+])
-- 
2.54.0

