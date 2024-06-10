Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BB612F5B6;
	Mon, 10 Jun 2024 22:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718056829; cv=none; b=F9sOL8uzKH7qSN8EZqswYLpINSi3LaGlDaefZSjVzQC5oxiGFKkC/kMi/vJJXGWCdZU5MnQH1BCS4WA9MkwX141nesI9z144+d/EC0oVgnd6ZwihllyLZi4yww7lmC+yFb0TbHy0ltAhWrYiEha9hMHKdyxmZMgyyqnCbSWrAjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718056829; c=relaxed/simple;
	bh=w+QNB7r4CqQW4TWLWYmCrEsv0NH+RNNKh5FWZsabV7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DOU/f/+2r0PAh4CP6t5/xVKlV9lYb9HQag/MP4WuHAmBa1wRYlP6T/q0CJBu3h2TSdY/rscgMwweuf/tybCc9kqWHoD2JCuJTTZCRV/0iw0ZdU3/prCJbpSUIK700m4Uwws7AuoZHZA0J4WvI/mEl07pGURXQfA3XnWhYpCCIAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=44204 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sGn3W-001KhA-DR; Tue, 11 Jun 2024 00:00:00 +0200
Date: Mon, 10 Jun 2024 23:59:57 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: netfilter-devel@vger.kernel.org,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: Testing stable backports for netfilter
Message-ID: <Zmd3XaiC_GiCakyf@calendula>
References: <652cad2e-2857-4374-a597-a3337f9330f0@oracle.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <652cad2e-2857-4374-a597-a3337f9330f0@oracle.com>
X-Spam-Score: -1.9 (-)

On Mon, Jun 10, 2024 at 11:51:53PM +0530, Harshit Mogalapalli wrote:
> Hello netfilter developers,
> 
> Do we have any tests that we could run before sending a stable backport in
> netfilter/ subsystem to stable@vger ?
> 
> Let us say we have a CVE fix which is only backported till 5.10.y but it is
> needed is 5.4.y and 4.19.y, the backport might need to easy to make, just
> fixing some conflicts due to contextual changes or missing commits.

Which one in particular is missing?

> One question that comes in my mind is did I test that particular code, often
> testing that particular code is tough unless the reproducer is public. So I
> thought it would be good to learn about any netfilter test suite(set of
> tests) to run before sending a backport to stable kernel which might ensure
> we don't introduce regressions.

There is tests/shell under the nftables userspace tree, it also
detected the features that are available in your kernel.
