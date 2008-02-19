From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD 11/15] Add set_sockbuf_len()
Date: Tue, 19 Feb 2008 20:57:38 +0100
Message-ID: <47BB34B2.20906@netfilter.org>
References: <20080202204826.267107164@astaro.com> <20080202205108.751471281@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, holger@eitzenberger.org
To: heitzenberger@astaro.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37363 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753068AbYBST5z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:57:55 -0500
In-Reply-To: <20080202205108.751471281@astaro.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

heitzenberger@astaro.com wrote:
> +	if (snd_len > 0) {
> +		ret = setsockopt(fd, SOL_SOCKET, SO_SNDBUF, &snd_len,
> +						 sizeof(snd_len));
> +		if (ret < 0) {
> +			ulogd_log(ULOGD_ERROR, "setsockopt: SO_SNDBUF: %m\n");
> +			return -1;
> +		}
> +	}
> +
> +	if (rcv_len > 0) {
> +		ret = setsockopt(fd, SOL_SOCKET, SO_RCVBUF, &rcv_len,
> +						 sizeof(rcv_len));
> +		if (ret < 0) {
> +			ulogd_log(ULOGD_ERROR, "setsockopt: SO_RCVBUF: %m\n");
> +			return -1;
> +		}
> +	}

I guess that this is meant to increase the size of the netlink buffers,
isn't this? However, where's the client of this code?

Please, next time put the new code with its client so I can easily
notice what you want to do by looking at a single patch, otherwise I'll
have to look at the entire patchset to search for its client. A short
rationale on the benefits of the patch would also help.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
