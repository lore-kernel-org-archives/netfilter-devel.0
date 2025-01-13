Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 364E71D0E28
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2025 22:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736806991; cv=none; b=uHheT4jNu/zcyqPlPT8YTxaf/AKGjRfieUT8WutEg6IiA6a/INpnw/K6Wt0xBX8tEZlHKf317H9QWF/GP+N72CGden+EOxaz2P8YyH8O0ovZ4jFizPGjhu6T4noLMnZLG/rAzrLDtb3ZPCok1z1DAOwceCQFF7RI8ANI0uor+uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736806991; c=relaxed/simple;
	bh=QFYa/mP9URxgctiIE1WjTqnnjG/4Plfnxf8cUT/pe5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DE9G8nB5M/m2hO/QVTcdorP5inb0dNK/rjkQoCTAFpaiVLW/6mIgU7sOMjfKY47HgUX1R7tPWvBAigg9tkOOMDVJUfBbRIeh4Sa+tP3L0nxbwj9jfDth3+24UtSz+PQvnMqD9lXl/7br6bq5txF5O1PLYigrOfJZx2/EnG2idKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Mon, 13 Jan 2025 23:23:01 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: =?utf-8?B?7KGw7ZmN7IudL+yxheyehOyXsOq1rOybkC9TVyBTZWN1cml0eeqwnOuwnA==?=
	=?utf-8?B?7Iuk?= SW Security TP <hongsik.jo@lge.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	=?utf-8?B?7IaQ7JiB7IStL+yxheyehOyXsOq1rOybkC9TVyBTZWN1cml0eeqwnOuwnA==?=
	=?utf-8?B?7Iuk?= SW Security TP <loth.son@lge.com>,
	=?utf-8?B?64Ko7KCV7KO8L+yxheyehOyXsOq1rOybkC9TVyBTZWN1cml0eeqwnOuwnA==?=
	=?utf-8?B?7Iuk?= SW Security TP <jungjoo.nahm@lge.com>,
	=?utf-8?B?7KCV7J6s7JykL1Rhc2sgTGVhZGVyL1NXIFBsYXRmb3JtKOyXsCnshKDtlolQ?=
	=?utf-8?B?bGF0Zm9ybeqwnOuwnOyLpCDsi5zsiqTthZxTVw==?= Task <jaeyoon.jung@lge.com>
Subject: Re: Symbol Collision between ulogd and jansson
Message-ID: <Z4WSRVQPmmYfpqvV@calendula>
References: <SE1P216MB155825DDA1CD5809E1569DDE8F1F2@SE1P216MB1558.KORP216.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SE1P216MB155825DDA1CD5809E1569DDE8F1F2@SE1P216MB1558.KORP216.PROD.OUTLOOK.COM>

Hi,

On Mon, Jan 13, 2025 at 06:41:19AM +0000, 조홍식/책임연구원/SW Security개발실 SW Security TP wrote:
> The issue I would like to bring to your attention is as follows: We
> are using the JSON feature in the PACKAGECONFIG of ulogd, and we
> have discovered that both ulogd and jansson have methods with the
> same name, which can lead to a symbol reference error resulting in a
> segmentation fault.  The method in question is hashtable_del().
> Based on our backtrace analysis, it appears that when ulogd's
> hashtable_del() is executed instead of jansson's hashtable_del(), it
> leads to a segmentation fault (SEGV).
> To avoid this symbol collision, I modified ulogd's hashtable_del()
> to hashtable_delete(), and I have confirmed that this resolves the
> issue.

$ nm -D libjansson.so.4 | grep hashtable_del
$

Are you building a static binary? Otherwise, I don't see how the clash
is going on.

I am fine with this patch, would you submit it using git format-patch
and including Signed-off-by:?

Thanks.
