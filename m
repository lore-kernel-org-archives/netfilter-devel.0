Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B3730F531
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 12:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785154748; cv=none; b=n+iiFeAlbs/5tfeUset0/Aej70LfNt3F+15IpycxZewQ56ga2tH2jFjYKr1hvTVz3JXxiuUf05kTzEmGDGOMvzFFMa26bTdZs8SvYVrhWjeXzUbCOSuxwWVOvNqr0wRJ2iv2qtD8S/Mm7aXXbxQTpVap6CtFzIDdHfAlLpXvP84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785154748; c=relaxed/simple;
	bh=Qwo/mji2DKJKE+BvxfJ0q9SOTjDWd2BdxK3CbDknux8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D5I/FTLeZEEEb3rfMM2VbWFPvH3cdijgC/YnthMaLsuG2AXjwwIkpttK5Oi+9/3ffIgpQgjZE+f9bAQLnfeOt3DZZXLTYmcwhCAGlBk7RXb61tc5UpUHDILJ8Zk5XygusyLzw/DJhd0q9mgFg2EqRbZi4v8vfg0V8hLM8wVAdQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ROzqEP6G; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ROzqEP6G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785154746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QqTFI/MlpXPvSf2TZ+BIjSgXRyROfyyL9QfN5nHcpMk=;
	b=ROzqEP6Gq1gwT+PenxxDFGznrmDUh2tr6VAdtXI40gdnJ41DUNmJKD+KeYmEWKrwNynCAs
	MqE87in4qmNqIXwLQIXWjw+ONp0ZAGclPi7Vvr7NUBwu1NzkHXjeHDbOvh21rJqVXaTgEY
	1MpJzyVFjmHcgmCXt+m3v0KIKBtDVIA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-208-qUGuFQnqNcWfY2hjV2Y90Q-1; Mon,
 27 Jul 2026 08:19:02 -0400
X-MC-Unique: qUGuFQnqNcWfY2hjV2Y90Q-1
X-Mimecast-MFC-AGG-ID: qUGuFQnqNcWfY2hjV2Y90Q_1785154741
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with UTF8SMTPS id C9FF91956061;
	Mon, 27 Jul 2026 12:19:00 +0000 (UTC)
Received: from localhost (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with UTF8SMTP id F06571955F74;
	Mon, 27 Jul 2026 12:18:59 +0000 (UTC)
Date: Mon, 27 Jul 2026 08:18:57 -0400
From: Eric Garver <eric@garver.life>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Jan =?utf-8?Q?Ko=C5=84czak?= <jan.konczak@cs.put.poznan.pl>
Subject: Re: [nft PATCH v2] parser_bison: Fix for bison < 3.6
Message-ID: <amdMsU0e0JDYYXkD@egarver-mac.redhat.corp>
Mail-Followup-To: Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Jan =?utf-8?Q?Ko=C5=84czak?= <jan.konczak@cs.put.poznan.pl>
References: <20260611125231.652353-1-phil@nwl.cc>
 <amHoSglXwfNia7V7@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <amHoSglXwfNia7V7@orbyte.nwl.cc>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hey Phil,

I see a configure failure after this change [1] on ubuntu-24.04.

  ./configure: line 5247: syntax error near unexpected token `3.6,'
  ./configure: line 5247: `			AX_PROG_BISON_VERSION(3.6,'
  Error: Process completed with exit code 2.

Does ax_prog_bison_version.m4 need to be added to the m4 directory?

Thanks.
E.

[1]: https://github.com/firewalld/firewalld/actions/runs/30020547439/job/89969654992

On Thu, Jul 23, 2026 at 12:09:14PM +0200, Phil Sutter wrote:
> On Thu, Jun 11, 2026 at 02:52:25PM +0200, Phil Sutter wrote:
> > Support for 'custom' parse.error value was added in bison-3.6. Fall back
> > to previous value for earlier versions.
> > 
> > This is harder to get right than it seems: On one hand, preprocessor
> > macros can't be used in parser_bison.y's declaration section and
> > automake forbids conditional changes to AM_YFLAGS on the other.
> > 
> > Another aspect complicating things is compiling with (an up to date)
> > parser_bison.c in place vs. without: Dist tarballs generally have it in
> > place, relieving users from having to provide a YACC when compiling. The
> > existing parser_bison.c either uses parse.error=custom or not which does
> > not (should not) change when compiling. Hiding yyreport_syntax_error()
> > behind a CPPFLAG which may be set or not depending on bison presence and
> > version then causes trouble if it doesn't match how parser_bison.c was
> > created.
> > 
> > Avoid these pitfalls by:
> > - Not relying upon a preprocessor define to control parser_bison.c
> >   compilation, instead check existence of the bison-internal
> >   YY_LAC_ESTABLISH macro
> > - Exporting the above macro existence check in a variable for use by
> >   main.c (thereby crossing the libnftables library boundary)
> > 
> > Also:
> > - Introduce have_prebuilt_bison variable in configure.ac, unifying the
> >   parser_bison.c existence check and solidify the latter by also
> >   comparing its timestamp
> > - Report extended parser errors enableval in configure only if
> >   parser_bison.c will be recreated, otherwise we can't quite tell if it
> >   will turn out to be enabled or not
> > 
> > Suggested-by: Jan Kończak <jan.konczak@cs.put.poznan.pl>
> > Fixes: 67b822f2b2624 ("parser_bison: on syntax errors, output expected tokens")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Patch applied.
> 

