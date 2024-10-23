Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3FF19E804
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2024 11:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729681396; cv=none; b=fk0qB/KmkLdIAPUd+aIs/KLDTJ9PN3m0j7AY0yQTIpseTM06KdLmawtbMowY0kk4QrkUjWWFfLLl9XPp6+WaEHTU8NqRFrhbEn4dPgr2zccqOfTXes93Kn1NQHti2x2Okh0eQa4JgKQQKQn3FkYUhDBjQG92UUhCGnSjDllEq8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729681396; c=relaxed/simple;
	bh=BAHb82S6F4PhTUp6wYtZuS2cyfilPBh+I3ne98AbV+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gJakDd6pN9GbGWBxQ4+6oiPNL6nOxV+YN4UZx9zqrmihn3KrdCU0YhTa3J8oX8cb+aKnBZ0CHoDHxywTBNBmoOWPe9RoSwtIT5OIXoyac300E8MS1x2YVvB0KHVK7eWKNQf/jttzvk0S5VuNBCCYJh3aZJWrxA1Y9dT9tHBlEgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aBeIYCZc; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aBeIYCZc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oQjXVZ5wycIwuZt6dj6co4PqafI1MZyZQnf361Nts20=; b=aBeIYCZc3C1/lV227o4nl3BzNK
	BRcW0X3Dnw11d3N5slKYfrBiMgo2cC12tt+gQ4pzUds0jJi+iHHpqR09s1hJJosPTgCHAeaKkrPTy
	L9W6HiVv0AXRdyXVLTY8qPiNeWG2nWdaXLuv0FbHvSrvUUWSyrnAHGyn5EFfCCyei9/JcWhdHCZfZ
	YUyYcqAnEPpWtZ1w4QVQKGGWfJUCKlkubuuoIOapAXBiQuVTh01vfF8ktfhb0/RkmBkNE1aL6cWT/
	CXL9gyeUnXVj3ZDGA+40hAvWMOrPoxL2X+M5AiuY+SS/E5h8EWdIptS5AY4WQyWFmMHikM16K+42z
	aEGElkAQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t3Z8w-000000005iq-2NjC;
	Wed, 23 Oct 2024 13:03:10 +0200
Date: Wed, 23 Oct 2024 13:03:10 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH iptables] tests: iptables-test: extend coverage for
 ip6tables
Message-ID: <ZxjX7nqs8g1gBemh@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20241020224707.69249-1-pablo@netfilter.org>
 <ZxebAVfZ_aDSNeb4@orbyte.nwl.cc>
 <ZxejsR2ph2CSnYjD@orbyte.nwl.cc>
 <ZxetHFXRj08Jipu0@calendula>
 <Zxe85R9YnoOL-pzg@orbyte.nwl.cc>
 <Zxe_rez8MZN-ieN8@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zxe_rez8MZN-ieN8@calendula>

On Tue, Oct 22, 2024 at 05:07:25PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Oct 22, 2024 at 04:55:33PM +0200, Phil Sutter wrote:
> > On Tue, Oct 22, 2024 at 03:48:12PM +0200, Pablo Neira Ayuso wrote:
> > > On Tue, Oct 22, 2024 at 03:08:01PM +0200, Phil Sutter wrote:
> > > > On Tue, Oct 22, 2024 at 02:30:58PM +0200, Phil Sutter wrote:
> > > > [...]
> > > > > - With your patch applied, 20 rules fail (in both variants). Is this
> > > > >   expected or a bug on my side?
> > > > 
> > > > OK, so most failures are caused by my test kernel not having
> > > > CONFIG_IP_VS_IPV6 enabled.
> > > > 
> > > > Apart from that, there is a minor bug in introduced libip6t_recent.t in
> > > > that it undoes commit d859b91e6f3ed ("extensions: recent: New kernels
> > > > support 999 hits") by accident. More interesting though, it's reported
> > > > twice, once for fast mode and once for normal mode. I'll see how I can
> > > > turn off error reporting in fast mode, failing tests are repeated
> > > > anyway.
> > > 
> > > Would you point me to the relevant line in the libip6t_recent.t?
> > 
> > It is in line 7, I had changed the supposed-to-fail --hitcount value of
> > 999 to 65536.
> 
> This was already fixed in v2, correct?

Ah, you're right. I didn't notice your v2.

If you're OK with it, I'll apply your v3 with the following changes:
- Describe 'iptables' param in _run_test_file()
- Drop duplicate 'endswith' test from _run_test_file()
- Print results with command name suffixed for libxt tests (it is more
  consistent wrt. tests count)

Thanks, Phil

diff --git a/iptables-test.py b/iptables-test.py
index 521c11d7bbc05..0d2f30dfb0d7c 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -385,24 +385,20 @@ STDERR_IS_TTY = sys.stderr.isatty()
 
     return tests
 
-def _run_test_file(iptables, filename, netns, print_result):
+def _run_test_file(iptables, filename, netns, suffix):
     '''
     Runs a test file
 
+    :param iptables: string with the iptables command to execute
     :param filename: name of the file with the test rules
     :param netns: network namespace to perform test run in
     '''
-    #
-    # if this is not a test file, skip.
-    #
-    if not filename.endswith(".t"):
-        return 0, 0
 
     fast_failed = False
     if fast_run_possible(filename):
         tests = run_test_file_fast(iptables, filename, netns)
-        if tests > 0 and print_result:
-            print(filename + ": " + maybe_colored('green', "OK", STDOUT_IS_TTY))
+        if tests > 0:
+            print(filename + ": " + maybe_colored('green', "OK", STDOUT_IS_TTY) + suffix)
             return tests, tests
         fast_failed = True
 
@@ -482,10 +478,9 @@ STDERR_IS_TTY = sys.stderr.isatty()
 
     if netns:
         execute_cmd("ip netns del " + netns, filename)
-    if total_test_passed and print_result:
-        suffix = ""
+    if total_test_passed:
         if fast_failed:
-            suffix = maybe_colored('red', " but fast mode failed!", STDOUT_IS_TTY)
+            suffix += maybe_colored('red', " but fast mode failed!", STDOUT_IS_TTY)
         print(filename + ": " + maybe_colored('green', "OK", STDOUT_IS_TTY) + suffix)
 
     f.close()
@@ -527,11 +522,12 @@ STDERR_IS_TTY = sys.stderr.isatty()
     tests = 0
     passed = 0
     print_result = False
-    for index, iptables in enumerate(xtables):
-        if index == len(xtables) - 1:
-            print_result = True
+    suffix = ""
+    for iptables in xtables:
+        if len(xtables) > 1:
+            suffix = "({})".format(iptables)
 
-        file_tests, file_passed = _run_test_file(iptables, filename, netns, print_result)
+        file_tests, file_passed = _run_test_file(iptables, filename, netns, suffix)
         if file_tests:
             tests += file_tests
             passed += file_passed
