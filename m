From: Rik van Riel <riel@conectiva.com.br>
Subject: Re: ip_conntrack_hash() problem
Date: Thu, 5 Sep 2002 10:37:10 -0300 (BRT)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L.0209051036531.1857-100000@imladris.surriel.com>
References: <20020905083932.F19551@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "David S. Miller" <davem@redhat.com>, <rusty@rustcorp.com.au>,
	<ak@suse.de>, <laforge@gnumonks.org>,
	<netfilter-devel@lists.netfilter.org>,
	<linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20020905083932.F19551@oknodo.bof.de>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 5 Sep 2002, Patrick Schaaf wrote:

> Sorry, but I was under the impression that code readability was worth
> the occasional static-global additional 4 bytes. I must have been
> mistaken.

If you want code readability, you could use a #define ;)

Rik
-- 
Bravely reimplemented by the knights who say "NIH".

http://www.surriel.com/		http://distro.conectiva.com/
