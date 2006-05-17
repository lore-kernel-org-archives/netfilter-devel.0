From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH] fix mem-leak in netfilter
Date: Wed, 17 May 2006 00:13:52 -0700
Message-ID: <ada1wut86of.fsf@cisco.com>
References: <20060515204142.GO7774@kenobi.snowman.net>
	<20060515210342.GP7774@kenobi.snowman.net>
	<446AC1FB.5070406@trash.net>
	<20060517.000957.45395448.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, sfrost@snowman.net, azez@ufomechanic.net,
	willy@w.ods.org, gcoady.lk@gmail.com, laforge@netfilter.org,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	marcelo@kvack.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932458AbWEQHN7@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20060517.000957.45395448.davem@davemloft.net> (David S. Miller's message of "Wed, 17 May 2006 00:09:57 -0700 (PDT)")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

    David> I'm feeling particularly dense today... but what is the
    David> relative precedence of '&' vs '&&'?

& binds tighter than &&.  "man operator" can be your friend...

    David> I've been told that if you have to look up C operator
    David> precedence, don't bother and add parenthesis instead :) -

Probably a good rule though.

 - R.
