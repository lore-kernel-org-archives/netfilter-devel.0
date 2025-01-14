Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9A8229610
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jan 2025 10:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736851282; cv=none; b=cuBzJ/7gqikFHUMdct16d0z2vv8WiVlZNy2+j1gR2ITRcyZM+TY0ZjjjEZHqUUrLmJhm8uacQM1yaP4hWsyVb6jK60AJsRxsm7rVO2jAiJok/D3VgAYBGbyDMGjsvBvl1Vzxu/OQmWOFJBepaT0bG3Yn4b/+5efA96xwY/XWbh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736851282; c=relaxed/simple;
	bh=PY+L/ZT6LJo7Cnip+0hSWFhp/T9ezLLzGD451IMOKqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qNzeSqfwp8A/YK6dAlpWyPGYwFyKrqWPl7hOFwAcdre5kVG52+1QIo/W+ACfgLWpfDt1dHqlnJwhtN3Exe9rtgqWN7zG7g99gm+1Npvr2O93u+l5yDo48ELIRJJBhrgjMygDaeWC/2yn3QP9ZWuGoCXOaTARP2jH9B17Kx4ecYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tXeME-0000Z4-Rq; Tue, 14 Jan 2025 11:41:14 +0100
Date: Tue, 14 Jan 2025 11:41:14 +0100
From: Florian Westphal <fw@strlen.de>
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
Message-ID: <20250114104114.GA1924@breakpoint.cc>
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
User-Agent: Mutt/1.10.1 (2018-07-13)

조홍식/책임연구원/SW Security개발실 SW Security TP <hongsik.jo@lge.com> wrote:
> The issue I would like to bring to your attention is as follows:
> We are using the JSON feature in the PACKAGECONFIG of ulogd, and we have discovered that both ulogd and jansson have methods with the same name, which can lead to a symbol reference error resulting in a segmentation fault.
> The method in question is hashtable_del(). 
> Based on our backtrace analysis, it appears that when ulogd's hashtable_del() is executed instead of jansson's hashtable_del(), it leads to a segmentation fault (SEGV).
> To avoid this symbol collision, I modified ulogd's hashtable_del() to hashtable_delete(), and I have confirmed that this resolves the issue. 
> 
> For your reference, 
> 1. Our backtrace analysis
> (gdb) bt
> #0  0x000000558ed47730 in __llist_del (next=0x3433326335357830, prev=0x30623663) at /usr/src/debug/ulogd2/2.0.8+git/include/ulogd/linuxlist.h:107
> #1  llist_del (entry=0x7fc5c38460) at /usr/src/debug/ulogd2/2.0.8+git/include/ulogd/linuxlist.h:119
> #2  hashtable_del (table=table@entry=0x7fc5c38530, n=n@entry=0x7fc5c38460) at /usr/src/debug/ulogd2/2.0.8+git/src/hash.c:96
> #3  0x0000007f95234600 in do_dump (json=0x55c234c6b0, flags=0, depth=0, parents=0x7fc5c38530, dump=0x7f95233ad0 <dump_to_strbuffer>, data=0x7fc5c385b0) at /usr/src/debug/jansson/2.14/src/dump.c:416
> #4  0x0000007f952348e4 in json_dump_callback (json=json@entry=0x55c234c6b0, callback=callback@entry=0x7f95233ad0 <dump_to_strbuffer>, data=data@entry=0x7fc5c385b0, flags=flags@entry=0) at /usr/src/debug/jansson/2.14/src/dump.c:486
> #5  0x0000007f952349a0 in json_dumps (json=json@entry=0x55c234c6b0, flags=flags@entry=0) at /usr/src/debug/jansson/2.14/src/dump.c:433
> #6  0x0000007f95271934 in json_interp (upi=0x55c2358690) at /usr/src/debug/ulogd2/2.0.8+git/output/ulogd_output_JSON.c:399
> 
> I think this hashtable_del() should be 
> https://github.com/akheron/jansson/blob/v2.14/src/hashtable.c#L275  ( jansson's hashtable_del )
> But #2 says that the hashtable_del() is ulogd2's one. https://github.com/inliniac/ulogd2/blob/master/src/hash.c#L94  ( ulogd's hashtable_del )
>

Uhm.  What jansson version are you using?

commit 7c707a73a2251c20afaecc028267b99d0ee60184
Author: Petri Lehtinen <petri@digip.org>
Date:   Sun Nov 29 13:04:00 2009 +0200

    Only export symbols starting with "json_" in libjansson.la

    This way we don't pollute the symbol namespace with internal symbols.
