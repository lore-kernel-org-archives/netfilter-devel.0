Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F21CBC433FE
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Nov 2022 13:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbiKGNI7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Nov 2022 08:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbiKGNI6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Nov 2022 08:08:58 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF391C123
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Nov 2022 05:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BCL2tdlcfJooNBgzLFZTaPIeR9qdjMd9M6ZhnwxQbEM=; b=UUg8+ULUKShR/Si829rxuqo7Vn
        49YOkRtvsbZFf5hVAB91y7uI6EjJBq0SHhyBjBVwrkn3Gkq87YKVvtw0zdZXf1wxDFxd4wKrUnW/A
        7GthiYMCI4DVisJL5fzkh1LooRuc5EtnQ4kXxIAN8j1ByBr3aR35zoaty8fp/ra+nwcPo2CbJQ52k
        6cTTxiNcuZqJ91QtKEN2ATI95FSA1KVPt7/tutjeEydZ/5ePmcYFc03EiwpQLj9/6+CQTMxYu7cV4
        8PJTr/q0U/MLgjkVQWixpyRTMTtnbVVXZpS3vqn81hH9ylyZAe9kgc8DZOI9eepWj7iVdbgQd6WVS
        o+DLWuWw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1os1rw-0002hH-Jh
        for netfilter-devel@vger.kernel.org; Mon, 07 Nov 2022 14:08:52 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/3] tests: xlate-test: Replay results for reverse direction testing
Date:   Mon,  7 Nov 2022 14:08:43 +0100
Message-Id: <20221107130843.8024-4-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221107130843.8024-1-phil@nwl.cc>
References: <20221107130843.8024-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Call nft with translation output as input, then check xtables-save
output to make sure iptables-nft can handle anything it suggests nft to
turn its ruleset into.

This extends the test case syntax to cover for expected asymmetries.
When the existing syntax was something like this:

