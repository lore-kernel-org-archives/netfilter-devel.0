Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.175.55.52])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65FC7DDA9;
	Thu,  3 Apr 2025 01:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.175.55.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743643456; cv=none; b=pfkI8WgUgZsNsdV5DfEBzKtBz6o1wtZDCskYjRMOw10kWgGEW1b+sPNRXNiHa7D7crj1CG+9ilVF/0+PH4JaGUlus0D4Jw/G4nbkPg9VprMiSf1mtxHxf+qL8llHmyw+7de7zgOhHCb20Pto0LIaB/8ZV8VstXGJE53a+KZNFGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743643456; c=relaxed/simple;
	bh=+l3bZjS10tE0fgEU9dciVxoDx73Jht0rQ+OBeJm4KuI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=uuvcPQJe4kIMx+PBPDqk21WFh5waMSRAJ/+U5btt2CB86QF04frRjNSGGAbwyUMX3uzY90K9HJ0oUi8xoex8k7xA3nI71JIQoLwlJsvJBL+h6TRVPuf98/k3H1Hq8KMAlit5M+PXhY2IF0PDtMte427lyHVAsirytqghsXL4Zlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=52.175.55.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.193.154.185])
	by mtasvr (Coremail) with SMTP id _____wDXHGwl4+1n9IoyAQ--.1245S3;
	Thu, 03 Apr 2025 09:23:49 +0800 (CST)
Received: from linma$zju.edu.cn ( [10.193.154.185] ) by
 ajax-webmail-mail-app2 (Coremail) ; Thu, 3 Apr 2025 09:23:47 +0800
 (GMT+08:00)
Date: Thu, 3 Apr 2025 09:23:47 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: "Lin Ma" <linma@zju.edu.cn>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Cc: kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	lucien.xin@gmail.com, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nft_tunnel: fix geneve_opt type
 confusion addition
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2024.2-cmXT6 build
 20241206(f7804f05) Copyright (c) 2002-2025 www.mailtech.cn zju.edu.cn
In-Reply-To: <Z-2e1xaxEw3DSZjd@calendula>
References: <20250402170026.9696-1-linma@zju.edu.cn>
 <Z-2NkQkl18OSJJuG@calendula> <Z-2e1xaxEw3DSZjd@calendula>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <860826b.13e51.195f93f43fb.Coremail.linma@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:zC_KCgA3resj4+1nd+geAQ--.28977W
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/1tbiAwcEEmftG7YLEAAFsr
X-CM-DELIVERINFO: =?B?xChkrAXKKxbFmtjJiESix3B1w3tPqcowV1L23Bze5QtIr9Db75bEBiiEybVhThS0pI
	APHlsfx8BtjI45WwoYeu/8B77bCxQDv8aKw4nv3GCmU9hAX7WJi+ep9KIWqpwcy0RWJAeO
	q3Mba6+PMmod1E8RsoeEBR6m/R3zuyZDxUDxk7YUbgrhNWlUZQmhQSfjMyD1xQ==
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29K
	BjDU0xBIdaVrnRJUUUQYb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26c
	xKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vE
	j48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxV
	AFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x02
	67AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI
	0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280
	aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0Y48Icx
	kI7VAKI48G6xCjnVAKz4kxM4xvF2IEb7IF0Fy264kE64k0F24lFcxC0VAYjxAxZF0Ex2Iq
	xwACI402YVCY1x02628vn2kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UMVCEFcxC0V
	AYjxAxZFUvcSsGvfC2KfnxnUUI43ZEXa7IU8nmRUUUUUU==

SGkgUGFibG8sCgo+ID4gCj4gPiBQYXRjaCBMR1RNLCBJIGNhbiB0YWtlIGl0IHRocm91Z2ggbmYu
Z2l0LCBJIGFtIHByZXBhcmluZyBhIHB1bGwKPiA+IHJlcXVlc3Qgbm93Lgo+IAo+IEFjdHVhbGx5
LCB0aGlzIGNodW5rIGlzIG1pc3NpbmcgaW4gdGhpcyBwYXRjaDoKPiAKCk5pY2UgY2F0Y2gsIHNv
IHRoaXMgY29uZnVzaW9uIHBvaW50ZXIgYWRkaXRpb24gbGVhZHMgdG8gYW4gb3V0LW9mLWJvdW5k
cwpyZWFkIGVpdGhlci4KClNlbnQgYSBuZXcgcGF0Y2ggdG8gaW5jbHVkZSB0aGlzIHNwb3QuCgpU
aGFua3MKTGluCg==

