From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] netfilter: nf_conntrack_ftp: prevent integer overflows in get_port()
Date: Sat, 21 May 2011 23:31:05 +0800
Message-ID: <BANLkTikt_N-1HJfcFu241WX4+XuNVDF+5w@mail.gmail.com>
References: <BANLkTikp9ZV4w1E8NNsGBkftGh=jRDx5fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Mansour Moufid <mansourmoufid@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37161 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab1EUPfr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 May 2011 11:35:47 -0400
In-Reply-To: <BANLkTikp9ZV4w1E8NNsGBkftGh=jRDx5fw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 5, 2011 at 6:31 AM, Mansour Moufid <mansourmoufid@gmail.com> wrote:
> From: Mansour Moufid <mansourmoufid@gmail.com>
>
> This patch prevents potential integer overflows from occurring in the
> port number parsing function `get_port', in the file
> net/netfilter/nf_conntrack_ftp.c; related constants are defined in
> include/linux/kernel.h. This applies to stable version 2.6.38.5.
>
> The concern is a firewall could be made to open an otherwise closed
> port. For example, get_port("65558?", 0, 6, '?', foo) currently
> returns 22 in *foo.
>

It isn't a serious problem. If an attacker can control the contents,
he can just give a valid port 22 instead of utilizing this integer
overflow.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
