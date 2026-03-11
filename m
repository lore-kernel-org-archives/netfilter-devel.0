Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D94A362130
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2026 15:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773241621; cv=none; b=daGmZNmXnvMbnkXebP+F//yJKz42Urcl5O3YZaU3lzGr7NI3jpju8uoxbRYkaRRXX0hcTRSSiAaLShG1XKiuGmQSEWQok5pNhlmoffbIpL9xa8tFsovqTFfQ8waYBqIc8/FvFp6/qKjlcXw4tRZAz3kSL3y/mzGtMNOVY0tSgq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773241621; c=relaxed/simple;
	bh=1kctEnvWyJhcYjQoqegE2wKkHspARHJCD6BlbuGpaI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E+KUwpctmyyrTreZps3HGIEInNSyXnWRUrdBhKomS2AvEsaMJwZf8N08azLfXhmdjzu74NDVDfIYe9Ip1PkkYHo03RksDHq1uQUfPhHoP/SWUYGIbgWYLBpUffpyztza+TflhDcOl/edjhMO/j/N8dJsPl1jvHGWbz0AcnCYbxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GzJm4jPy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GzJm4jPy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773241619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T1SA5o2jH+bQRrh9MvZBdIZ9fwAX2hSRj62Tfp/ST44=;
	b=GzJm4jPyNV+XGEdeE3rUV1VCaaHcOuq+ebFTCvFVvdp3P39GjiDED7SvFOUoeY4JIQFqF1
	rwkOZS23+OGv4dpy9bcuVqUVTCVVee7CfJ7WHlNimtp352wMrKQ7S+ClzPymf0HV5Goy6u
	rozxg/XCn8wAJWFAinXeC3xO1ByCGQM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-624-eQRUJ-nbMemSAYS_CoQnbw-1; Wed,
 11 Mar 2026 11:06:57 -0400
X-MC-Unique: eQRUJ-nbMemSAYS_CoQnbw-1
X-Mimecast-MFC-AGG-ID: eQRUJ-nbMemSAYS_CoQnbw_1773241616
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with UTF8SMTPS id DFAE81956061;
	Wed, 11 Mar 2026 15:06:55 +0000 (UTC)
Received: from localhost (unknown [10.22.81.7])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with UTF8SMTP id 53B57180035F;
	Wed, 11 Mar 2026 15:06:55 +0000 (UTC)
Date: Wed, 11 Mar 2026 11:06:52 -0400
From: Eric Garver <eric@garver.life>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/5] Enhance cache filter for list commands
Message-ID: <abGFDGtr6Lk6dJYq@egarver-mac>
Mail-Followup-To: Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20260310231115.25638-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310231115.25638-1-phil@nwl.cc>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Wed, Mar 11, 2026 at 12:11:10AM +0100, Phil Sutter wrote:
> Reducing the amount of data fetched from kernel improves performance
> with large rule sets but also reduces adverse side-effects if multiple
> versions of nftables access the same kernel rule set. Being able to
> ignore parts of the rule set one is not interested in allows for (more or
> less) safe coexistence if each tool is operating on the data it created
> itself only.
> 
> This series reduces caching for list commands which specify a family
> and/or table. To help testing this, patch 1 extends netlink debug output
> to include chains, flowtables and objects so a test case may check if
> they are fetched or not.
> 
> The remaining patches actually increase filter use.
> 
> Phil Sutter (5):
>   cache: Include chains, flowtables and objects in netlink debug output
>   cache: Respect family in all list commands
>   cache: Relax chain_cache_dump filter application
>   cache: Filter for table when listing sets or maps
>   cache: Filter for table when listing flowtables
> 
>  src/cache.c                                 | 11 ++--
>  src/mnl.c                                   | 60 ++++++++++++++++++---
>  tests/shell/testcases/listing/cache_filters | 53 ++++++++++++++++++
>  3 files changed, 113 insertions(+), 11 deletions(-)
>  create mode 100755 tests/shell/testcases/listing/cache_filters

I ran this series against the firewalld testsuite. All green.
Thanks Phil!

For the series:

Tested-by: Eric Garver <eric@garver.life>

