Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850942C17B6;
	Thu, 21 Aug 2025 07:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755760727; cv=none; b=Iz/mQujY/Vdo7ktpjGS4NBV3omCHwdKErAelFHx/nwfA0uwZEfPBE09U1GhohUBTcs11vLCrjqaD9Wy8trYJ+oZ8TkuLBXUYTboKF7F5x0Qk4JUA+dygPZnms7HA4RIL6vKPNZ8ZzbSFKSHA93E11kGzsfThnRyfFeOtcNCKQDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755760727; c=relaxed/simple;
	bh=p3SlXTPlVxpUkr4CCkDqkcy0tjuyoyDPOvAhzDuyVrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o8O2Yl+vnTZgrV87bAn5xF2Sek9qR7rguWvddt10niMFdGIwmTkaZEVtpJtQTyKkTLBoF56TBgL9OC0LFl6ZkKw2kLbS8QfHWvBlbTtGnDZHiTPLn+RGn2Oy3F+Rmeq1XYDuDirD5ZJtgccqFa+Z28rYEqw6XiTlGh8ws5wNqHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CC9E660242; Thu, 21 Aug 2025 09:18:41 +0200 (CEST)
Date: Thu, 21 Aug 2025 09:18:41 +0200
From: Florian Westphal <fw@strlen.de>
To: Qingjie Xing <xqjcool@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: conntrack: drop expectations before freeing
 templates
Message-ID: <aKbIUQ3a3jqijZi0@strlen.de>
References: <aKUVqxJVrGgRJZA4@strlen.de>
 <20250820183225.2707430-1-xqjcool@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820183225.2707430-1-xqjcool@gmail.com>

Qingjie Xing <xqjcool@gmail.com> wrote:
> I added a panic() in nf_ct_expect_insert(). After reproducing, the crash dump 
> (via crash) shows the nf_conntrack involved is a template (used as the master), 
> and the expectation insertion was triggered by a TFTP packet.

The tftp packet should be associated with a conntrack entry, not a
template.

>  #3 [ffffc9001762b9c8] nf_ct_expect_related_report at ffffffff80ee7b27
>  #4 [ffffc9001762ba40] tftp_help at ffffffff80f001ea
>  #5 [ffffc9001762ba98] nf_confirm at ffffffff80eeaa77
>  #6 [ffffc9001762bac8] ipv4_confirm at ffffffff80eeafa9
>  #7 [ffffc9001762baf8] nf_hook_slow at ffffffff80ed24db
>  #8 [ffffc9001762bb40] ip_output at ffffffff80fe85a5
>  #9 [ffffc9001762bbc8] udp_send_skb at ffffffff81033372
> #10 [ffffc9001762bc18] udp_sendmsg at ffffffff81032cb2
> #11 [ffffc9001762bd90] inet_sendmsg at ffffffff810488a1

How can this happen?

1. -t raw assigns skb->_nfct to the template.
2. at OUTPUT, nf_conntrack_in is called:

unsigned int
nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
{
        enum ip_conntrack_info ctinfo;
        struct nf_conn *ct, *tmpl;
        u_int8_t protonum;
        int dataoff, ret;

        tmpl = nf_ct_get(skb, &ctinfo);
        if (tmpl || ctinfo == IP_CT_UNTRACKED) {
                /* Previously seen (loopback or untracked)?  Ignore. */
                if ((tmpl && !nf_ct_is_template(tmpl)) ||
                     ctinfo == IP_CT_UNTRACKED)
                        return NF_ACCEPT;
                skb->_nfct = 0; // HERE
        }

... and that will *clear* the template again.

3. nf_conntrack_in assigns skb->_nfct to a newly allocated
   connrack (not a template).

The backtrace you quote should be impossible.

You need to figure out why skb->_nfct was not cleared by
nf_conntrack_in().

You did not mention anything about timing, does this only
happen at the start, i.e. do we have a race where nf_confirm
was just registered with nf_hook_slow for the first time but
ipv4_confirm wasn't set up yet?

If so, please fix nf_confirm() to return early if the skb
has a template attached.