| <xlate command>
| <nft output1>
| [<nft output2>

The new syntax then is:

| <xlate command>[;<replay rule part>]
| <nft output1>
| [<nft output2>]

To keep things terse, <replay rule part> may omit the obligatory '-A
<chain>' argument. If missing, <xlate command> is sanitized for how it
would appear in xtables-save output: '-I' is converted into '-A' and an
optional table spec is removed.

Since replay mode has to manipulate the ruleset in-kernel, abort if
called by unprivileged user. Also try to run in own net namespace to
reduce collateral damage.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 xlate-test.py | 145 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 144 insertions(+), 1 deletion(-)

diff --git a/xlate-test.py b/xlate-test.py
index bfcddde0f84a6..f3fcd797af908 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -57,8 +57,92 @@ xtables_nft_multi = 'xtables-nft-multi'
 
     return True
 
+def test_one_replay(name, sourceline, expected, result):
+    global args
+
+    searchline = None
+    if sourceline.find(';') >= 0:
+        sourceline, searchline = sourceline.split(';')
+
+    srcwords = sourceline.split()
+
+    srccmd = srcwords[0]
+    table_idx = -1
+    chain_idx = -1
+    table_name = "filter"
+    chain_name = None
+    for idx in range(1, len(srcwords)):
+        if srcwords[idx] in ["-A", "-I", "--append", "--insert"]:
+            chain_idx = idx
+            chain_name = srcwords[idx + 1]
+        elif srcwords[idx] in ["-t", "--table"]:
+            table_idx = idx
+            table_name = srcwords[idx + 1]
+
+    if not chain_name:
+        return True     # nothing to do?
+
+    if searchline is None:
+        # adjust sourceline as required
+        srcwords[chain_idx] = "-A"
+        if table_idx >= 0:
+            srcwords.pop(table_idx)
+            srcwords.pop(table_idx)
+        searchline = " ".join(srcwords[1:])
+    elif not searchline.startswith("-A"):
+        tmp = ["-A", chain_name]
+        if len(searchline) > 0:
+            tmp.extend(searchline)
+        searchline = " ".join(tmp)
+
+    fam = ""
+    if srccmd.startswith("ip6"):
+        fam = "ip6 "
+    elif srccmd.startswith("ebt"):
+        fam = "bridge "
+    nft_input = [
+            "flush ruleset",
+            "add table " + fam + table_name,
+            "add chain " + fam + table_name + " " + chain_name
+    ] + [ l.removeprefix("nft ") for l in expected.split("\n") ]
+
+    # feed input via the pipe to make sure the shell "does its thing"
+    cmd = "echo \"" + "\n".join(nft_input) + "\" | " + args.nft + " -f -"
+    rc, output, error = run_proc(cmd, shell = True)
+    if rc != 0:
+        result.append(name + ": " + red("Fail"))
+        result.append(args.nft + " call failed: " + error.rstrip('\n'))
+        for line in nft_input:
+            result.append(magenta("input: ") + line)
+        return False
+
+    ipt = srccmd.split('-')[0]
+    rc, output, error = run_proc([xtables_nft_multi, ipt + "-save"])
+    if rc != 0:
+        result.append(name + ": " + red("Fail"))
+        result.append(ipt + "-save call failed: " + error)
+        return False
+
+    if output.find(searchline) < 0:
+        outline = None
+        for l in output.split('\n'):
+            if l.startswith('-A '):
+                output = l
+                break
+        result.append(name + ": " + red("Replay fail"))
+        result.append(magenta("src: '") + expected + "'")
+        result.append(magenta("exp: '") + searchline + "'")
+        for l in output.split('\n'):
+            result.append(magenta("res: ") + l)
+        return False
+
+    return True
+
+
 def run_test(name, payload):
     global xtables_nft_multi
+    global args
+
     test_passed = True
     tests = passed = failed = errors = 0
     result = []
@@ -69,7 +153,10 @@ xtables_nft_multi = 'xtables-nft-multi'
             line = payload.readline()
             continue
 
-        sourceline = line
+        sourceline = replayline = line.rstrip("\n")
+        if line.find(';') >= 0:
+            sourceline = line.split(';')[0]
+
         expected = payload.readline().rstrip(" \n")
         next_expected = payload.readline()
         if next_expected.startswith("nft"):
@@ -84,6 +171,20 @@ xtables_nft_multi = 'xtables-nft-multi'
         else:
             errors += 1
             test_passed = False
+            continue
+
+        if args.replay:
+            tests += 1
+            if test_one_replay(name, replayline, expected, result):
+                passed += 1
+            else:
+                errors += 1
+                test_passed = False
+
+            rc, output, error = run_proc([args.nft, "flush", "ruleset"])
+            if rc != 0:
+                result.append(name + ": " + red("Fail"))
+                result.append("nft flush ruleset call failed: " + error)
 
     if (passed == tests) and not args.test:
         print(name + ": " + green("OK"))
@@ -106,8 +207,44 @@ xtables_nft_multi = 'xtables-nft-multi'
     return (test_files, total_tests, total_passed, total_failed, total_error)
 
 
+def spawn_netns():
+    # prefer unshare module
+    try:
+        import unshare
+        unshare.unshare(unshare.CLONE_NEWNET)
+        return True
+    except:
+        pass
+
+    # sledgehammer style:
+    # - call ourselves prefixed by 'unshare -n' if found
+    # - pass extra --no-netns parameter to avoid another recursion
+    try:
+        import shutil
+
+        unshare = shutil.which("unshare")
+        if unshare is None:
+            return False
+
+        sys.argv.append("--no-netns")
+        os.execv(unshare, [unshare, "-n", sys.executable] + sys.argv)
+    except:
+        pass
+
+    return False
+
+
 def main():
     global xtables_nft_multi
+
+    if args.replay:
+        if os.getuid() != 0:
+            print("Replay test requires root, sorry", file=sys.stderr)
+            return
+        if not args.no_netns and not spawn_netns():
+            print("Cannot run in own namespace, connectivity might break",
+                  file=sys.stderr)
+
     if not args.host:
         os.putenv("XTABLES_LIBDIR", os.path.abspath("extensions"))
         xtables_nft_multi = os.path.abspath(os.path.curdir) \
@@ -139,6 +276,12 @@ xtables_nft_multi = 'xtables-nft-multi'
 parser = argparse.ArgumentParser()
 parser.add_argument('-H', '--host', action='store_true',
                     help='Run tests against installed binaries')
+parser.add_argument('-R', '--replay', action='store_true',
+                    help='Replay tests to check iptables-nft parser')
+parser.add_argument('-n', '--nft', type=str, default='nft',
+                    help='Replay using given nft binary (default: \'%(default)s\')')
+parser.add_argument('--no-netns', action='store_true',
+                    help='Do not run testsuite in own network namespace')
 parser.add_argument("test", nargs="?", help="run only the specified test file")
 args = parser.parse_args()
 sys.exit(main())
-- 
2.38.0

