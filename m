Received: from zg8tmja5ljk3lje4ms43mwaa.icoremail.net (zg8tmja5ljk3lje4ms43mwaa.icoremail.net [209.97.181.73])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB891248F51
	for <netfilter-devel@vger.kernel.org>; Mon, 12 May 2025 07:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.97.181.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747033861; cv=none; b=cnxPUlKF+1BqWR3Aue5hx78fSAMNYWc42o1QGa5A1cyNv/af2xAtUo1iKyQi/IlTHj6oDNh9q0aPFl3ocqeprDQnXJW08QjfVMeSlLdSjY3L/CXdIOD29p3yKhfvbCba+Ezg3OCvtwwVgyHUdCrqr0DT0F7X1+Pin7ttMxZweUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747033861; c=relaxed/simple;
	bh=qlStNBAjNQwR86rjwxuqA+iJxR3dlpELZfUW4Lba5OA=;
	h=Date:From:To:Subject:Content-Type:MIME-Version:Message-ID; b=JgVgZ5LC/45N7zs86H14jb9nZlevK8sJPezNVRaA/LQ1RjzZcu8c18QcVJXsY1w6QdEO34yfA9R6bVpVfKZ6KDag9Leh5n+S8kNfktphKbqdxs2dfwzCVKtKeH4bSDlLmEsIqB5CTg2q9noP+8+NrAmZ81Aoc4k4Cdh6JGEbBYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=209.97.181.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.190.64.35])
	by mtasvr (Coremail) with SMTP id _____wCnFiz3niFo+1IsAQ--.110S3;
	Mon, 12 May 2025 15:10:47 +0800 (CST)
Received: from 22321077$zju.edu.cn ( [10.190.64.35] ) by
 ajax-webmail-mail-app3 (Coremail) ; Mon, 12 May 2025 15:10:47 +0800
 (GMT+08:00)
Date: Mon, 12 May 2025 15:10:47 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: =?UTF-8?B?5ZGo5oG66Iiq?= <22321077@zju.edu.cn>
To: netfilter-devel@vger.kernel.org
Subject: Fix resource leak in iptables/xtables-restore.c
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2024.2-cmXT6 build
 20241206(f7804f05) Copyright (c) 2002-2025 www.mailtech.cn zju.edu.cn
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <87aa5c8.77e3.196c354f80c.Coremail.22321077@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:zS_KCgBHKF_3niFoky5LAA--.5973W
X-CM-SenderInfo: qsstjiaqxxq6lmxovvfxof0/1tbiAgQEA2ggsAkvKAABs2
X-CM-DELIVERINFO: =?B?x88tlwXKKxbFmtjJiESix3B1w3st9zawssEjFy5Mij1sbnSF+UqcrL28bbYbthgFzE
	NeYzeBpJYe9MZ8RKqD8bOEp8BREu01zq+JEdFtAi1DGyA6K5ZnVOnxZWKZVP0ktpB60ibg
	zd4OpAd0b0J7c6rLudyXGTgA0vrFJz2XgcJWL7cremfLrPUHdGZNeoSD2NFj3Q==
X-Coremail-Antispam: 1Uk129KBj9xXoW7Wr1kuw17ur4DXw4rCF1Utwc_yoWxtrg_Gw
	12qFyDWFy7Jw1UKFWDtF4kAFy7Ca4rJw48Jr13tF45t3y0q3yUKFWUWF1Fva17GF1ayrW5
	GanrJrsxuw43ZosvyTuYvTs0mTUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUU11kYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6x
	kI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v2
	6r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2
	Ij64vIr41lF7xvr2IYc2Ij64vIr40E4x8a64kEw24lFcxC0VAYjxAxZF0Ew4CEw7xC0wAC
	Y4xI67k04243AVC20s07M4xvF2IEb7IF0Fy26I8I3I0EFcxC0VAYjxAxZF0Ew4CEw7xC0V
	CF72vEw4AK0VC2zVAF1VAY17CE14v26r1j6r15M4xvF2IEb7IF0Fy26I8I3I0E4x8a64kE
	w2IEx4CE17CEb7AF67AKxVWUJVWUXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jr0_JrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_Gr1l6VACY4xI67
	k04243AbIYCTnIWIevJa73UjIFyTuYvjxUsuc_DUUUU

VGhlIGZ1bmN0aW9uIHh0YWJsZXNfcmVzdG9yZV9tYWluIG9wZW5zIGEgZmlsZSBzdHJlYW0gcC5p
biBidXQgZmFpbHMgdG8gY2xvc2UgaXQgYmVmb3JlIHJldHVybmluZy4gVGhpcyBsZWFkcyB0byBh
IHJlc291cmNlIGxlYWsgYXMgdGhlIGZpbGUgZGVzY3JpcHRvciByZW1haW5zIG9wZW4uCgoKU2ln
bmVkLW9mZi1ieTogS2FpaGFuZyBaaG91IDwyMjMyMTA3N0B6anUuZWR1LmNuPgoKLS0tCiBpcHRh
Ymxlcy94dGFibGVzLXJlc3RvcmUuYyB8IDEgKwogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9u
KCspCgoKZGlmZiAtLWdpdCBhL2lwdGFibGVzL3h0YWJsZXMtcmVzdG9yZS5jIGIvaXB0YWJsZXMv
eHRhYmxlcy1yZXN0b3JlLmMKCmluZGV4IGU3ODAyYjllLi5mMDlhYjdlZSAxMDA2NDQKLS0tIGEv
aXB0YWJsZXMveHRhYmxlcy1yZXN0b3JlLmMKKysrIGIvaXB0YWJsZXMveHRhYmxlcy1yZXN0b3Jl
LmMKQEAgLTM4MSw2ICszODEsNyBAQCB4dGFibGVzX3Jlc3RvcmVfbWFpbihpbnQgZmFtaWx5LCBj
b25zdCBjaGFyICpwcm9nbmFtZSwgaW50IGFyZ2MsIGNoYXIgKmFyZ3ZbXSkKICAgICAgICAgICAg
ICAgIGJyZWFrOwogICAgICAgIGRlZmF1bHQ6CiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVy
ciwgIlVua25vd24gZmFtaWx5ICVkXG4iLCBmYW1pbHkpOworICAgICAgICAgICAgICAgZmNsb3Nl
KHAuaW4pOwogICAgICAgICAgICAgICAgcmV0dXJuIDE7CiAgICAgICAgfQoKCi0tCgoyLjQzLjAK
Cg==

