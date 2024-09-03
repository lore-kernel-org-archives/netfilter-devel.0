Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781EE45003
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Sep 2024 08:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725351749; cv=none; b=LRGKmuTS9hR9NFUHjOXCDGAW/cPfjWSFjluzyP7zPGG0z5kbUfxWNg0BGVad6i6vdWPJBk4D7PxndhBdO+aXfkv/cWS8CZgTwnxNsMF8pwLH5goza/IKOA7cptMW2BZJHiCskr5i2+UDYNUc7G5vVdb0kL5GrUk+fS1XnCTQ7CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725351749; c=relaxed/simple;
	bh=FA5q3DAhJPQrgnou6zN0D5ncg5yPK/3i5xC7YjQq+DM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M6Nasrlo1esjq32XrboZl1bOS4/AWY/xPb2TMkTNdZSuPwdN4CULXoq7/qHsvXqj10HO9l+IYFZv2NcapBdqGCvHDj/8cg4kR0xI4P4WrDep3RiQMxWHKT67yHFcgBP70ymN8Kw0LXrHS5j9VaVOk0dqu3LChyYg95FqE59kWRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=43636 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1slOni-00ADWx-Gh; Tue, 03 Sep 2024 10:22:12 +0200
Date: Tue, 3 Sep 2024 10:22:09 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ahelenia =?utf-8?Q?Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] conntrack: -L doesn't take a value, so don't discard one
 (same for -IUDGEFA)
Message-ID: <ZtbHMe6STK_W6yfA@calendula>
References: <hpsesrayjbjrtja3unjpw4a3tsou3vtu7yjhrcba7dfnrahwz2@tarta.nabijaczleweli.xyz>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <hpsesrayjbjrtja3unjpw4a3tsou3vtu7yjhrcba7dfnrahwz2@tarta.nabijaczleweli.xyz>
X-Spam-Score: -1.9 (-)

On Tue, Sep 03, 2024 at 04:16:21AM +0200, Ahelenia Ziemiańska wrote:
> The manual says
>    COMMANDS
>        These options specify the particular operation to perform.
>        Only one of them can be specified at any given time.
> 
>        -L --dump
>               List connection tracking or expectation table
> 
> So, naturally, "conntrack -Lo extended" should work,
> but it doesn't, it's equivalent to "conntrack -L",
> and you need "conntrack -L -o extended".
> This violates user expectations (borne of the Utility Syntax Guidelines)
> and contradicts the manual.
> 
> optarg is unused, anyway. Unclear why any of these were :: at all?

Because this supports:

        -L
        -L conntrack
        -L expect
