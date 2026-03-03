Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A0F3822B1;
	Tue,  3 Mar 2026 22:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772575442; cv=none; b=lqxZ5ApganlkIuo4CTvJMNqOBgKvkDMTilMtCb+VPr713k2RZ6kD5cCLsyMNl9P1jpVlitBs34vFijHAgw28DoGs6GA+k+rJ19+gDdxVEqKDdAVy7CaBl91MtK8vuvcoMPgYrN+UKBSeZD3awRbYJvU5mwwkLg84gmzJDM6uXBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772575442; c=relaxed/simple;
	bh=xtwA6GLCcCFMKT/DdYTYwvRfr6aZzu5YaMH3qVjYWqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aenLZ+Z5Kz6VpMhVoajKiskABdR8r4I2KVnJs90YijcXuiXU9kO61/qDtDt+hKTKYVAfW4cacQy36xReiWJ3RJAhtLM2l6ybxCphndx8xTUrpbqczWFHx+9JiShNJjGDMfeFcW3yKcOzfP1bLjAaR1xfg7f5fanRo+KtQN6mPG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=n40bn0hl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="n40bn0hl"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id A680060177;
	Tue,  3 Mar 2026 23:03:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1772575437;
	bh=9Z6ZQtFQQElTncxl47d8XvLQNvddbbesnrVIvvMUFEs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n40bn0hlcGHgx6ITquW9jKZKT6oxyxZZTYSvh/wrdslJEArc9xfuWDmJvRrQfv+eq
	 1VS54y1o82I/+SXfctTAuIIyIynSwUct2NHjJL+gjj9Ble5jPdJg6CQ7EpFOquyAM6
	 4v5wozN31rEyJHiOT6FRerFHQZxF3Yk4SE2RyWjexv/ZGpY5SVSw3YMOd/EIV4XzpL
	 Zn7GVDnF3+Z1sY/KsXTvMHBBzjGEK8vOcfYK8KKG7ZFodMmrpU55SPNQ4IpgCTVzSW
	 mLshuaw+w4aKqYdtWjsgnqsnb1FE2MUPv40HUVP69IijMxWgjAF9IWlkkHH/3jSwbx
	 qNE7lCyNdglWQ==
Date: Tue, 3 Mar 2026 23:03:55 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jindrich Makovicka <makovick@gmail.com>
Cc: Genes Lists <lists@sapience.com>, Greg KH <gregkh@linuxfoundation.org>,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	linux-kernel@vger.kernel.org, coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org, stable@vger.kernel.org,
	regressions@lists.linux.dev,
	"Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com>
Subject: Re: [REGRESSION] 6.19.4 stable netfilter / nftables [resolved]
Message-ID: <aaday5NR-yfCkFVb@chamomile>
References: <a529a6a9a2755d45765f20b58c5c11e2f790eacb.camel@sapience.com>
 <45f03b0b-fe8f-4942-bad1-3fbde03d4be1@leemhuis.info>
 <143e1a402ad78dd7076516a6ceb637f378310b16.camel@sapience.com>
 <10537f2b74da2b8a5cb8dc939f723291db39ff84.camel@sapience.com>
 <2026022755-quail-graveyard-93e8@gregkh>
 <b231fcdb6c66a7b24dcef3ee5c35c5f612d5c1a7.camel@sapience.com>
 <9d110d860c0c7e110d018ea53a7666eba275da20.camel@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9d110d860c0c7e110d018ea53a7666eba275da20.camel@gmail.com>

On Tue, Mar 03, 2026 at 08:00:54AM +0100, Jindrich Makovicka wrote:
> On Fri, 2026-02-27 at 08:39 -0500, Genes Lists wrote:
> > On Fri, 2026-02-27 at 05:17 -0800, Greg KH wrote:
> > > On Fri, Feb 27, 2026 at 08:12:59AM -0500, Genes Lists wrote:
> > > > On Fri, 2026-02-27 at 07:23 -0500, Genes Lists wrote:
> > > > > On Fri, 2026-02-27 at 09:00 +0100, Thorsten Leemhuis wrote:
> > > > > > Lo!
> > > > > > 
> > > > > 
> > > > > Repeating the nft error message here for simplicity:
> > > > > 
> > > > >  Linux version 7.0.0-rc1-custom-1-00124-g3f4a08e64442 ...
> > > > >   ...
> > > > >   In file included from /etc/nftables.conf:134:2-44:
> > > > >   ./etc/nftables.d/set_filter.conf:1746:7-21: Error:
> > > > >   Could not process rule: File exists
> > > > >                  xx.xxx.xxx.x/23,
> > > > >                  ^^^^^^^^^^^^^^^
> > > > > 
> > > > 
> > > > Resolved by updating userspace.
> > > > 
> > > > I can reproduce this error on non-production machine and found
> > > > this
> > > > error is resolved by re-bulding updated nftables, libmnl and
> > > > libnftnl:
> > > > 
> > > > With these versions nft rules now load without error:
> > > > 
> > > >  - nftables commit de904e22faa2e450d0d4802e1d9bc22013044f93
> > > >  - libmnl   commit 54dea548d796653534645c6e3c8577eaf7d77411
> > > >  - libnftnl commit 5c5a8385dc974ea7887119963022ae988e2a16cc
> > > > 
> > > > All were compiled on machine running 6.19.4.
> > > 
> > > Odd, that shouldn't be an issue, as why would the kernel version
> > > you
> > > build this on matter?
> > > 
> > > What about trying commit f175b46d9134 ("netfilter: nf_tables: add
> > > .abort_skip_removal flag for set types")?
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > - all were rebuilt from git head 
> >   Have not had time to explore what specific change(s)
> >   triggered the issue yet.
> > 
> > - commit f175b46d9134
> >   I can reproduce on non-production machine - will check this and
> > report back.
> 
> I had a similar problem, solved by reverting the commit below. It fails
> only with a longer set. My wild guess is a closed interval with start
> address at the  end of a chunk and end address at the beginning of the
> next one gets misidentified as an open interval.

Yes, but such behaviour already breaks the create element, see my
userspace fix. See:

commit e83e32c8d1cd228d751fb92b756306c6eb6c0759
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Mon Jan 12 12:59:26 2026 +0100
 
    mnl: restore create element command with large batches
    
    The rework to reduce memory consumption has introduced a bug that result
    in spurious EEXIST with large batches.
    
    The code that tracks the start and end elements of the interval can add
    the same element twice to the batch. This works with the add element
    command, since it ignores EEXIST error, but it breaks the the create
    element command.
    
    Update this codepath to ensure both sides of the interval fit into the
    netlink message, otherwise, trim the netlink message to remove them.
    So the next netlink message includes the elements that represent the
    interval that could not fit.

> commit 12b1681793e9b7552495290785a3570c539f409d
> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> Date:   Fri Feb 6 13:33:46 2026 +0100
> 
>     netfilter: nft_set_rbtree: validate open interval overlap

I guess you are testing with 7.0-rc, correct?

A new userspace release with this fix is required.

> Example set definition is here:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=221158
> 
> Using nft from Debian unstable
> 
> $ ./nft --version
> nftables v1.1.6 (Commodore Bullmoose #7)
