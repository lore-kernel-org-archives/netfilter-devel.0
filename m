Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3155A2E03EF
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 11:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761824104; cv=none; b=aAgBworu/xiwiezkonFm94AbsT98nUyVUgNoPDBN2455lcUkDzybI0O36O/A5WivwdNkjcjoZ8EI7IkCprpnmtlZXBfcBLLfAHljvNnUc+s3NFRsL0BSgmQjxVhl77D5CBqEB3q1jRWRHfsgw/Fu08MzXNi7zuOyQxi4S1nlv/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761824104; c=relaxed/simple;
	bh=MYzrcpPUf0l6mSL/UOBPkZEPlWz1GIx/JF993oF/fTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M4AvZ6W2paGrDZQ30Yvbh75+/zyJFwuSiNadfCFfPezKpJQW/AgPKkF1EZlkUimODd6sIJJ3nHgSk4zpdE937u3NOMb7oEmjfGNobMN05EZ82Al/2RU2JiTlgtm3XgQNI6gZvVWg7wsqWmhbZnBsv2WjggpiM791gz0fiWawakc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 04F7960202; Thu, 30 Oct 2025 12:34:59 +0100 (CET)
Date: Thu, 30 Oct 2025 12:34:59 +0100
From: Florian Westphal <fw@strlen.de>
To: Alexandre Knecht <knecht.alexandre@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2] parser_json: support handle for rule positioning
 in JSON add rule
Message-ID: <aQNNY-Flo9jFcay3@strlen.de>
References: <20251029003044.548224-1-knecht.alexandre@gmail.com>
 <20251029224530.1962783-1-knecht.alexandre@gmail.com>
 <20251029224530.1962783-2-knecht.alexandre@gmail.com>
 <aQNBcGLaZTV8iRB1@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQNBcGLaZTV8iRB1@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Alexandre Knecht <knecht.alexandre@gmail.com> wrote:
> > This patch fixes JSON-based rule positioning when using "add rule" with
> > a handle parameter. Previously, the handle was deleted before being used
> > for positioning, causing rules to always be appended at the end of the
> > chain instead of being placed after the specified rule handle.
> 
> LGTM, thanks for providing a new test for this.

Take that back, this patch breaks

tests/shell/testcases/json/0005secmark_objref_0
