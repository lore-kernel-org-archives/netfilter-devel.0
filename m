Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1399628379
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2024 19:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720034284; cv=none; b=Y5EPJUTvoduYBcAwhtv7W5H5RfcZwh/vMwJr7dG1R+UMzOtvPEMIGijxY66Eni7MybBG8XMJHjvbUn5yuwcN3Gsqml5v/StS91k3yZm6AR0PZ4SMgF91QOdngWLHMS1eaxJOPBTknyKzsngbsj7jo7DRlwSZAJhZ6D3zGPhCRPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720034284; c=relaxed/simple;
	bh=LgJe0fMMPWIUgeJPPvPKWVvL7irKJTwP3iGRWAPWPNo=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hX5pWnHaxHlw6A6b/Up8HhwszWQzfCwJ+CBIenABVcQyDqrWYmQYHp/sy7h/hY3oZswSIneZPtRs5eRki96J7uM/M7mHAgYhWrp1ZAfKQdp38K9PW4yhGw/j8vfTZjlOb2hrvLtZvg7jtqjglIGDtMgaHWbzytth8K+JNgzBNzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IVO/ZPsH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IVO/ZPsH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720034281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xqwzE6eiCWjtRNh0S+rGP4hVUc/RWhyaSzSK+vdxNf8=;
	b=IVO/ZPsHLyj9n1gh6aRICm4qOArh4m4kwgpONBcHlwU7QlLVheAZtK6j97p2zpFhVXVOD1
	4B/jWooS93rY+NWOUjKnHlqTHzmhm9bmCJgsBODkdC9ZNhlKCFd7zq//xld7ZGDWCPeZ0e
	DtN3o1biTzoyQgNF+HrgPktD0a85sBs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-574-oziBRfoBOCKhCUu6lyNJ0w-1; Wed,
 03 Jul 2024 15:17:57 -0400
X-MC-Unique: oziBRfoBOCKhCUu6lyNJ0w-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4342F1956046;
	Wed,  3 Jul 2024 19:17:56 +0000 (UTC)
Received: from localhost (unknown [10.22.10.38])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 47B801954B0D;
	Wed,  3 Jul 2024 19:17:54 +0000 (UTC)
Date: Wed, 3 Jul 2024 15:17:52 -0400
From: Eric Garver <eric@garver.life>
To: Phil Sutter <phil@nwl.cc>, Jeremy Sowden <jeremy@azazel.net>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Michael Biebl <biebl@debian.org>
Subject: Re: iptables: reverting 34f085b16073 ("Revert "xshared: Print
 protocol numbers if --numeric was given"")
Message-ID: <ZoWj4FBGF4E0Fwb3@egarver-mac>
Mail-Followup-To: Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
	Jeremy Sowden <jeremy@azazel.net>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Michael Biebl <biebl@debian.org>
References: <20240703160204.GA2296970@azazel.net>
 <ZoWB2Qo_vi-YIRqc@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZoWB2Qo_vi-YIRqc@orbyte.nwl.cc>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Jul 03, 2024 at 06:52:41PM +0200, Phil Sutter wrote:
> Hi Jeremy,
> 
> On Wed, Jul 03, 2024 at 05:02:04PM +0100, Jeremy Sowden wrote:
> > At the beginning of the year you committed 34f085b16073 ("Revert
> > "xshared: Print protocol numbers if --numeric was given""), which
> > reverts da8ecc62dd76 ("xshared: Print protocol numbers if --numeric was
> > given").
> 
> I did this in response to nfbz#1729[1] which argued the names are more
> descriptive. This is obviously true and since commit b6196c7504d4d there
> is no real downside to printing the name if available anymore (--numeric
> still prevents calls to getprotobynumber()).
> 
> Personally I don't mind that much about changing --list output as it is
> not well suited for parsing anyway. I assume most scripts use
> --list-rules or iptables-save output which wasn't affected by
> da8ecc62dd76. Of course I am aware of those that have to parse --list
> output for one or the other reason and their suffering. The only bright
> side here is that whoever had to adjust to da8ecc62dd76 will know how to
> adjust to 34f085b16073, too. Plus it's not a moving target as there are
> merely twelve names which remain in '-n -L' output.
> 
> > In response to a Debian bug-report:
> > 
> >     https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1067733
> > 
> > I applied the change to the iptables package and uploaded it.  However,
> > this caused test failures in the Debian CI pipeline for firewalld
> > because its test-suite has been updated to expect the new numeric
> > protocol output.  Michael Biebl, the firewalld Debian maintainer, (cc'ed
> > so he can correct me if I misquote him) raised a point which I think has
> > some merit.  It is now eighteen months since 1.8.9 was released.  One
> > imagines that the majority of iptables users, who presumably are not
> > building iptables directly from git, must, therefore, have adjusted to
> > the new output.  Is it, then, worth it to revert this change and force
> > them to undo that work after what may have been a couple of years by the
> > time 1.8.11 comes out?
> > 
> > What do you think?
> 
> I think it's a mess and there's no clean way out. The current code is at
> least consistent between '-S' and '-L' output (iptables-save should not
> be "less numeric" than '-n -L'). If it helps, I can work with Eric to
> solve the problem for firewalld so Michael will have something to
> backport to fix it.

The firewalld testuite failures have been fixed [1]. The revert exposed
a bug in the testsuite normalization. It's not actually caused by the
revert of iptables da8ecc62dd76.

Michael could backport this to Sid.

[1]: https://github.com/firewalld/firewalld/pull/1360

> All in all I have not seen many complaints about this change, I expect
> few people scraping iptables output and only a fraction doing --list.
> In addition to that, I plan on soon having a 1.8.11 release (we're far
> ahead already to make backports a pain).
> 
> What do you think?

I'm indifferent. As you say, there is no clean way out.

