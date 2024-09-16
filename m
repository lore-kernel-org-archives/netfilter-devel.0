Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9D0156861;
	Mon, 16 Sep 2024 15:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726499690; cv=none; b=cViNLJX6IIwnwLKgqh6dssQPgbtGxgn6x+prUDspALxbCNqGQFgiGlXFiv+7lO+wlMB0mZ8NS3bZEWvgIEz6FcR76VtTqixduNFAnuT0rzW57MONvJfmgINSiWRnfBsVWmx6KBBwAQPZxQNg5q4SMKoK95cZWXkPTd5siIKQ+xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726499690; c=relaxed/simple;
	bh=sYGjKu2SbL60ILFDiiCHKNCI4/gQEduli94xHixguHM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Xsk2Nf4HIDbHBWfkQ6je0g0vrkChrs9WFQxg8+LvsJlOFNAWyPkjviwQC1062XEOHcLh3rS8QRZ1OZ0Jgm9HMie0zIIs1Ix3Ft1ysEAPqTE2XN6szGZ9YjSQLLmmcRKUE2btAG5NAjMqt9UIurtGiAs6h11/f0INa5npEvm0JRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MIp2aOe7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MIp2aOe7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FD4C4CEC4;
	Mon, 16 Sep 2024 15:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726499690;
	bh=sYGjKu2SbL60ILFDiiCHKNCI4/gQEduli94xHixguHM=;
	h=From:Subject:Date:To:Cc:From;
	b=MIp2aOe78PXy80Grn/lhXc3EK+dJoVvyub5mae50g92Mff/9x39SeRJSgLjXJuGkT
	 nYtVUJke5OLyIOPFgp0JIJuFy3tP/iGSa3YM6lnqTzCy6Q0u80Fkzl9rL/LE88bVu5
	 fUAtuC4lClydnrlzOuQCbGksKOkC7piv5xOOhbCpz/fccxKEB7rBOjCsF6yXJfiU9m
	 dWnDYc8PoWvHgZIgFdPpg7G1MN/ClVhf+vpYdTlS/VEe/6bxSnjPm6o8KDDNa2b5ej
	 qp1RGZqa4FYzMg5mvTFkRTda2Z7IDguISZOABEip+Uok08wlEryw2+G6/23WBuBhCt
	 RU4k9OnYVqPKA==
From: Simon Horman <horms@kernel.org>
Subject: [PATCH nf-next 0/2] netfilter: conntrack: label helpers
 conditional compilation updates
Date: Mon, 16 Sep 2024 16:14:40 +0100
Message-Id: <20240916-ct-ifdef-v1-0-81ef1798143b@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGBL6GYC/x3MQQqAIBBA0avErBswy8CuEi1Kx5qNhUoI4t2Tl
 g8+v0CkwBRh6QoEejny7RuGvgNz7f4kZNsMUshJ6GFGk5CdJYeHNaNWhyKrDLT8CeQ4/6sVvEN
 POcFW6wcbUMPNYwAAAA==
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org, llvm@lists.linux.dev
X-Mailer: b4 0.14.0

Hi,

This short series updates conditional compilation of label helpers to:

1) Compile them regardless of if CONFIG_NF_CONNTRACK_LABELS is enabled
   or not. It is safe to do so as the functions will always return 0 if
   CONFIG_NF_CONNTRACK_LABELS is not enabled.  And the compiler should
   optimise waway the code.  Which is the desired behaviour.

2) Only compile ctnetlink_label_size if CONFIG_NF_CONNTRACK_EVENTS is
   enabled.  This addresses a warning about this function being unused
   in this case.

Found by inspection.
Patches have been compile tested only.

---
Simon Horman (2):
      netfilter: conntrack: compile label helpers unconditionally
      netfilter: conntrack: conditionally compile ctnetlink_label_size

 net/netfilter/nf_conntrack_netlink.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

base-commit: d5c4546062fd6f5dbce575c7ea52ad66d1968678

