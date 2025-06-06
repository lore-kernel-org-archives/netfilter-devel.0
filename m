Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB486288C9D
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Jun 2025 13:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749217771; cv=none; b=DrJsdICs9syIqyvY4DobKFpV61UGoVAeBT1JSdFyEbUAgCA8SaarTm/1ovNjgN3AXtdsSx/tO90n/KGIhI+tmSVZUIDNpu2hOQmsF5JH8CNBMOQctB+RFBGCdT5Iz3MVpukRUxSrDtytteNNiLhx9X8Q/1b8kMkl8wuNOmQ1YkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749217771; c=relaxed/simple;
	bh=Qpm9HUGt+JVm6QdTnS3g3Tb77tkGAK8UvwZrO5nXdO0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gG18bPnohLRm43CoYlhXm0cFEkxxJ3G12CCzrl0zEk2ET/wzYuuzwZHSvNFIIWNjCk21QWd8xqaM/3W5EW1Z1a+qen9jNQ1D8KgKrCwx/wXLPhe3RNJWyGRxU1Azx9z1/wXsTW8xxn9j1LN+jb28dsmpNmdhksoEdGMlMf/e7k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 45B0D605DD; Fri,  6 Jun 2025 15:49:20 +0200 (CEST)
Date: Fri, 6 Jun 2025 15:49:19 +0200
From: Florian Westphal <fw@strlen.de>
To: Yi Chen <yiche@redhat.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] tests: shell: Add a test case for FTP helper combined
 with NAT.
Message-ID: <aELx30qiSdDJ40vl@strlen.de>
References: <20250605103339.719169-1-yiche@redhat.com>
 <20250605104911.727026-1-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250605104911.727026-1-yiche@redhat.com>

Yi Chen <yiche@redhat.com> wrote:
> This test verifies functionality of the FTP helper,
> for both passive, active FTP modes,
> and the functionality of the nf_nat_ftp module.

Thanks for this test case.

Some minor comments below.

> diff --git a/tests/shell/features/tcpdump.sh b/tests/shell/features/tcpdump.sh
> new file mode 100755
> index 00000000..70df9f68
> --- /dev/null
> +++ b/tests/shell/features/tcpdump.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh
> +
> +# check whether tcpdump is installed
> +tcpdump -h >/dev/null 2>&1

Is tcpdump a requirement? AFAICS the dumps are only used
as a debug aid when something goes wrong?

> +INFILE=$(mktemp -p /var/ftp/pub/)

This directory might not be writeable.

Can you use a /tmp/ directory?

I suggest to do:

WORKDIR=$(mktemp -d)
mkdir "$WORKDIR/pub"

... and then place all files there.

> +dd if=/dev/urandom of="$INFILE" bs=4096 count=1 2>/dev/null
> +chmod 755 $INFILE
> +assert_pass "Prepare the file for FTP transmission"

Including this one

... and this config:

> +cat > ./vsftpd.conf <<-EOF
> +anonymous_enable=YES
> +local_enable=YES
> +connect_from_port_20=YES
> +listen=NO
> +listen_ipv6=YES
> +pam_service_name=vsftpd
> +background=YES
> +EOF
> +ip netns exec $S vsftpd ./vsftpd.conf
> +sleep 1
> +ip netns exec $S ss -6ltnp | grep -q '*:21'
> +assert_pass "start vsftpd server"

So no files are created outside of /tmp.

> +# test passive mode
> +reload_ruleset
> +ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${0##*/}.pcap 2> /dev/null & sleep 2
> +ip netns exec $C curl -s --connect-timeout 5 ftp://[${ip_rc}]:2121${INFILE#/var/ftp} -o $OUTFILE
> +assert_pass "curl ftp passive mode "
> +
> +pkill tcpdump

Can you do this instead?:
> +ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${0##*/}.pcap 2> /dev/null &

tcpdump_pid=$!
sleep 2
...
kill "$tcpdump_pid"

?

pkill will zap all tcpdump instances.
Since tests are executed in parallel, it might zap other tcpdump
instances as well and not just the one spawned by this script.

> +tcpdump -nnr ${0##*/}.pcap src ${ip_rs} and dst ${ip_sr} 2>&1 |grep -q FTP

Not sure why the above is needed.  Isn't the 'cmp' enough to see
if the ftp xfer worked?

> +assert_pass "assert FTP traffic NATed"
> +
> +cmp "$INFILE" "$OUTFILE"

... because if there is a problem with the helper, then the cmp
ought to fail?
