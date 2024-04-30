Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F2DA143744
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2024 15:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714490959; cv=none; b=KK9AfKsMTO50BPXuwhmIxM5H8BwIXmkrOsp7KOqUALedDiaRL8XTp6Cd6pYlbhFzPsUjc6gYcXN4F8C/lG/k9tQ2jTqFQd96BZPgKCI2JbD+SftJ/BPtsUqsOc7dG1/CNy0EBkAwsTE1prw/Y2r4wlNVNfkqg9lCU3tzKUU3110=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714490959; c=relaxed/simple;
	bh=Msm6I2Nw8poZFBUpau7eyxZQ0V97p7M88DgJPoiwiHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D0YW74hcbSN1QexPRSh/S36AnI2GoNpO2LEnwG7RYFgSApfGYr50JbyCPFBdixupq1cJ9tBNvlOOa4PyGGOovcPDt8kGSTkYrwfNKQ5a6NeHZmLvxFakirAa7M37DIJ9vdGDm+k8qqrbDOyAap8eQG3LmKVYRNnTSP63BKZt338=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Tue, 30 Apr 2024 17:29:13 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Evgen Bendyak <jman.box@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [libnetfilter_log] fix bug in race condition of calling
 nflog_open from different threads at same time
Message-ID: <ZjEOSVW9HG2xxBxx@calendula>
References: <CAM9G1EADHBYk9Y-Y9RBHbAhqOPOMab41DOEh+PZZa6XKGm8drA@mail.gmail.com>
 <ZjEEOLOJX8bE6p1O@calendula>
 <CAM9G1EBgYqxBmVy_gsKDYkBD1X+rknKMABdjeF3u78vGb7Nt8g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAM9G1EBgYqxBmVy_gsKDYkBD1X+rknKMABdjeF3u78vGb7Nt8g@mail.gmail.com>

Hi,

On Tue, Apr 30, 2024 at 06:25:47PM +0300, Evgen Bendyak wrote:
> In my firewall based on nftables, I use several different log
> subsystem groups for packet capturing. This setup is used for a server
> providing access to a large number of internet clients, with each
> client in a separate VLAN. To expand the number of virtual networks,
> QinQ technology is utilized. One group captures ARP packets (in
> certain situations for new clients) coming from the network, for
> further analysis. Another group captures DHCP packets sent by clients.
> Also present groups for other various subsystems. These are not
> heavily loaded groups in terms of packet volume. In the application
> where this is processed, each group is handled by its own subsystem.
> Each subsystem creates its own thread, where the relevant group for
> that service is opened. Sometimes, after a restart, one group or
> another would fail to function. It appeared as if data was coming
> through the netlink socket, but when nflog_handle_packet was called,
> the callback would not trigger. That's when I began investigating what
> was wrong.

Oh I see, this is log not queue. For some reason I considered this was
the queue subsystem instead.

Thanks for explaining.
