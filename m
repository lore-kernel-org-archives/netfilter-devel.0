Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E741E532
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2024 17:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707325600; cv=none; b=eiGz9QAbZJfPiyMzbvWtmqC9nfIMYTf7Q6WMv2PCaftyF0POyFNzj38QNNi8byXgHr38pYLqrxdV7CZ6fNdntpx8bq9C94oaSNPHZmjW+t+mvtqtl01bEBIOlPQJvknmQ3BaOWPD37HS51zB6GrXK+OFum+TUadgG7a6/5Xwasw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707325600; c=relaxed/simple;
	bh=Vomkg/9E+xflwe1TKPYBMmgCBIqvYkNvoHrFspYPC0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OY7C1BrtYBKWh/iIDcGoyYz+e0oz1Ab16fhTID+VsvXomDOrV31X7KfBq2c/LjGYMg4y/4C8c+HT68wZSI5qXoo4UPVvvbcDDjYgM9/JsuU7V7MEPV64Btymih+G+Lgesb2c3ATosHRj/dbAPj4s9Bf8iyRDZAj+hgi0yXErJTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=pTWEUVhu; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pTWEUVhu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vHagVUYAX/DUVAiuDUCmLCPh4Ysa5cSFTHTqVGi6+zg=; b=pTWEUVhuZ/6KkUNyt4HpWdsRhv
	zw90AaXvqLJIbC80AaYSvTFaG9Cd4C0IPAu92bFX1mJ5sXGTqLEsDLytH77qAlRKM3wOfEA7Ny1+U
	IBZYFX16KuCYQe+K9BJoCJbbK6UCvT568Ui3J1v2zluV71Dyj+pqXhc/FKki0GWxfMVkw8S9YHLJ0
	/xv9iKXuxoVo7acSpQdSK9zokrNQ1g9OGlvCfezyB4Fc0WBvb/R6oYL6aTgasepPX95xP0eHiYwwF
	VLx4JbvOfp5hvnmi8ibpi17tSVsNVXrD98WMbp616RcNUUwVUhx7RApIu0cDkE5x9YEVKPR00URPK
	KEURoG6Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rXlNZ-000000006hV-034u;
	Wed, 07 Feb 2024 18:06:33 +0100
Date: Wed, 7 Feb 2024 18:06:32 +0100
From: Phil Sutter <phil@nwl.cc>
To: =?utf-8?B?6LCi6Ie06YKmIChYSUUgWmhpYmFuZyk=?= <Yeking@Red54.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v3] evaluate: fix check for unknown in cmd_op_to_name
Message-ID: <ZcO4mPIjziQFSfHZ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	=?utf-8?B?6LCi6Ie06YKmIChYSUUgWmhpYmFuZyk=?= <Yeking@Red54.com>,
	netfilter-devel@vger.kernel.org
References: <tencent_FC8F6CE01EED438FA435FB1FD8337B3BCD06@qq.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_FC8F6CE01EED438FA435FB1FD8337B3BCD06@qq.com>

On Wed, Feb 07, 2024 at 03:10:20PM +0000, 谢致邦 (XIE Zhibang) wrote:
> Example:
> nft --debug=all destroy table ip missingtable
> 
> Before:
> Evaluate unknown
> 
> After:
> Evaluate destroy
> 
> Fixes: e1dfd5cc4c46 ("src: add support to command "destroy"")
> Signed-off-by: 谢致邦 (XIE Zhibang) <Yeking@Red54.com>

Patch applied, thanks!
