Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1232773EC;
	Thu, 19 Mar 2026 02:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773886375; cv=none; b=KHOHhkAcVOeWA7K+8UTGwcvxlENi3TSfA1x0wDGNoInJt8ZkCAlq9xhdcxKTcwhwFbw/STUiCxeJjRl01bwe7SVTc6/ccrKHFHUttsAyCamKTkkkcQSxaCLsrhWLLx10VO9v3396ssKO09I/KXmwWLyr6o0RxPiyvebjVq8ueQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773886375; c=relaxed/simple;
	bh=isOd1yA2u/h/10L8fcq1bdiXLuELx0njKYaMapTidw8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NZ0uO7h5o352N+pe7UeTvNXchjxMATdnHY21NrwtBXBQ54K5YhhYXTiJBUNbRXJnzuj7kSzbiV/3hGkGfsJDRBJI1SVLGmK8+MrcF6Ci6c7fMrFpiMDWN4rMkfl9NBkWd4IKQAFQu3rsGrGfNtZmsW3ceT51ZZnQqWqHmmFF660=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f8XH1Lit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f8XH1Lit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C1FC19421;
	Thu, 19 Mar 2026 02:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773886375;
	bh=isOd1yA2u/h/10L8fcq1bdiXLuELx0njKYaMapTidw8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=f8XH1LitiKxgUa8TfAuu46gAHm8neCzkuMcp2FZaOHPZ/J/CbL9n6DUNeymQlWq8i
	 wOSwj/bKxdUJJFCIMMmhI0ycVwXAxZuP4iHG9inYFaBYSBUBnC5L5r/4aoA7XwwJGw
	 nhiaCe8VIFHPbVVFide6sIhaCbcuQvIB2NAXK2afSDxrUkUkrnmfeP7ISjApQcv+Ji
	 NOE3k8sKW0bVerx7giTfhSXvU4xgnOqsCm0DEGrStcvb+0ShhDczXLgPjP+1MeFO9d
	 kd6XUP7v+8u+K9rz3llGcanATtlX3SomthkNtFk9BNiuoYqsaFu5AJV5Sj3Cdq7XZw
	 p62BwyN4QkWcQ==
Date: Wed, 18 Mar 2026 19:12:54 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Ahmed Zaki <anzaki@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
 coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 1/2] net: treewide: pass number of pkts to
 dev_sw_netstats_rx_add()
Message-ID: <20260318191254.30d5124d@kernel.org>
In-Reply-To: <20260317234851.234466-2-anzaki@gmail.com>
References: <20260317234851.234466-1-anzaki@gmail.com>
	<20260317234851.234466-2-anzaki@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 17 Mar 2026 17:48:50 -0600 Ahmed Zaki wrote:
> Allow callers of dev_sw_netstats_rx_add() to update the netdev stats
> with multiple packets.

Please don't. If you have to change almost 30 users to add one you're
probably doing something wrong with the interface.
