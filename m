Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9AED281;
	Wed, 31 Jan 2024 02:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706668653; cv=none; b=djDxJhtR0bkuHyvJPSnNYLZBHaVHQ6+QQLguiBsqL1IsT5P0FiYmyqi9YxI7yBXt5Ll5wEovOvy5T+DTsOTdTwvSHPjXjwy987GnzWBEgVBze3FRpYaSlp8AROFqHRS/FJsNnJbdmESR3ysxokHKmVdxCX0rKqrtu71ZNrXy3dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706668653; c=relaxed/simple;
	bh=+cnZWvnJ3a2mSXSAnVOJI2jpuhRDcN5ZswP7A+LFkGo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gg/e6j/c2ZTJRvIB3tG+LuZncwAHw5IT9CStMR8W38tdjo5dVaoFBLrrpzu6yAEM0VKf4QaON1bDGKPhvXEXgBXLaPJqoHplZxGXbVxzFNTR93G867lsSpFC/AJgyRvutIlfVfZFoLsfEEFWSbbQl37UK9cwY3s395oxtbt6PoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cqwLgQBO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cqwLgQBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FE5C433F1;
	Wed, 31 Jan 2024 02:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706668653;
	bh=+cnZWvnJ3a2mSXSAnVOJI2jpuhRDcN5ZswP7A+LFkGo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cqwLgQBOoniNiAFvzT+ldlXm1uq1Cye6AV8QgANE1XZi8TafcfTTpIvSg2ifgcEBw
	 25EH+5I3ricJUyNlOf5PwiV5xOnG0msbKahneTKzwAClLhLl8VJBDga/Y+LLcZfsMD
	 ukk0VXbZXDEBxCVNHfjO+9qGCYYh7bPVOIA4lJXyTHA2sPIM4HoWXSWwu8lnNkxJan
	 5ypeISg5l+hNmMbnBEZCCfGXUZypMnCK1DYZxQPG2/DUJXg89ZONAF5k8sBCJ3QXbH
	 66XbpHX4o28uzHBOZ8gP/vTvtcsPCv0QOLRxW+tum4EaHuQyM7MQPxDfZokNo7NM39
	 UBI972XTThzPw==
Date: Tue, 30 Jan 2024 18:37:29 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 0/9] netfilter updates for -next
Message-ID: <20240130183729.5925c86d@kernel.org>
In-Reply-To: <20240129145807.8773-1-fw@strlen.de>
References: <20240129145807.8773-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 29 Jan 2024 15:57:50 +0100 Florian Westphal wrote:
> Hello,
> 
> This batch contains updates for your *next* tree.

The nf-next in the subject is a typo, right? It's for net-next?
Looks like it but better safe than sorry :)
