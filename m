Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468E62874F5
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Dec 2025 12:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766665963; cv=none; b=OPolEQlgzC1kyRIOTbPEJjCmBPqLSgFASCxefMIyP4DhRUSYqNo+V/H2abNQPnAj6cRhWRF3cRWKBCHiNr4ARtVR4Kh2N0UEugeCqRYhQpmx9t3JLT9Fo1ToZYzz/Bx0WBmzKexTi7Z+Nu200ryRPqLKkzNSbH/5QWWRh+MciD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766665963; c=relaxed/simple;
	bh=S/SQL7ldgdPSeQqIQ6DXy+z7gvPhoqsiEauAUCxulnQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=eA0gM1QBYVv4U68LuOt/EqSPsa+bniZnY1hqduqRW5hvp+0kiKJ0yH6RNokllZwoKbxfQ+CScaoTapDXJT3hu3zUGjHJkleHEwC4hl3rriaDopwM/0x0g3osBKSDn+DEL1WfjcBkYw+xgO3wdSssowQS/oJgLFxRlnFJdA3wJA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I5WoIboM; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I5WoIboM"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5943b62c47dso6446518e87.1
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Dec 2025 04:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766665959; x=1767270759; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=z/VYLf56yINNuz2SsLezRaE8hclZIHMbL8UgzLWhwck=;
        b=I5WoIboM3gNPBxi2Ea92RU3THvZUykkJKM5CXXkvoClio7As/TWlxajmqFNq1l9ugu
         1QNi4Qw29b9V1icG4svzTJM5uhgm9P5xi2iELl/2Epg0vaTH7MGgoK+xQl0GQuXWEmCb
         w2uJyBZR4bKN9KLEX8q6/4VUjtVDZrDUXmxOi/9bdSY/BRmpjfZ1NuZo9bXYXBaZxp44
         5S1CR7AZJp6UboWtL9ikbMSd2l1n4TCx+3aox0rhsSjYCLskJBrj/B7XBGDewFybEKh2
         EtWp65pw8738T2B36FMXc11AQJjz3CHyWqF8EnoKBIQCV0k24hJ8naIQZ2lk6oKCsTXX
         OfdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766665959; x=1767270759;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z/VYLf56yINNuz2SsLezRaE8hclZIHMbL8UgzLWhwck=;
        b=bgS0yWfrCWnWhIqxMjDoX57G23mpJWmptZPB8T8INUYMrjAHZS/XcwAkexgFAshv55
         4tcGvBP6U43uz4j1a1HJh1Huxe1CeH1Rztm3S+CsQvlfPxy6r+ln2duSdp1SEZdD5xUK
         eNwK9wavqOoVyyY3xeBRjKy4Iz+GFYz+FERrh48g1cpYLReDyzA6kX3/i3zRG96ziveV
         VQQwzJokMehfd726BSZgTizQEHxLFBMdzRLzxll2qpvisvNU6Wnynw0pt5bm+u0LEOOM
         7l7nshMyJ6sgp4wkh2z5VNp+UeyV4u6zg9r9AtGDJjWG09CzMpgiBXoGGtQ8qRUiNcLX
         pFPw==
X-Gm-Message-State: AOJu0YyK4HAZiWCn9HXU/y/LbxeR+GkGtPDbt6j5wbQTG1Fv0IrrUnsR
	qi4xvi/llTId1v6SoPXvJhL/eALaKlfWQceMDdxaSibsNiS8uFYZ+y8IJxOm967gSjsXp7vB
X-Gm-Gg: AY/fxX6wyLlrG9u6TAsx1gfzChKYDljpnP+VVQFG35haQiOSR0yGvV7wgP5csS1stOE
	g8asmSnVfdSPcUlvwGmrJXEFWXczZhi9j/u1ipuWWSdF+pRE3f5FvfevXkdwHnSl52jkYS4DiEX
	rxR6id9IfqTDRJpOJl1m9DkP6ZLcyYxNsGeuFq2TRTisrdUfvnqDVu1NbnGLrYAw4W6ytteupc9
	x2kLVlzDGsnMQNEuhXdworFZxMxqJxUNvtp9KL2PSrOmGKwCxqQih6ttNtxs/0uh5aeBGlFADZi
	U1+PX1jmcLQEYvNlB0TCvb6mDg0SCF8J1ZLZTGnb1bsy8+Pvo9OxxhIO+yOfJM7SYi/Lw+hMCjn
	JFlNEJCJSPQcX1U31r9g+QlResXf88mPLbyPSTS1sivzAFoYHvYOQOVMCPBuLjjgkMns6OjvDAk
	1Ir7CloivN5Dd/QWJ98V+o3z/9j6kFec+5pKIujff1suqgaHLp0Yq3K3jxFgUJzrA=
X-Google-Smtp-Source: AGHT+IHrnp3P5gNi3oz3kVCZ/Unhl2DowWuvhsZhsON1z+oLP7dJ88gCAJyC2FnNg3kFJuCl+jnWKw==
X-Received: by 2002:a05:6512:10cb:b0:598:8f91:b71d with SMTP id 2adb3069b0e04-59a17d16f3amr7463188e87.22.1766665958845;
        Thu, 25 Dec 2025 04:32:38 -0800 (PST)
Received: from rbta-msk-lt-930947.astralinux.ru.astracloud.ru ([85.198.105.11])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59a186282e0sm5805377e87.95.2025.12.25.04.32.35
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Dec 2025 04:32:37 -0800 (PST)
From: Ilia Kashintsev <ilia.kashintsev@gmail.com>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH] ebtables: fix null dereference in ebtables-restore
Date: Thu, 25 Dec 2025 15:32:34 +0300
Message-Id: <20251225123234.69801-1-ilia.kashintsev@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use strchrnul() instead of strchr() when trimming the trailing newline.
This avoids NULL pointer dereference when newline is not present in the
input.

Signed-off-by: Ilia Kashintsev <ilia.kashintsev@gmail.com>
---
 ebtables-restore.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ebtables-restore.c b/ebtables-restore.c
index bb4d0cf..d7df38c 100644
--- a/ebtables-restore.c
+++ b/ebtables-restore.c
@@ -17,6 +17,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
+#define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -76,7 +77,7 @@ int main(int argc_, char *argv_[])
 		line++;
 		if (*cmdline == '#' || *cmdline == '\n')
 			continue;
-		*strchr(cmdline, '\n') = '\0';
+		*strchrnul(cmdline, '\n') = '\0';
 		if (*cmdline == '*') {
 			if (table_nr != -1) {
 				ebt_deliver_table(&replace[table_nr]);
-- 
2.39.2

