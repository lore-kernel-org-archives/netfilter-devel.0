Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F140D18EFE6
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 10:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728471051; cv=none; b=OBx84ELGQZOKhGf/wKkwZWEMJQSVfvL11VtHHIME4mVf6gv01Ej8ebKjCbDDLICrmiVqh63Z80x1IYKKGaJpFExTShZODCrmN4Kf0VejzKvslEKBHHVHKCxVOu/OnoFvB1kEhIZZN/XvV78MvcEwYo0IQ//qWLVzl5cdJTEJltY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728471051; c=relaxed/simple;
	bh=mxqDOZ6OESGMCJZky6ffqf4PyMjZkq8CavBE1178bng=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2zp4jcLoR0aDxAwhbY3lHy8nGH6ap0AB6xkVKeAHs0NWaXSH/l/KycFMiDHiGAa+Bdr01v1XiLxsBgcn3CLXJFozh3BzQU7wQYF75cZe8snZpDI4BxLN9aQJsS0l64seXl4g4PVQaVdMYPY5O1nt/slR3lq1pYllznyhZaPk34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=jweSOrjx; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="jweSOrjx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BIsHHDPTL9xy5GaEqrWr2YYDwDiY2wjAa0X1Vst8ILc=; b=jweSOrjxC6OK3eWxndeCMsz+wc
	F9ZMLPCAm7osGgkmaF+n42KfsS/UZfHzMQigHYx9IStEGuqNateMsoLEt7n/uxF2KFwwiXyuq2yyp
	EME1xlxSuMCSBQ79Oeo/CrHW+jCTsPZu/S3oNBMH5DZ78HMKVOaS+oFWCk5TuElPKBEQ6rmycguDx
	wnBD2WfdpaEBlgEpwUXhRwQviSd2GM8FzZNNEQFZFdLwJzkiisKKhMsmvsCDL6MzrdxKFr9Q3tw2x
	H1+oPMIIKuYDAz0X3hGMnOCo2/JiJn9vbyEIhvfVCY9oCgcVAghY5WJLS+Io8o+UZNsjDXTBPwoGS
	dOvdjQJA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1syUHB-000000007Q2-1cll
	for netfilter-devel@vger.kernel.org;
	Wed, 09 Oct 2024 12:50:41 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/5] tests: iptables-test: Append stderr output to log file
Date: Wed,  9 Oct 2024 12:50:33 +0200
Message-ID: <20241009105037.30114-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241009105037.30114-1-phil@nwl.cc>
References: <20241009105037.30114-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Right now this merely contains a number of intrapositioned negation
warnings, but might be useful in future when debugging unexpected
failures.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables-test.py | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/iptables-test.py b/iptables-test.py
index cefe42335d25d..77278925d7217 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -132,6 +132,8 @@ STDERR_IS_TTY = sys.stderr.isatty()
                             stdin=subprocess.PIPE,
                             stdout=subprocess.PIPE, stderr=subprocess.PIPE)
     out, err = proc.communicate()
+    if len(err):
+        print(err, file=log_file)
 
     #
     # check for segfaults
@@ -333,6 +335,8 @@ STDERR_IS_TTY = sys.stderr.isatty()
                             stderr = subprocess.PIPE)
     restore_data = "\n".join(restore_data) + "\n"
     out, err = proc.communicate(input = restore_data)
+    if len(err):
+        print(err, file=log_file)
 
     if proc.returncode == -11:
         reason = iptables + "-restore segfaults!"
@@ -358,6 +362,8 @@ STDERR_IS_TTY = sys.stderr.isatty()
                             stdout = subprocess.PIPE,
                             stderr = subprocess.PIPE)
     out, err = proc.communicate()
+    if len(err):
+        print(err, file=log_file)
 
     if proc.returncode == -11:
         reason = iptables + "-save segfaults!"
-- 
2.43.0

