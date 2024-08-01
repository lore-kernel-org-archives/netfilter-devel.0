Received: from smtp-bc0a.mail.infomaniak.ch (smtp-bc0a.mail.infomaniak.ch [45.157.188.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E861EB4A2
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Aug 2024 16:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.157.188.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722528099; cv=none; b=ny99WAJDdQbSQg5Sc5AWqPKnOuEOF5JKT7qIs8KCmvP3jorHRZVbakx61DExcUnO8OPASszw3EMRkZgeI2at1O5tIE41+XeHm9uP3bmTyWyvnpGNL2DWwQAoWlGWZXHLuoxhLa0fOq3FOD4jRs4O5MSXLrdgPYJFWdfBfTNco0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722528099; c=relaxed/simple;
	bh=45yB8yF0V5hIkICg1x8b1vulfM9LSnFufHVSgPmniTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fosSUIKu3OMTKTcos0Fp0zbvpCW3ZmukFwTKtw+jxHRsYTqQoUXwxma2V8Xk+2hhLNd5ZH5YlQ/FtW84uCRn2Qp2xx2GXW2MdxNcDXDMm4+WFD1cbZP07WFGzDVRNiQ5QpQ8E2TEv705hOcMTdusliUAJk/ftEnnMF1t6F+AlBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=OZZ64Xjc; arc=none smtp.client-ip=45.157.188.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="OZZ64Xjc"
Received: from smtp-4-0000.mail.infomaniak.ch (smtp-4-0000.mail.infomaniak.ch [10.7.10.107])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4WZYcB5HXkzNW5;
	Thu,  1 Aug 2024 18:01:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1722528090;
	bh=X7LSKL3+/n7qtF/prYYHJdu0GTbfDpVACKcRIlnRM60=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OZZ64Xjcl++YpnEKFkfRknQHNtyHvbkK5HyzIx78L7cblHJlZIEL+m0ChQr/HenvG
	 xDwqHXo9D6sQSd0OehF/BVsyQGyA/GsV1N31HCsAa2ShhjOXgT/yubWhd5Vb0JEbYy
	 B1TQ+tx/8yC8Ij/mft0cABolKtPLmRSdyOUPtE58=
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4WZYc96bL6zqdN;
	Thu,  1 Aug 2024 18:01:29 +0200 (CEST)
Date: Thu, 1 Aug 2024 18:01:25 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	yusongping@huawei.com, artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Subject: Re: [RFC PATCH v1 2/9] landlock: Support TCP listen access-control
Message-ID: <20240801.eeBaiB4Ijion@digikod.net>
References: <20240728002602.3198398-1-ivanov.mikhail1@huawei-partners.com>
 <20240728002602.3198398-3-ivanov.mikhail1@huawei-partners.com>
 <20240731.AFooxaeR5mie@digikod.net>
 <68568a44-2079-33ac-592d-c2677acf50dd@huawei-partners.com>
 <20240801.EeshaeThai9j@digikod.net>
 <7c8ed332-c4ec-81e7-a94a-e1b62d820dd3@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7c8ed332-c4ec-81e7-a94a-e1b62d820dd3@huawei-partners.com>
X-Infomaniak-Routing: alpha

On Thu, Aug 01, 2024 at 06:34:41PM +0300, Mikhail Ivanov wrote:
> 8/1/2024 5:45 PM, Mickaël Salaün wrote:
> > On Thu, Aug 01, 2024 at 10:52:25AM +0300, Mikhail Ivanov wrote:
> > > 7/31/2024 9:30 PM, Mickaël Salaün wrote:
> > > > On Sun, Jul 28, 2024 at 08:25:55AM +0800, Mikhail Ivanov wrote:
> > > > > LANDLOCK_ACCESS_NET_BIND_TCP is useful to limit the scope of "bindable"
> > > > > ports to forbid a malicious sandboxed process to impersonate a legitimate
> > > > > server process. However, bind(2) might be used by (TCP) clients to set the
> > > > > source port to a (legitimate) value. Controlling the ports that can be
> > > > > used for listening would allow (TCP) clients to explicitly bind to ports
> > > > > that are forbidden for listening.
> > > > > 
> > > > > Such control is implemented with a new LANDLOCK_ACCESS_NET_LISTEN_TCP
> > > > > access right that restricts listening on undesired ports with listen(2).
> > > > > 
> > > > > It's worth noticing that this access right doesn't affect changing
> > > > > backlog value using listen(2) on already listening socket.
> > > > > 
> > > > > * Create new LANDLOCK_ACCESS_NET_LISTEN_TCP flag.
> > > > > * Add hook to socket_listen(), which checks whether the socket is allowed
> > > > >     to listen on a binded local port.
> > > > > * Add check_tcp_socket_can_listen() helper, which validates socket
> > > > >     attributes before the actual access right check.
> > > > > * Update `struct landlock_net_port_attr` documentation with control of
> > > > >     binding to ephemeral port with listen(2) description.
> > > > > * Change ABI version to 6.
> > > > > 
> > > > > Closes: https://github.com/landlock-lsm/linux/issues/15
> > > > > Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> > > > 
> > > > Thanks for this series!
> > > > 
> > > > I cannot apply this patch series though, could you please provide the
> > > > base commit?  BTW, this can be automatically put in the cover letter
> > > > with the git format-patch's --base argument.
> > > 
> > > base-commit: 591561c2b47b7e7225e229e844f5de75ce0c09ec
> > 
> > Thanks, the following commit makes this series to not apply.
> 
> Sorry, you mean that the series are succesfully applied, right?

Yes, it works with the commit you provided.  I was talking about a next
(logical) commit f4b89d8ce5a8 ("landlock: Various documentation
improvements") which makes your series not apply, but that's OK now.
