Received: from smtpcmd0986.aruba.it (smtpcmd0986.aruba.it [62.149.156.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E965C24DFEF
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Mar 2025 20:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.156.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741381107; cv=none; b=VEzCeS4Qvmf4js7tJCIqjUVzJ4q5Vu7kegedhspw/QUqcE2Awb+SuKi39YUH3WnzI5KiNkVLcj8x1zzTjzLzNoa2PBJSio93H/5zxEXh3boibvHQdcE64BbKEXXOcxO6A5L3bZcZSCg9oJsrpikZ3WVsoywt7yUoCyp3uQGmYYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741381107; c=relaxed/simple;
	bh=8D0hYFcDvSmvjfB682c9sKBudydvqwn5iJwKPyHs2ic=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=St9WE8C1hi6OMdwUblTrHC0AoTQ4nLtj+YwgQbxfguavafmgTqKVu7UpLDkzDbCzMrr0rzE5NTn32M//y3p1jmyS4BkZ41eT0VmkjvEAlKcbmg4BWRvx98MNgrc9X3IPoD/nWwIUvcuUcUkHSWHTvu9WtuDDJAaqXDtnXmQNEe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com; spf=pass smtp.mailfrom=trentalancia.com; dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b=j28NVNii; arc=none smtp.client-ip=62.149.156.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b="j28NVNii"
Received: from [192.168.43.2] ([109.54.115.5])
	by Aruba SMTP with ESMTPSA
	id qelxtf7jpS934qelxtS8lN; Fri, 07 Mar 2025 21:58:21 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1741381101; bh=8D0hYFcDvSmvjfB682c9sKBudydvqwn5iJwKPyHs2ic=;
	h=Subject:From:To:Date:Content-Type:Mime-Version;
	b=j28NVNiijNleGDqd6kMxL/DExieeCnyjItoBJ+uvED7j5rJpgNDgZcUaaSfT1SoDZ
	 qZXCHR8MUeJhNtBY03d8XJQgo1YdQqL+QCl1AQocvtRHY8ZDt3TOUVuo916YAq5fN3
	 /MJ9+u7aKVEaVwRNoBw6spDKe0PN+4SA4uaIAcRy5ocJEksJpgjhtioIYNlr0QPRm4
	 z2Rlsq3oj1+LLFVFpiBuIouqkpuZGeoZ+ZIrP6mxyp9FFHmqSnQpAMwzJ/vetYoX7k
	 98vY57/60pn36ZqDlR/KKSMdUHjCIzkdmqDRfmAnhk7bmP1YkmqpnAT8Ck0O0fnD+K
	 D8hZ9rmSYaj6A==
Message-ID: <1741381100.5492.17.camel@trentalancia.com>
Subject: Re: [PATCH iptables]: xtables: tolerate DNS lookup failures
From: Guido Trentalancia <guido@trentalancia.com>
To: Reindl Harald <h.reindl@thelounge.net>, Jan Engelhardt <ej@inai.de>
Cc: netfilter-devel@vger.kernel.org
Date: Fri, 07 Mar 2025 21:58:20 +0100
In-Reply-To: <b6b57494-76cc-4057-aa9b-e88c1438262c@thelounge.net>
References: <1741354928.22595.4.camel@trentalancia.com>
	 <qn655027-4830-ps48-87po-r61npps888s5@vanv.qr>
	 <d8ad3f9f-715f-436d-a73b-4b701ae96cc7@thelounge.net>
	 <1741361507.5380.11.camel@trentalancia.com>
	 <cc4ecd68-6db9-42e6-b0f0-dd3af26712ec@thelounge.net>
	 <76043D4F-8298-4D5C-9E98-4A6A002A9F67@trentalancia.com>
	 <6290cf9a-faff-4e1a-aac4-f12d4744d8b9@thelounge.net>
	 <1741379855.5492.10.camel@trentalancia.com>
	 <b6b57494-76cc-4057-aa9b-e88c1438262c@thelounge.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfPixQIO9jD0mAF7o+e2zHYdWoCycDrmk+z2YtqV/J6yIi9v6M9P86uZb/JNInG3RW137mymUoeGrzIpaBQSBbpvHhUJjuvRYPo+jT4TQ7ER0E0NL9zUP
 Ts0wrH1qttYJxc7LwF1d4i8q/TdU512Q3bsrGwSv3XghyHrZAbnj+Qb7BwmABFPDLfHxrAGVgiBwWG5MoZvG7Tg5uOf/gLPcJ6G+3fbVG57/R4V0Os1aLsOh
 G7kOONdiCpneV6PIa9O8TfKkK5EZV5ozLYNiFwek1n4=

The support for hostname-based rules (including multiple resolutions of
an hostname) has been there at least since the following commit:

commit 2ad8dc895ec28a173c629c695c2e11c41b625b6e
Date:   Mon Feb 21 19:10:10 2011 -0500

but probably much earlier, so it's been there for more than 20 years !

Security (and software in general) should not be viewed in absolutistic
terms, I believe, which is why software has features and options, it
depends on different circumstances, if an option is there, the user has
the choice on whether it needs it or not, on whether is convenient or
not, on whether is safe or not.

It's just a very simple patch to improve an existing feature. It's up
to you whether to merge it or not, I can't add much more to this
discussion at this point because it's just looping...

Guido

On Fri, 07/03/2025 at 21.48 +0100, Reindl Harald wrote:
> 
> Am 07.03.25 um 21:37 schrieb Guido Trentalancia:
> > Apart from the case of DNS Round-robin, quite often an hostname
> > (for
> > example, a server hostname) is DNS-mapped to a static IP address,
> > but
> > over the time (several months or years) that IP address might
> > change,
> > even though it's still statically mapped.
> > 
> > In that case, if a client behind an iptables packet filter does not
> > use
> > hostname-based rules, it won't be able to connect to that server
> > anymore.
> > 
> > So, there are cases where hostname-based rules give an advantage.
> 
> sorry, but hostanme based access lists are even on a webserver a bad 
> idea and on a packet filter it's unacceptable
> 
> if a host changes it's IP rules have to be adjusted - it's as simple
> as 
> that for the past 20 years in networking and will continue so the
> next 
> 20 years
> 
> ------------
> 
> and frankly if a service partner can't assign a static IP it's the
> wrong 
> partner to begin with - we are talking about security
> 
> either you have a static ip or there is a vpn-tunnel with
> certificates 
> done within seconds with wireguard - the dynamic host is the one to 
> build up the tunnel, case closed
