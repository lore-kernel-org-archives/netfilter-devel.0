From: "David S. Miller" <davem@redhat.com>
Subject: Re: ip_conntrack_hash() problem
Date: Wed, 04 Sep 2002 23:40:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20020904.234019.130517085.davem@redhat.com>
References: <20020905083340.E19551@oknodo.bof.de>
	<20020904.233226.108195359.davem@redhat.com>
	<20020905083932.F19551@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, ak@suse.de, laforge@gnumonks.org,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: bof@bof.de
In-Reply-To: <20020905083932.F19551@oknodo.bof.de>
List-Id: netfilter-devel.vger.kernel.org

   From: Patrick Schaaf <bof@bof.de>
   Date: Thu, 5 Sep 2002 08:39:32 +0200
   
   Sorry, but I was under the impression that code readability was worth
   the occasional static-global additional 4 bytes. I must have been
   mistaken.

For the level of readability you're pining for, yes you are
mistaken.
