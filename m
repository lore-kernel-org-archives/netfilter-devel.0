Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6341B146D6E;
	Fri,  4 Oct 2024 11:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728040427; cv=none; b=CprRq3g3bGHQx25atY2WNOON1tB4t4IB5rRnT1v5i/PJNniV2Cv/fNNI8JZjt+dPJMh3O79QdFtcfQnbasSH5WyueCQKmGnYDjKSxu9wStvL2RQ3hCqRCgFEtIiuTCK0bo8PxzeRyARf+yQSRVRdHQ5+4qGQXmqW4Wpcqhf7XYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728040427; c=relaxed/simple;
	bh=l24gZDr21kjM3jQ8UIAm6vu1SP/Iy+tb7aNtN3d4/z8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sd68BH8eBsy3LHFEBh+ohgwj11Y3ZUk1ojM9UmQx0wFt3quGmT4DQ/jEu9haI+hzOVlQptfxQn6YidHFSFOKDqsrhwifVLNLmDJS8MnhjbQTXrZjf6XIOAVzwNPpt6K6hKsvtRFmDRavhnW5TS30ThZ1GNxYvad8omEuTeFDWhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=54068 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1swgFf-00FASe-2W; Fri, 04 Oct 2024 13:13:41 +0200
Date: Fri, 4 Oct 2024 13:13:38 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2 2/2] netfilter: nf_tables: Fix percpu address space
 issues in nf_tables_api.c
Message-ID: <Zv_N4vhjAw2-n6gp@calendula>
References: <20240829154739.16691-1-ubizjak@gmail.com>
 <20240829154739.16691-3-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240829154739.16691-3-ubizjak@gmail.com>
X-Spam-Score: -1.8 (-)

On Thu, Aug 29, 2024 at 05:29:32PM +0200, Uros Bizjak wrote:
> Compiling nf_tables_api.c results in several sparse warnings:
> 
> nf_tables_api.c:2077:31: warning: incorrect type in return expression (different address spaces)
> nf_tables_api.c:2080:31: warning: incorrect type in return expression (different address spaces)
> nf_tables_api.c:2084:31: warning: incorrect type in return expression (different address spaces)
> 
> nf_tables_api.c:2740:23: warning: incorrect type in assignment (different address spaces)
> nf_tables_api.c:2752:38: warning: incorrect type in assignment (different address spaces)
> nf_tables_api.c:2798:21: warning: incorrect type in argument 1 (different address spaces)
> 
> Use {ERR_PTR,IS_ERR,PTR_ERR}_PCPU() macros when crossing between generic
> and percpu address spaces and add __percpu annotation to *stats pointer
> to fix these warnings.
> 
> Found by GCC's named address space checks.
> 
> There were no changes in the resulting object files.

ERR_PTR,IS_ERR,PTR_ERR}_PCPU() dependency is now in nf-next.git.

Applied, thanks
