From: Tomas Szepe <szepe@pinerecords.com>
Subject: Re: [TRIVIAL] place IPv4 netfilter submenu where it belongs
Date: Mon, 28 Jul 2003 07:50:15 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030728055015.GA32673@louise.pinerecords.com>
References: <20030726200646.GF16160@louise.pinerecords.com> <20030727160942.647707d8.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: "David S. Miller" <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20030727160942.647707d8.davem@redhat.com>
List-Id: netfilter-devel.vger.kernel.org

> [davem@redhat.com]
> 
> On Sat, 26 Jul 2003 22:06:46 +0200
> Tomas Szepe <szepe@pinerecords.com> wrote:
> 
> > $subj
> > 
> > Patch against -bk3.
> 
> This doesn't look right at all.
> 
> Netfilter is for many protocols other than ipv4 (ipv6, bridging,
> decnet, etc.) so putting it under ipv4 makes not much sense
> to me.

You're right, I'll think about this some more.

-- 
Tomas Szepe <szepe@pinerecords.com>
