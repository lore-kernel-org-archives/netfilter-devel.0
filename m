From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2.6.15.4 1/1][RFC] ipt_owner: inode match supporting both incoming and outgoing packets
Date: Sat, 18 Feb 2006 12:37:20 +0000
Message-ID: <20060218123720.GA1811@infradead.org>
References: <200602181410.59757.edwin.torok@level7.ro> <20060218122512.GG911@infradead.org> <200602181432.14483.edwin@gurde.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	netfilter-devel@lists.netfilter.org,
	fireflier-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, martinmaurer@gmx.at
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751203AbWBRMhZ@vger.kernel.org>
To: T?r?k Edwin <edwin@gurde.com>
Content-Disposition: inline
In-Reply-To: <200602181432.14483.edwin@gurde.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, Feb 18, 2006 at 02:32:14PM +0200, T?r?k Edwin wrote:
> Is there an alternative for locking the tasklist, and iterating through all 
> the threads to: find out the struct task*  given a struct fown_struct*. Or is 
> there any other way to find out the inode, and mountpoint of that process?

no, and a driver shouldn't do that.  This might sound harsh, but I'd say
what you're trying to do is fundamentally doomed ;-)
