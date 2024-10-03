Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8393617579;
	Thu,  3 Oct 2024 00:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727914630; cv=none; b=mRQAVNu8U+HjrYPsMPDTYnxPx7iyzz89Xl4F1aJIvkfwdRNBGhk49wbO8hC5N9VdAIaoZCs5rqkrE8PrBVEolcHwd6bMtQcO1AR0fFBc9jQEhqHTdYM+hgB0EyvQLoy1Y+YVUr40QzySpPqOpVGzhQtUfz6a02B8ulTtSaGhgaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727914630; c=relaxed/simple;
	bh=tWyRm8Lfa+rKaFfoZA2cLzbpCCMrkqGI33lmc8D7c20=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SVv8MNizbeUIjzpBfu0CzFt5U/A9Y8Ori3v8yb5Z8UC2W/3y7/E8SGQ48lv5w5rJUtONkFBMBtyW1NC1XLq3AKSbymnRXOOTBu4nZgi0+Ux1rN6+cFO3o1ez2AiMkGCBPub+CSvQOsBSLE4VvVMuaemU00efK0+UPQJalI0imgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I4upehMH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I4upehMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963C2C4CEC2;
	Thu,  3 Oct 2024 00:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727914630;
	bh=tWyRm8Lfa+rKaFfoZA2cLzbpCCMrkqGI33lmc8D7c20=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=I4upehMHvwfyxCLST9zMsz/vsgtgezf2qmeud5SfMeBoRUG5sW6Rnwzg+5P8SUtdn
	 xDwQCtITBL4j/mbeQHJe83llLZjMLtr/Re2hpUtCAFQ1/c+dRR35iydsC7NPo0q6gT
	 ZT+Zo16akYVqLboeQgTFpaL3Hvg+nZ63U+4Eeao7ZSK0851Rl6Z8R8b165GCTZFbCt
	 n2RT/yVUQBgwab7X0pSqnax19o5GXxebnswYbA193yLXFiqazhF+n/JoVk9HfLbLr0
	 pnGeOxIZ2X5HkrSMr5P9Xs2PX27uWoiYd38H6OVL56wQA5KBTvVuXlMcVri9ARk1TN
	 my8fhzgcoAPFg==
Date: Wed, 2 Oct 2024 17:17:08 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: yushengjin <yushengjin@uniontech.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, roopa@nvidia.com,
 razor@blackwall.org, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 bridge@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, gouhao@uniontech.com
Subject: Re: [PATCH v4] net/bridge: Optimizing read-write locks in
 ebtables.c
Message-ID: <20241002171708.05f46286@kernel.org>
In-Reply-To: <A872628EC4B98B9E+20240925083745.179397-1-yushengjin@uniontech.com>
References: <A872628EC4B98B9E+20240925083745.179397-1-yushengjin@uniontech.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 25 Sep 2024 16:37:45 +0800 yushengjin wrote:
> When conducting WRK testing, the softirq of the system will be very high.
> forwarding through a bridge, if the network load is too high, it may
> cause abnormal load on the ebt_do_table of the kernel ebtable module, leading
> to excessive soft interrupts and sometimes even directly causing CPU soft
> lockup.

FTR I'm leaving this one to netfliter folks.
-- 
pw-bot: au
