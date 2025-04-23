Received: from sphereful.sorra.shikadi.net (sphereful.sorra.shikadi.net [52.63.116.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A591FE45D
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Apr 2025 22:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.63.116.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745449092; cv=none; b=Qqg4NRvtXbfN699WW/RFYiAFC7fQmWFL5mdNAVhyvVDlNEv/1pvDRZSsFHHsMK3wL0w1bt6WfN8XwSx6zT3cVrR9OuiBa+GLodxzTaoFIdakmJkxra51DqSWQWBPaBljkSZyzSJA4/ydjr1vLv8RT6C42ir/XQ3xhVUu1SFbGcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745449092; c=relaxed/simple;
	bh=7j1OLLFPp1a0UahhbY4aV8UlWFSm3I5e0fm80W/mrPY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PN8XPlSEU/pyYhYwg5yIhy1Ju0nv11b7jlGJzJ4zCHAcUScK1NARmWmzqXdrbWUK4b1UNC1b9GFP28z6RU9uLIiBcfHKpUho9aKwf/mwCUFhHqpr7noa9nrEF0GeCiKB5HDSUa3XdHKSTHa8IbFBhag6v1ufgUXYPWAH/P44QJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=shikadi.net; spf=pass smtp.mailfrom=shikadi.net; dkim=pass (2048-bit key) header.d=shikadi.net header.i=@shikadi.net header.b=iPQk856I; arc=none smtp.client-ip=52.63.116.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=shikadi.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shikadi.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shikadi.net header.i=@shikadi.net header.b="iPQk856I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=shikadi.net
	; s=since20200425; h=MIME-Version:References:In-Reply-To:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=V03Z05CrEoi4PMHV6gU3SrQPmfzTypV/8OgraP3fVeg=; b=iPQk856Ihli2wnoQ0LABMA/ya9
	O/HC4eXTQXtLw/a3EtV55+tZEcqRqbMNyQwyNxvxnq+gSngWeYRPideh1EtrPZNlVSruG9uwBs20U
	F4WdjUj9I7+04lFufoxtZItVUOs4UlBw7QC8O2C+Z3bZmAnv1vAL3Yf8lxqO8YsjXJfokiN3s7q/1
	KudBGgGE9OSuxSSdPHYUkzrQzC+hzei+goMQVeeedlA3oPmW0pppMBOnwKyIFGvB/R9nY3QCWp7+o
	z6D8ABxU/2WdzEoE3cD70pIon+DYrw65O7vkmg08huEM0EQ9ImklVMasrT4On3Jua9iFwic3YfTz2
	RqjLA+Vg==;
Received: by sphereful.sorra.shikadi.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <a.nielsen@shikadi.net>)
	id 1u7j2c-0001e3-1v;
	Thu, 24 Apr 2025 08:58:06 +1000
Date: Thu, 24 Apr 2025 08:58:03 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] xshared: Accept an option if any given command
 allows it
Message-ID: <20250424085803.73864094@gnosticus>
In-Reply-To: <aAlXGcRNV4AkXGk-@orbyte.nwl.cc>
References: <20250423121929.31250-1-phil@nwl.cc>
	<aAlXGcRNV4AkXGk-@orbyte.nwl.cc>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.48; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

> > Fixed commit made option checking overly strict: Some commands may be
> > commbined (foremost --list and --zero), reject a given option only if it
> > is not allowed by any of the given commands.
> 
> Patch applied.

Excellent!  Many thanks for such a quick fix!

Hopefully it won't be too long until the next release, given the last
one looks to have been a couple of years...

Cheers,
Adam.
