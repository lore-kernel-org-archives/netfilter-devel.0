From: Dominik Kubla <dominik@kubla.de>
Subject: Re: A suggestion for the netfilter part of the sources
Date: Tue, 4 Mar 2003 23:56:42 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200303042356.56722.dominik@kubla.de>
References: <3E64E1C8.9040309@securinet.qc.ca> <20030304182006.GI4880@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-kernel@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Harald Welte <laforge@netfilter.org>,
	David =?iso-8859-1?q?Lagani=E8re?= <spanska@securinet.qc.ca>
In-Reply-To: <20030304182006.GI4880@sunbeam.de.gnumonks.org>
Content-Description: clearsigned data
Content-Disposition: inline
List-Id: netfilter-devel.vger.kernel.org

On Tuesday 04 March 2003 19:20, Harald Welte wrote:

>
> The suggestion is neither 'good' nor 'bad'.  Nobody has (until now)
> asked us to raise this value, eight seems to be enough for most people.
>
> As long as your proposal is not backed by more other users who think the
> default should be raised, I'd rather leave it the way it currently is.
>

Since this is meant to be tunable, how about turning it into a configuration 
option (with 8 being the default)? I guess that would solve this problem 
quite nicely.

Regards,
  Dominik
-- 
Why should George W. Bush care what the American people think?
After all they did not vote for him.
