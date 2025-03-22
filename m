Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A1B1B3F3D
	for <netfilter-devel@vger.kernel.org>; Sat, 22 Mar 2025 09:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742636776; cv=none; b=OTssipKlcmnUMknL/78tbDr1Qi5UzU8hoTeFyCchbsDZmjdetqqydsleKgUuUPweDv1yC3AapguX4dZqlnX7sWGb5jo8t/gCY6vGpmPaFx1ebzMgmMsqqQsFI6g9lN8RtwtOdQIpwAO1iOkPE82U2OF0x0BaTxZyLrpISy5rzUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742636776; c=relaxed/simple;
	bh=zFW7DFDShl0KlNHU1MloF5wG3FhhmqseratTiPx+2oM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=jMSUWc5r3B0XMeU3zy/3Uuh7rTDcc98wE2Z1s9ZbI42dYHTfrlCo1lzol1iM0GbuFzLk7hFeCAQ1gLPFC8KjyBYJii9Z2dtMrOx9IkVOClT4lvclt4U2HtEhL8Y20HZhuLFh5Qu7cJVuxFgMKlI6phEV9eZVbM7BBoywBOlx+NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id BE2281003CFAD2; Sat, 22 Mar 2025 10:46:12 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id BD3341100C2DA7;
	Sat, 22 Mar 2025 10:46:12 +0100 (CET)
Date: Sat, 22 Mar 2025 10:46:12 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Phil Sutter <phil@nwl.cc>
cc: Eric Garver <eric@garver.life>, Jan Engelhardt <jengelh@inai.de>, 
    netfilter-devel@vger.kernel.org, fw@strlen.de, pablo@netfilter.org, 
    Kevin Fenzi <kevin@scrye.com>, 
    Matthias Gerstner <matthias.gerstner@suse.com>, arturo@debian.org
Subject: Re: [PATCH] tools: add a systemd unit for static rulesets
In-Reply-To: <Z9wgoHjQhARxPtqm@orbyte.nwl.cc>
Message-ID: <rqq41355-6o85-99q1-6839-5q2rp24s670n@vanv.qr>
References: <20250228205935.59659-1-jengelh@inai.de> <Z8muJWOYP3y-giAP@egarver-mac> <Z9wgoHjQhARxPtqm@orbyte.nwl.cc>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Thursday 2025-03-20 15:05, Phil Sutter wrote:

>IMO we should at least include the builtin 'flush ruleset' in ExecReload
>action.

Yes

>The sample configs are not just empty chains as proposed here but
>actually contain rules which should not just help users get going but
>also showcase nftables features a bit.
>
>What are your opinions about Fedora's sample configs?

That's all considered "documentation".

>The content should be fine for generic purposes, merely
>/etc/sysconfig/nftables.conf location should be changed, maybe to
>/etc/nftables/nftables.conf.

We're not using /etc/sysconfig (it's deprecated or so).

