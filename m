Received: from purple.birch.relay.mailchannels.net (purple.birch.relay.mailchannels.net [23.83.209.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A1014B06C
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 02:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.209.150
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761273323; cv=pass; b=anvB+t8ETSFNwoPzrUeOydySjCMWXO6f2uliK7+sEV+nVaFkRCe8XjRcgZcRXUHXkO9efIwDy8XEs6wtFNfiiOMEx+w1mlkBH1yfrlGCEq5ktX7o8rITA+BKNGE0rHhn1ceNGDlES0VeFqBObblNl1gftRPxxZbp/UbMudKxcnw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761273323; c=relaxed/simple;
	bh=JFjUvc2C8rH/MoKlohl/RnwttrAJmPO6N+GI1NJBTLc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SOTrt5pbT1qvau1LqTEY8itlOov9XCwKI+eLtwdxFwA4cnYZ28iL+sJ/cgldeSmpIvI7SIbuBqgo3OtIWEUV6qP4WqWUe6iqxBDAe6pOPbgt89NVIAjnl95cNJs4EPH+cxOXaKqX9oguAHg0yixlXoh7WjpWol4+o1AiD7+En5Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.209.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id B568A41701;
	Fri, 24 Oct 2025 02:35:20 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-8.trex.outbound.svc.cluster.local [100.119.46.77])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 3AA8A416C7
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 02:35:20 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761273320; a=rsa-sha256;
	cv=none;
	b=NLDNd5CSPJuEDBacBWeGQWKM9Jgle55evwAjvhQkp8Vys+ezjzh1YLX4C4BD6mEKfdNhMo
	yOhJNvEn5sy1iK1DKYqLxejT1hbWtDoS/b5hn+DytSPWHLgKVOpExv38mMG1yoDjzgMJbJ
	P7lLiUtCI2VFZCoAmVIxffKP5r0eWFa48rx0XZ+muqQG5qK+VCls5NaP1VndtqwEHVd5ew
	4bG9d4nEJspWMPBntvd33VRgNztRDNoCy+fOHi7cyl3ub4bUoi6mfLc02Jszeqa73HA9/r
	0YcEaYeZJ8pVJ6ps2/gq8ol7XyuolpwwuWezqlZ/XBbZMVXTE+/ofqBJdZEGwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761273320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GPH7OR815p/Emz69ZjLURcYKJQ7baF+nEHmmn020WfM=;
	b=OHMWHFmF/yu1ruSi3jEGxwXFPdf2suitd2utigEWgSUg8R3xZAHvhequYvaHvCe/jED1yP
	Om1Dogkl+qybrQo7FQueNn0QaY/2Dp5nNUDTqGS3HM74ltdBqjg4B5FoQ71EykJjnz+B1G
	CUcmyW2mCMJRRJjCH54Bix4cEZweu8AD/06dHToXKiP6XsFEx6tRWz62EK1Rn1k9T3/6eX
	i56yGu18whsuwfFqWpPUmXG/oFKz7NRrwHVtbwScnQuuAz4Xs6ydeOQTgJqC2KYWC6C/DV
	aX536DgMnZjNF6XuYsmMiCwM1Bi1ol5F8yvqxf/QL/O30FDdotYemKHmQcb/lQ==
ARC-Authentication-Results: i=1;
	rspamd-674f557ffc-d5fx4;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Belong-Left: 3771bf6a648695b0_1761273320623_4157330713
X-MC-Loop-Signature: 1761273320623:2709487248
X-MC-Ingress-Time: 1761273320623
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.119.46.77 (trex/7.1.3);
	Fri, 24 Oct 2025 02:35:20 +0000
Received: from [212.104.214.84] (port=2029 helo=heisenberg.scientia.org)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vC7eC-0000000FtVs-0tQH
	for netfilter-devel@vger.kernel.org;
	Fri, 24 Oct 2025 02:35:18 +0000
Received: by heisenberg.scientia.org (Postfix, from userid 1000)
	id DFB305AA5BF6; Fri, 24 Oct 2025 04:35:16 +0200 (CEST)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH 0/8] improve systemd service
Date: Fri, 24 Oct 2025 04:08:15 +0200
Message-ID: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AuthUser: calestyo@scientia.org

Hey.

This is a first series of patches that tries to improve the included
`nftables.service`.

It contains the (hopefully) less controversial stuff I’d like to do. O:-)

The main idea is to make things more hardened as it should be for loading
firewall rules.


[PATCH 8/9] tools: flush the ruleset only on an actual dedicated unit
might need some more discussion:

1. Instead of the whole logic I’ve addeed we could also choose to simply never
   do anything on stop, i.e. not seeting `ExecStop=` at all, which would mean
   that even on `systemctl stop nftables.service`, the ruleset isn’t flushed.

   Might even better prevent accidentally stopping the firewall; and writing
   `nft flush ruleset` instead would be even shorter.


2. If we keep the basic idea as proposed in the patch, there's still:
   a) Do you want my slightly awkward multi-line syntax with `\n\` line
      terminators or would you rather have anything in one line or something
      else?

      A problematic thing about the multi-line syntax is that it seems
      impossible to write e.g. the shell’s `;;` on a single line with only
      leading whitespace, as systemd then ignores that as a comment. See [0].
      Might be error prone with future changes.

   b) systemd sets some default PATH (which is even an compile option, IIRC)
      that usually contains /usr/loca/[s]bin.
      Because of that it’s IMO safer to use absolute pathnames for sh and
      systemctl (just in case a user made some local overrides).

      Maybe it would be even better to set a fixde `ExecSearchPath=` (wihout
      /u/local), IIRC that also exports PATH, which would then be inherited by
      `nft`, should that ever exec some binary via PATH resoluiton.

      I have chose to *not* use @sbindir@ (respectively add a @bindir@) for sh
      and systemctl because these aren’t shipped by nftables, and I think if any
      distro would really use something different, patching the file would be
      completely upon them.

      While I’ve been in favour of usr-merge, I still can’t write `/usr/bin/sh`.
      ;-)

      The perfectionist in me would want to add a `unset -v job_type`, to
      prevent that from being exported to `nft`, just in case anyone would have
      configured/override his systemd to export a env var of the same name.


A planned 2nd series would focus on hardening with things like the already
present `ProtectSystem=`.
Quite some more sandboxing seetings seem to be usable with this and IMO units
should generally try to set as many as (reasonably) possible.

I’ll probably send a mail first with proposals on what could be hardened and
what people would think about the various points.


Last but not least, one idea would have been to set:
  WorkingDirectory=/etc

If no further `--includepath` is configured, this would cause relative pathnames
starting with `./` in nft’s `include` statement to use the same path as relative
pathnames without `./` – at least when the default `--includepath` is kept at
`/etc`.
No strong opinion myself, whther that would be better or not. Anyone?

It wouldn’t be backwards compatible, if someone used the service with it’s
current (current) working dir (which is /), and specified absolute pathnames as
relative ones.


Cheers,
Chris.

[0] https://github.com/systemd/systemd/issues/39332


