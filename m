Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sz1Cznxh"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001DBE3
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2023 06:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702476499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+NO7O5VDdWK2dEhEEAPSKsTHCWSFCqqoJTZDmUKn05k=;
	b=Sz1CznxhzIV+6rzYTvnMa5xcc+reuejGcwJM+X4I22//YXy3WHdORj0qSsrVZtJBDdBWWZ
	mDhbwKf1/gw8+juaradiXgavrCGj+wT4EDNjKuow4VkvO338k5lMMJi0R6dnQ2zrThetln
	Mal/aNqoTiMm5c+I4cQADFrxazHyK7E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-0RhHlYB6PD2E_nhaeTyo-A-1; Wed, 13 Dec 2023 09:08:16 -0500
X-MC-Unique: 0RhHlYB6PD2E_nhaeTyo-A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 849CD88CDD5;
	Wed, 13 Dec 2023 14:08:14 +0000 (UTC)
Received: from localhost (unknown [10.22.10.1])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 39E002026D66;
	Wed, 13 Dec 2023 14:08:13 +0000 (UTC)
Date: Wed, 13 Dec 2023 09:08:12 -0500
From: Eric Garver <eric@garver.life>
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nf-next PATCH] netfilter: nf_tables: Support updating table's
 owner flag
Message-ID: <ZXm6zI16aVSwvEDB@egarver-mac>
Mail-Followup-To: Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20231208130103.26931-1-phil@nwl.cc>
 <ZXhbYs4vQMWX/q+d@calendula>
 <ZXiI58QCVek1rWiF@orbyte.nwl.cc>
 <ZXji-iRbse7yiGte@egarver-mac>
 <ZXmgAu3u2w+Xjh8+@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXmgAu3u2w+Xjh8+@orbyte.nwl.cc>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Wed, Dec 13, 2023 at 01:13:54PM +0100, Phil Sutter wrote:
> Hi,
> 
> On Tue, Dec 12, 2023 at 05:47:22PM -0500, Eric Garver wrote:
> > I'm not concerned with optimizing for the crash case. We wouldn't be
> > able to make any assumptions about the state of nftables. The only safe
> > option is to flush and reload all the rules.
> 
> The problem with crashes is tables with owner flag set will vanish,
> leaving the system without a firewall.

I'd rather see the daemon be automatically restarted. After a crash you
still have a flush + re-apply on daemon restart. Avoiding the cleanup
due to table owner flag only shortens the window.

I think we're getting off topic for this list. Let's discuss off list if
you want. :)

[..]

