Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F68197512
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 17:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730222387; cv=none; b=K10PxHUGOTuVMVr91m4bV/IPzoixioqvOd7JNQN23MyNfBmIeAcbIKS2sOaN3UYNr7Hvx0AjMFPtOBM3rsXC6MBKRKDRCTKON+T+4ZYHZPtKpiRbaaTCTudh2Pty5QTm1ETFlMpog3hjN0KQv1WpcDLYjgV42XfUS6rgJFLx5bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730222387; c=relaxed/simple;
	bh=31ofGa8qyLBdItmpcNY/K+KkhFk/LEXjGJ9+dNlfEhI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=KtLysaHKDJD31132hJikJTR7Qs8EKnNegr1nTxREH1NmekE5PZ2L1RV621T80TgefuaCC4EqLWs0xvzGQqwCt1efSlsy3C9ZEmtnU7oatljx3Y3Hz5dA/eJ4hAW9d3g+JAylo7abRG6iZcxdnQGhKAlhWesEUDwPVRfnOXhP4vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=fail smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 103141003EA0E5; Tue, 29 Oct 2024 18:12:47 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 0FE9A1100AD650;
	Tue, 29 Oct 2024 18:12:47 +0100 (CET)
Date: Tue, 29 Oct 2024 18:12:47 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Phil Sutter <phil@nwl.cc>
cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] Use SPDX License Identifiers in headers
In-Reply-To: <ZyDPYf83FmbqkOe8@orbyte.nwl.cc>
Message-ID: <2r87s774-2os1-pp68-420s-p7p21p28s7q2@vanv.qr>
References: <20241023200658.24205-1-phil@nwl.cc> <ZyAVA6uzi-OUBtcO@calendula> <ZyDPYf83FmbqkOe8@orbyte.nwl.cc>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Tuesday 2024-10-29 13:04, Phil Sutter wrote:
>> 
>> Maybe more intuitive to place
>> 
>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>> 
>> in the first line of this file? This is what was done in iproute2.
>
>Fine with me! [...]
>When Thomas Gleixner did an equivalent to my patch in commit
>0fdebc5ec2ca ("treewide: Replace GPLv2 boilerplate/reference with SPDX -
>gpl-2.0_56.RULE (part 1)"), he used double-slash comments, while Greg
>Kroah-Hartman chose to use multi-line comments in commit b24413180f56

Where the language offers multiple ways to start comments, parsers
must recognize all of them, because humans sure aren't going to
change all of their source just for the sake of some puny tool.


>BTW: Jan suggested to also (introd)use SPDX-FileCopyrightText label, but
>spdx.dev explicitly states: "Therefore, you should not remove or modify
>existing copyright notices in files when adding an SPDX ID."[1] What's
>your opinion about it?


IMO, SPDX markup is popular _because_ everyone took it as a
liberty to modify copyright notices — for some interpretation of
"modify". The particular interpretation/justification is that
boilerplate reduction counts as (re-)formatting rather than a
conceptual modification of the owner/year/terms.

Anyway, the Linux kernel source was already mass-transformed.
LinuxFoundation lawyers surely have an eye on such things
(not least because of a recent lawyer-induced patch from Greg KH
that drew drama *ahem*).

In summary: What's good for the main kernel can't be bad for libnftnl.

With the "modify" aspect discussed out of the way,


>spdx.dev explicitly states: "Therefore, you should not remove or modify
>existing copyright notices in files when adding an SPDX ID."[1] What's
>your opinion about it?

The https://spdx.dev/learn/handling-license-info/ page introduces the
"SPDX-License-Identifier" tag, or "SPDX ID" for short. SPDX-L-I only
conveys terms.

It is my personal opinion that SPDX-License-Identifier and
SPDX-FileCopyrightText[2] *together* can replace the usual copyright
notices encountered, pursuant to my observation of the mass
transformation (see above).

[2] https://spdx.github.io/spdx-spec/v2.3/file-tags/


/* My opinions are not legal advice. */
