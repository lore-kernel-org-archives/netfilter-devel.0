From: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
Subject: Re: [PATCH 2.6 NETFILTER] new netfilter module ipt_program.c
Date: Sat, 11 Sep 2004 14:29:35 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040911132935.GF24787@lkcl.net>
References: <20040911124106.GD24787@lkcl.net> <4142F4CC.7080708@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S268141AbUIKNSX@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4142F4CC.7080708@trash.net>
List-Id: netfilter-devel.vger.kernel.org

On Sat, Sep 11, 2004 at 02:51:24PM +0200, Patrick McHardy wrote:
> Luke Kenneth Casson Leighton wrote:
> >decided to put this into a separate module.  based on ipt_owner.c.
> >does full program's pathname.  like ipt_owner, only suitable for
> >outgoing connections.
> 
> I agree that it would be useful to match the full path, but
> the patch is broken, as are the owner match's pid-, sid- and
> command-matching options. You can't grab files->file_lock
> outside of process context. 

 what should be done instead?

 what code is there around that i can copy that does a proper job?

 l.
