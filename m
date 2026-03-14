Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC7030F815;
	Sat, 14 Mar 2026 19:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773516341; cv=none; b=dJFp0LN5bYHM8oToJRIHR8y21QUyNcLeam704QHCfUqcfweKmvd4DbjF10o/PfS8ZAa31UULN9dJFNTujwTFMiagU4kFRNMYRjLoafQIkJP4UTLKvMPKFQy7sH9h3lg5hKmmFbhxc5PjfUk+8FpZy55+QBvogIBs18oVkdQE8Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773516341; c=relaxed/simple;
	bh=EY4NrOW7BadVbd8u5vDNYGYggIIemFfUWeVOvozJxUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LDYiycEjQjHKStdf7opLzWV8s93IzyGp47Ybvlx7Qx7/cXn2yPNIaaijCCrH0Tltt1eZ+HjE2t06IxrlGR4nHDuR+UJuwkQGtAu9Z45E5+Pa2dT0l6jHbg0FfoJtu5P0lpXMeGwWhr8zWRdtQUrhp8cRQdQaLDwpVyhkVXHbjtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 390D160291; Sat, 14 Mar 2026 20:25:37 +0100 (CET)
Date: Sat, 14 Mar 2026 20:25:36 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Salvatore Bonaccorso <carnil@debian.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Alejandro Olivan Alvarez <alejandro.olivan.alvarez@gmail.com>,
	1130336@bugs.debian.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [regression] Network failure beyond first connection after
 69894e5b4c5e ("netfilter: nft_connlimit: update the count if add was
 skipped")
Message-ID: <abW2MAAqLnKZm3KF@strlen.de>
References: <177349610461.3071718.4083978280323144323@eldamar.lan>
 <c72a56ab-a16c-4866-9a44-a03393f074db@suse.de>
 <b3cbfd15-acd1-4500-ba30-eac6f48523fb@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b3cbfd15-acd1-4500-ba30-eac6f48523fb@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> On 3/14/26 5:13 PM, Fernando Fernandez Mancera wrote:
> > Hi,
> > 
> > On 3/14/26 3:03 PM, Salvatore Bonaccorso wrote:
> > > Control: forwarded -1
> > > https://lore.kernel.org/ regressions/177349610461.3071718.4083978280323144323@eldamar.lan
> > > Control: tags -1 + upstream
> > > 
> > > Hi
> > > 
> > > In Debian, in https://bugs.debian.org/1130336, Alejandro reported that
> > > after updates including 69894e5b4c5e ("netfilter: nft_connlimit:
> > > update the count if add was skipped"), when the following rule is set
> > > 
> > >     iptables -A INPUT -p tcp -m
> > > connlimit --connlimit-above 111 -j
> > > REJECT --reject-with tcp-reset
> > > 
> > > connections get stuck accordingly, it can be easily reproduced by:
> > > 
> > > # iptables -A INPUT -p tcp -m connlimit
> > > --connlimit-above 111 -j REJECT
> > > --reject-with tcp-reset
> > > # nft list ruleset
> > > # Warning: table ip filter is managed by iptables-nft, do not touch!
> > > table ip filter {
> > >          chain INPUT {
> > >                  type filter hook input priority filter; policy accept;
> > >                  ip protocol tcp xt
> > > match "connlimit" counter packets 0
> > > bytes 0 reject with tcp reset
> > >          }
> > > }
> > > # wget -O /dev/null
> > > https://git.kernel.org/torvalds/t/linux-7.0-
> > > rc3.tar.gz
> > > --2026-03-14 14:53:51-- 
> > > https://git.kernel.org/torvalds/t/linux-7.0-
> > > rc3.tar.gz
> > > Resolving git.kernel.org
> > > (git.kernel.org)... 172.105.64.184,
> > > 2a01:7e01:e001:937:0:1991:8:25
> > > Connecting to git.kernel.org
> > > (git.kernel.org)|172.105.64.184|:443...
> > > connected.
> > > HTTP request sent, awaiting response... 301 Moved Permanently
> > > Location: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/
> > > linux.git/snapshot/linux-7.0-rc3.tar.gz
> > > [following]
> > > --2026-03-14 14:53:51-- 
> > > https://git.kernel.org/pub/scm/linux/kernel/ git/torvalds/linux.git/snapshot/linux-7.0-rc3.tar.gz
> > > Reusing existing connection to git.kernel.org:443.
> > > HTTP request sent, awaiting response... 200 OK
> > > Length: unspecified [application/x-gzip]
> > > Saving to: ‘/dev/null’
> > > 
> > > /dev/null                         [
> > > <=>                    ] 248.03M 
> > > 51.9MB/s    in 5.0s
> > > 
> > > 2026-03-14 14:53:56 (49.3 MB/s) - ‘/dev/null’ saved [260080129]
> > > 
> > > # wget -O /dev/null
> > > https://git.kernel.org/torvalds/t/linux-7.0-
> > > rc3.tar.gz
> > > --2026-03-14 14:53:58-- 
> > > https://git.kernel.org/torvalds/t/linux-7.0-
> > > rc3.tar.gz
> > > Resolving git.kernel.org
> > > (git.kernel.org)... 172.105.64.184,
> > > 2a01:7e01:e001:937:0:1991:8:25
> > > Connecting to git.kernel.org
> > > (git.kernel.org)|172.105.64.184|:443...
> > > failed: Connection timed out.
> > > Connecting to git.kernel.org
> > > (git.kernel.org)|
> > > 2a01:7e01:e001:937:0:1991:8:25|:443...
> > > failed: Network is unreachable.
> > > 
> > > Before the 69894e5b4c5e ("netfilter: nft_connlimit: update the count
> > > if add was skipped") commit this worked.
> > > 
> > 
> > Thanks for the report. I have reproduced
> > this on upstream kernel. I am working on it.
> > 
> 
> This is what is happening:
> 
> 1. The first connection is established and
> tracked, all good. When it finishes, it goes to
> TIME_WAIT state
> 2. The second connection is established, ct is
> confirmed since the beginning, skipping the
> tracking and calling a GC.
> 3. The previously tracked connection is cleaned
> up during GC as TIME_WAIT is considered closed.

This is stupid.  The fix is to add --syn or use
OUTPUT.  Its not even clear to me what the user wants to achive with this rule.

> +static inline bool tcp_syn_sent_or_recv(const struct nf_conn *conn)
> +{
> +	if (nf_ct_protonum(conn) == IPPROTO_TCP)
> +		return conn->proto.tcp.state == TCP_CONNTRACK_SYN_SENT ||
> +		       conn->proto.tcp.state == TCP_CONNTRACK_SYN_RECV;
> +	else
> +		return false;
> +}

We're adding ever more complex checks in the conncount backend.
I don't like any of the solutions.

What about reverting the offending commit, at least for tree_count?
That way it continues to work as it did in the past.
