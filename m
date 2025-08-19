Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E5E2773C9
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2025 12:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755607668; cv=none; b=n5fDh5EH6qwMpBQRefc2rrYw1/l7gawkOHT/UxMHpdnc2IpJ569NyfpuE426+mnGS6W1qYTFmAgGmhJNv4EqI2g14+BP31E8tCgh/DVfzHbbk8KCbaTxWccVVOTbQEG+jGtjLu0hxr+50Ezxz5x6FlH9cNTPOPY37h/UL59PsjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755607668; c=relaxed/simple;
	bh=N6V22JKVvrEw0n8H62al04fHsGs5KNGKi95A08ixehk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hp/Ee4dZAz2qKprUq3bd5oZGsuYPIzSZLanrvS1O2Tgkvn91TKzRQ2wc7lWzDO8kMBYbqIlnP8LMuWQ79lb6NBkBal2muTvFF+twMtZ8dxC0mO8miwSdj5RHNbGza2H4CJiQWZwArui0qI5X4cR1K8DwVC4JKjz6zOkPxywrNoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=taf+Solh; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LY163ns7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="taf+Solh";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LY163ns7"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 18B49602A7; Tue, 19 Aug 2025 14:47:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755607664;
	bh=N6V22JKVvrEw0n8H62al04fHsGs5KNGKi95A08ixehk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=taf+SolhiouPc9nv6NuQFZ/5ODPQz2lNq5riVnsmskG3uqJL2Vz14NKY2u+IB7xKW
	 W1So1cgyxYvrh8mnf+h7Un2br80srp2dMNXsTQ4DyHAAQnOjkVUrxslklKVJnhCfU7
	 sXA6DwvIHzBc5b/3O3+GympqsaeLi7p2NwWufjAD72fw+QXx+yCxldc6GcMbJ0LEd2
	 rrN2dHzW0YT3+Q1gnsZQsSFkU319QzvAgYgKWWOdzHS+KwCbmSwpkD2sDxFjtss/RN
	 slpl8bCZMw72DVt/KeG4QWgODwyiXj+FYkZq6PKCWgaHCC0DqGj2oIvtRbFBwKp/fQ
	 Xe9M+zNTeRxLQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DA96F602A7;
	Tue, 19 Aug 2025 14:47:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755607663;
	bh=N6V22JKVvrEw0n8H62al04fHsGs5KNGKi95A08ixehk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LY163ns70FXZOSpbw5In3B9q5WCMIyV2XDRJHDLAKF+6QBKarnvAxXc+mkXwktFWO
	 K06KQbdIMvsmv9xeNakpjam05+iYgD799wDTC8svfRapb1l/swn/FKV8XJYOeDhnDS
	 0pt/2NPt7cWdIoB5aUJPoof4LdGHXmk/tPmCXmD0D9Jy8jLo7i2N5+vgxXsdNF0Rhf
	 nyl/LxTxEfV7JVbRzYKNK8d7b1lrHEUbnAC/+/1PIWPybURVDO6UK8xOGS70cT8uuK
	 eUAFiXEWii5hpvF+2135vVX7Oxhm/G8s0t+F2P10PACqTk/v1L6Mf8de5OLfn+IK85
	 KkCILQ15iinBA==
Date: Tue, 19 Aug 2025 14:47:40 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de
Subject: Re: [PATCH 1/7 nft v2] src: add tunnel template support
Message-ID: <aKRybNzVyFOC7oCB@calendula>
References: <20250814110450.5434-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250814110450.5434-1-fmancera@suse.de>

Hi,

I made a changes to this series and push it out to the 'tunnel' branch
under the nftables tree.

I added IPv6 support to this 1/7 patch.

However:

[PATCH 6/7] tunnel: add tunnel object and statement json support

still needs to be adjusted to also support IPv6.

I can see JSON representation uses "src" and "dst" as keys.

It is better to have keys that uniquely identify the datatype, I would
suggest:

"ip saddr"
"ip6 saddr"

(similar to ct expression)

or

"src-ipv4"
"src-ipv6"

else, anything you consider better for this.

I think this is the only remaining issue in this series IMO.

If you follow up, patch based your work on the two branches that I
have pushed out for libnftnl and nftables.

Thanks.
