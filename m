From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 2.6.15.4 1/1][RFC] ipt_owner: inode match supporting
	both incoming and outgoing packets
Date: Sat, 18 Feb 2006 14:10:02 +0100
Message-ID: <1140268203.4698.7.camel@laptopd505.fenrus.org>
References: <200602181410.59757.edwin.torok@level7.ro>
	 <200602181432.14483.edwin@gurde.com> <20060218123720.GA1811@infradead.org>
	 <200602181447.31592.edwin@gurde.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	netfilter-devel@lists.netfilter.org,
	fireflier-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, martinmaurer@gmx.at
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751244AbWBRNKL@vger.kernel.org>
To: edwin@gurde.com
In-Reply-To: <200602181447.31592.edwin@gurde.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

>  As a last resort, I'll try to maintain this as separate patch to be 
> applied to the kernel, but that is something I'd really try to avoid, 
> because:

the problem is this: The export is going away for a reason and not "just
because". And that reason is that the implementation is going to be
radically redone such that this isn't possible anymore. At all.
No amount of patching can fix that ;)
