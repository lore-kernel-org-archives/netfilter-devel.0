From: Gianni Tedesco <gianni@scaramanga.co.uk>
Subject: Re: [PATCH 2.6 NETFILTER] new netfilter module ipt_program.c
Date: Sat, 11 Sep 2004 15:49:35 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1094914175.8495.66.camel@sherbert>
References: <20040911124106.GD24787@lkcl.net>  <4142F4CC.7080708@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Luke Kenneth Casson Leighton <lkcl@lkcl.net>,
	linux-kernel@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S267976AbUIKOt4@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4142F4CC.7080708@trash.net>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2004-09-11 at 14:51 +0200, Patrick McHardy wrote:
> Luke Kenneth Casson Leighton wrote:
> > decided to put this into a separate module.  based on ipt_owner.c.
> > does full program's pathname.  like ipt_owner, only suitable for
> > outgoing connections.
> 
> I agree that it would be useful to match the full path, but
> the patch is broken, as are the owner match's pid-, sid- and
> command-matching options. You can't grab files->file_lock
> outside of process context. Besides, we want to consolidate
> functionality, not add new matches that do basically the same
> as existing ones.

This is a binary compatibility issue, I don't think it's possible to add
Lukes functionality to ipt_owner without breaking iptables
compatibility.

-- 
// Gianni Tedesco (gianni at scaramanga dot co dot uk)
lynx --source www.scaramanga.co.uk/scaramanga.asc | gpg --import
8646BE7D: 6D9F 2287 870E A2C9 8F60 3A3C 91B5 7669 8646 BE7D
