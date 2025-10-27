Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FE432AABD
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Oct 2025 19:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591760; cv=none; b=gGCN7jno8ZMPpJK+x+Sr/84BQ9tXJtms/f3oPKGac4AqF7lPt5ofKN2Gj7YhTOBPkV40pkA9gnhRErr3gVlV7gnX17cLBDPAwuhQWDCWYhKAsGqxSFrT7YXAT65WxrLvwB+4IRUzDqoggHKv/yGqiwpyE23Q3Xis5l/dBYO+KXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591760; c=relaxed/simple;
	bh=ByNBEiBfnlJQ/Eux/adzVYSffM8WT3gXS4Ti4tUpIxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nBfzbrv07+F0cgNPBXi+WB/LeaAw4L6fKfGPY+GJx2qmpOrMndKiJDzk+iBOHdjGzO8wO62855V7KL6dvV5R9Kstwja9VZzrTDjhY8hv0mosDVRkom3IGmDFWRgd+B8KVsMhJphd9SbipkWVFLBvorrb/GqtGbJ557QzmPKHe+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BBF4A605E6; Mon, 27 Oct 2025 20:02:35 +0100 (CET)
Date: Mon, 27 Oct 2025 20:02:35 +0100
From: Florian Westphal <fw@strlen.de>
To: Andrii Melnychenko <a.melnychenko@vyos.io>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/1] tests: shell: Updated nat_ftp tests
Message-ID: <aP_By5SYOFlM9LmZ@strlen.de>
References: <20251027113907.451391-1-a.melnychenko@vyos.io>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027113907.451391-1-a.melnychenko@vyos.io>

Andrii Melnychenko <a.melnychenko@vyos.io> wrote:
> Added DNAT and SNAT only tests.
> There was an issue with DNAT that was not covered by tests.
> DNAT misses setting up the `seqadj`, which leads to FTP failures.
> The fix for DNAT has already been proposed to the kernel.

Thanks, could you please send a v2 that splits the refactoring
from the new test case (i.e. two changes)?

> Acked-by: Florian Westphal <fw@strlen.de>

This should not be here unless you would be re-sending a v2
of a patch that is almost 100% the same as the one I acked before.

And I don't recall acking this change, so please don't add this
yourself.

> +	# flush and add FTP helper
> +	read -r -d '' str <<-EOF
>  	flush ruleset
>  	table ip6 ftp_helper_nat_test {
>  		ct helper ftp-standard {
>  			type "ftp" protocol tcp;
>  		}
> +	EOF
> +	ruleset+=$str$'\n'

I'd suggest to just use multiple nft -f invocations
instead of this.

> +	# add DNAT
> +	if [[ $add_dnat -ne 0 ]]; then
> +		read -r -d '' str <<-EOF
>  		chain PRE-dnat {
>  			type nat hook prerouting priority dstnat; policy accept;
>  			# Dnat the control connection, data connection will be automaticly NATed.
>  			ip6 daddr ${ip_rc} counter ip6 nexthdr tcp tcp dport 2121 counter dnat ip6 to [${ip_sr}]:21
>  		}
> +		EOF
> +		ruleset+=$str$'\n'
> +	fi

Just move this from reload_ruleset to a helper function.

> @@ -111,18 +125,51 @@ reload_ruleset()
>  			ip6 nexthdr tcp ct state established counter accept
>  			ip6 nexthdr tcp ct state related     counter log accept
>  		}
> +	EOF
> +	ruleset+=$str$'\n'
>  
> +	# add SNAT
> +	if [[ $add_snat -ne 0 ]]; then
> +		read -r -d '' str <<-EOF

Same here, just omit this.

> +reload_ruleset()
> +{
> +	reload_ruleset_base 1 1
> +}

Then this would be something like:

reload_ruleset_dnat()
{
	reload_ruleset
	load_dnat
}

reload_ruleset_snat()
{
	reload_ruleset
	load_snat
}

reload_ruleset_allnat
{
	reload_ruleset
	load_snat
	load_dnat
}

(or similar naming).  I find that easier to follow, esp. because this
allows a refactor patch before adding the _snat/_dnat tests.

The reload_ruleset -> reload_ruleset_base rename is also ok if you
prefer that.

> +
>  dd if=/dev/urandom of="$INFILE" bs=4096 count=1 2>/dev/null
>  chmod 755 $INFILE
> +
> +mkdir -p /var/run/vsftpd/empty/
> +cp $INFILE /var/run/vsftpd/empty/

I don't understand this change, how is that related?

> +reload_ruleset_dnat_only
> +
> +ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /dev/null &
> +pid=$!
> +sleep 0.5
> +ip netns exec $C curl --no-progress-meter -P - --connect-timeout 5 ftp://[${ip_rc}]:2121/$(basename $INFILE) -o $OUTFILE
> +assert_pass "curl ftp active mode "

Not a requirement, but there is a lot of repitition
of this sequence now, albeit with small changes.

Perhaps this should be in a reuseable function first
before adding the new test cases to this script.

> +ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /dev/null &
> +pid=$!
> +sleep 0.5
> +ip netns exec $C curl --no-progress-meter -P - --connect-timeout 5 ftp://[${ip_sr}]:21/$(basename $INFILE) -o $OUTFILE
> +assert_pass "curl ftp active mode "
> +
> +cmp "$INFILE" "$OUTFILE"
> +assert_pass "FTP Active mode: in and output files remain the same when FTP traffic passes through NAT."
> +
> +kill $pid; sync

I don't understand this 'sync' (I know its already there is source).
It seems its not needed?
