Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B218821;
	Sun,  5 Jan 2025 21:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736112452; cv=none; b=hivvDJ98xp5BwtwvFLj3/8F9dSLhMCROLsOxlzNh7th0lUSxgvmHrfkVUe8eg+myT64Drj3XGBf6GrXilkLpBlU5zqA6bqK75RXaJ0AcAuU8D2Ubm5vykUkFLZ+4btqjcI1+rOhlxblejTo1Zat0bJX0IKYGLsTNQeKsht/0m4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736112452; c=relaxed/simple;
	bh=895jQ6KmShmN/1Q7OR882jtxe7EZPgAXTpZU6tcqXjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Id6gJ/zm8G0hb9BIeZuMBOHrPwzVQYgFDaQ1uMvfPHh8CvM0mxp94608ze6/ZAkJZ08lM/GTWWyRT/KkGqHmhRgx53evrF5xKTAMzghIwr5Hv/hQX4ruoC2PnUJ6eFst4iXxeasCX0iGxCWgeGfuxb9wS/Zv439ZHTULEooqECk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=cxdd3jIu; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="cxdd3jIu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
	In-Reply-To:References; bh=n5e0Ar8czLiyyASqRBMjDuDdvknA5TmVikDZAjiNWOQ=; b=cx
	dd3jIu2FcegjK0EP09jegbWjTx1I0bvNeTFnJ/TOaUq7Ij0oAw+u8u/Fz9jQ4l60D9k8oqjLdkqEG
	ZeO49qPlmEJJfW0rGa+yIOA49fozDAPJawqcBY3Aoi8ycNGJHK40rFC0/DWM8PLQS2hbHFSKpf+i6
	oQgMeEwdjJ6I1Mo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1tUY9J-001g3X-NG; Sun, 05 Jan 2025 22:27:05 +0100
Date: Sun, 5 Jan 2025 22:27:05 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: egyszeregy@freemail.hu
Cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org,
	daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com,
	kadlec@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v5 1/3] netfilter: x_tables: Merge xt_*.h and ipt_*.h
 files which has same name.
Message-ID: <43f658e7-b33e-4ac9-8152-42b230a416b7@lunn.ch>
References: <20250105203452.101067-1-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250105203452.101067-1-egyszeregy@freemail.hu>

On Sun, Jan 05, 2025 at 09:34:52PM +0100, egyszeregy@freemail.hu wrote:
> From: Benjamin Szőke <egyszeregy@freemail.hu>
> 
> Merge xt_*.h, ipt_*.h and ip6t_*.h header files, which has
> same upper and lower case name format.
> 
> Add #pragma message about recommended to use
> header files with lower case format in the future.

It looks like only patch 1/3 make it to the list.

Also, with a patchset, please include a patch 0/X which gives the big
picture of what the patchset does. The text will be used for the merge
commit, so keep it formal. 'git format-patch --cover-letter' will
create the empty 0/X patch you can edit, or if you are using b4 prep,
you can use 'b4 prep --edit-cover' and then 'b4 send' will
automatically generate and send it.

https://docs.kernel.org/process/maintainer-netdev.html
https://docs.kernel.org/process/submitting-patches.html

    Andrew

---
pw-bot: cr
