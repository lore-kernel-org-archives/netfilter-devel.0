Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101C0819
	for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2024 12:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984168; cv=none; b=jHkqY6B7DQ8Hd2ts6B/nLEMGUK1jHBYIOZo4iP9jcqZpl09d18G0YCmTLFUcJgJNDI2nY8yBTuVw72IhgqmG8mMdEzPJdSEH/LTc0MakQV6gmAuPsxWTxrXe07wT+v5hw8yZu+qsp+kn60xKghqwGgPeNxNmr/mayM8Fio66Qzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984168; c=relaxed/simple;
	bh=CfDoVBClKgPHYDLSoB1bbT3YW3boe6j/xWG8Eho45oQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f903atzKGKGTCdVTK0AJSswSed7iz+o4oOdbYiJCw7kSK8bDZHjE6k13aKWaPxYzXH++IwQJPunITuOyS/vdpxqiQC9Vps4NUa3rd4HCgX0vBDN5tvUfCU+RRcW5JtZ7+F33NrrhTRL7WzTqk4LzD13v4pQ3HEOuLC5gqiw2SEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sCI0s-0003DV-FN; Wed, 29 May 2024 14:02:38 +0200
Date: Wed, 29 May 2024 14:02:38 +0200
From: Florian Westphal <fw@strlen.de>
To: Yunjian Wang <wangyunjian@huawei.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, kuba@kernel.org, davem@davemloft.net,
	coreteam@netfilter.org, xudingke@huawei.com
Subject: Re: [PATCH net] netfilter: nf_conncount: fix wrong variable type
Message-ID: <20240529120238.GA12043@breakpoint.cc>
References: <1716946829-77508-1-git-send-email-wangyunjian@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1716946829-77508-1-git-send-email-wangyunjian@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Yunjian Wang <wangyunjian@huawei.com> wrote:
> 'keylen' is supposed to be unsigned int, not u8, so fix it.

Its limited to 5, so u8 works fine.
