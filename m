Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.215])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8D534439E;
	Wed, 10 Jan 2024 10:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="hE1oeo/f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=BEnR5
	9z9wMRhjDNJz3gaSHgwKAmRI67JW9/IsxhcCkU=; b=hE1oeo/fCWD8ZhmSzGd+H
	uMyQ5FYCVhxT8JhFKlWkdj4d0HfgS2G+oKdQN+Zw6j/sd+sGZFdeUHQ6mBN1yw57
	1hEfdEonfswh92Y0c+5DeRKbffExPpiriclOizP0AKjirSF7Qm9LwFKJ2Raw8DHw
	EIqc/1PrGUg9HCieG6RmhE=
Received: from localhost.localdomain (unknown [111.35.187.31])
	by zwqz-smtp-mta-g5-2 (Coremail) with SMTP id _____wD3H44ucJ5lJdMfAw--.1486S4;
	Wed, 10 Jan 2024 18:23:50 +0800 (CST)
From: David Wang <00107082@163.com>
To: ale.crismani@automattic.com,
	kadlec@netfilter.org,
	xiaolinkui@kylinos.cn,
	pablo@netfilter.org
Cc: linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Subject: Re: Performance regression in ip_set_swap on 6.1.69
Date: Wed, 10 Jan 2024 18:23:42 +0800
Message-Id: <20240110102342.4978-1-00107082@163.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <C0829B10-EAA6-4809-874E-E1E9C05A8D84@automattic.com>
References: <C0829B10-EAA6-4809-874E-E1E9C05A8D84@automattic.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3H44ucJ5lJdMfAw--.1486S4
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUYHUqUUUUU
X-CM-SenderInfo: qqqrilqqysqiywtou0bp/xtbBEhJhqmVOBjJAZgAAsy

I confirmed this on 6.7 that this was introduced by commit 28628fa952fefc7f2072ce6e8016968cc452b1ba with following changes:

	 static inline void
	@@ -1397,6 +1394,9 @@ static int ip_set_swap(struct sk_buff *skb, const struct nfnl_info *info,
		ip_set(inst, to_id) = from;
		write_unlock_bh(&ip_set_ref_lock);
	 
	+       /* Make sure all readers of the old set pointers are completed. */
	+       synchronize_rcu();
	+
		return 0;
	 }

synchronize_rcu causes the delay, and its usage here is very confusing, there is no reclaimer code after it.


FYI
David



 


