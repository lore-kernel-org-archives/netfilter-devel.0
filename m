Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11DF33C506
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Nov 2025 15:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762962101; cv=none; b=HV5+Ckr+viqVGRMv4rWRsk5gp4STFfi23qQjcE4hBcrvL97/oQuFQznODIa06RcjOuvLhQISLoD8BjlCQSY2cXJR3KLCye/DgQ9M/cm6Ugu72ZSCjJkzYEvq+RnrMhtlB5j5whnagW4ZalfpXWH1jI50RRlDms7q4RIVP2Sj+Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762962101; c=relaxed/simple;
	bh=ZiXQwsLaQ9DJlXCjNct0PPina8F7j3H7ylv1I8Z+t7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GgWfqeuq1mYcs96bx6/B1UoG/vguS+m6rWuCYJqVPKQ7GFMqEZrntci0v2clFNoYmuGf8z7r8CeYOMGB4vzD0oYog0xdLNiHjS0Q3c1sBq5y3KLV+/+enxbRCbFM+dQ4LbBQj6RI1fEGnXuc8M8pNmf0SHCKgv69oJiIyoOr2pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=pCrP/IOE; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pCrP/IOE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bagmLhze6xzBMgC+HNM0e3xjgB9PpFzhX3X+Jo8v1t0=; b=pCrP/IOE3gk8HQ2X91fimm9+6g
	p39lGfJbjixYovtcmehc5TBanCZx0uiAA24YG2IYH4uk/TgetfRLqE9xb0DSNjNg1ka+OZRE0vjfQ
	Ftoa+0HBP3SZaGHeZtFlJUyZ6JPSQRi2ETeFoOYTBX0DVkQMqfTQeolBu6mitDXlmvaogEavGXi3p
	AS4OYsys5khWMxh1f0NIPnAgqR8sqCnbF7ae0CqlDQSN4EQWftMc6HgrnVt1K8PnF25FvZFEK8TXn
	r30AFDfbW/7jeJbCbuYg409hTa2ahjLV25hfJ3CpqLHvsYg9ZCRzwoAO5Oq1JkWW3jDamIK97u8nA
	8vGrwmEg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vJCyQ-000000000hs-1Vul;
	Wed, 12 Nov 2025 16:41:30 +0100
Date: Wed, 12 Nov 2025 16:41:30 +0100
From: Phil Sutter <phil@nwl.cc>
To: Yi Chen <yiche@redhat.com>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] tests: shell: add packetpath test for meta time
 expression.
Message-ID: <aRSqqp3OW0j_na1z@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Yi Chen <yiche@redhat.com>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20251112073831.14720-1-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112073831.14720-1-yiche@redhat.com>

Hi Chen Yi,

On Wed, Nov 12, 2025 at 03:38:31PM +0800, Yi Chen wrote:
> Signed-off-by: Yi Chen <yiche@redhat.com>
> ---
>  .../packetpath/dumps/meta_time.nodump         |  0
>  tests/shell/testcases/packetpath/meta_time    | 79 +++++++++++++++++++
>  2 files changed, 79 insertions(+)
>  create mode 100644 tests/shell/testcases/packetpath/dumps/meta_time.nodump
>  create mode 100755 tests/shell/testcases/packetpath/meta_time
> 
> diff --git a/tests/shell/testcases/packetpath/dumps/meta_time.nodump b/tests/shell/testcases/packetpath/dumps/meta_time.nodump
> new file mode 100644
> index 00000000..e69de29b
> diff --git a/tests/shell/testcases/packetpath/meta_time b/tests/shell/testcases/packetpath/meta_time
> new file mode 100755
> index 00000000..a5003fa2
> --- /dev/null
> +++ b/tests/shell/testcases/packetpath/meta_time
> @@ -0,0 +1,79 @@
> +#!/bin/sh
> +
> +# NFT_TEST_REQUIRES(NFT_TEST_HAVE_meta_time)
> +
> +. $NFT_TEST_LIBRARY_FILE
> +
> +gen_in_range_minute()
> +{
> +	echo $(date -d "-5 minutes" +%H:%M)-$(date -d "+5 minutes" +%H:%M)
> +}
> +
> +gen_out_of_range_minute()
> +{
> +	echo $(date -d "+2 minutes" +%H:%M)-$(date -d "+5 minutes" +%H:%M)
> +}
> +
> +gen_in_range_hour()
> +{
> +	echo $(date -d "-2 hours" +%H:%M)-$(date -d "+2 hours" +%H:%M)
> +}
> +
> +gen_out_of_range_hour()
> +{
> +	echo $(date -d "+1 hours" +%H:%M)-$(date -d "+2 hours" +%H:%M)
> +}
> +gen_in_range_day()
> +{
> +	#meta day "Sunday"-"Tuesday"
> +	echo \"$(date -d "-1 days" +%A)\"-\"$(date -d "+1 days" +%A)\"
> +}
> +gen_out_of_range_day()
> +{
> +	echo \"$(date -d "-2 days" +%A)\"-\"$(date -d "-1 days" +%A)\"
> +}
> +
> +gen_in_range_time()
> +{
> +	echo ">" \"$(date -d "-1 years +10 days" +%G-%m-%d" "%H:%M:%S)\" "meta time <" \"$(date -d "+2 days" +%G-%m-%d" "%H:%M:%S)\"
> +}
> +
> +gen_out_of_range_time()
> +{
> +	echo ">" \"$(date -d "+10 days" +%G-%m-%d" "%H:%M:%S)\" "meta time <" \"$(date -d "+1 month" +%G-%m-%d" "%H:%M:%S)\"
> +}

Why do you resort to using two matches instead of a range here?
Something like the following works fine for me:

| nft add rule t c 'meta time "2025-11-10 10:15:45"-"2025-11-11 10:25:35"'

> +
> +$NFT -f - <<-EOF
> +table ip time_test {
> +	counter matched {}
> +	counter unmatch {}

Nice trick to assert matches and non-matches without having to look at
individual rule counters!

Thanks, Phil
