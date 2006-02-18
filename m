From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2.6.15.4 1/1][RFC] ipt_owner: inode match supporting both incoming and outgoing packets
Date: Sat, 18 Feb 2006 12:25:12 +0000
Message-ID: <20060218122512.GG911@infradead.org>
References: <200602181410.59757.edwin.torok@level7.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org,
	fireflier-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, martinmaurer@gmx.at
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751188AbWBRMZS@vger.kernel.org>
To: T?r?k Edwin <edwin.torok@level7.ro>
Content-Disposition: inline
In-Reply-To: <200602181410.59757.edwin.torok@level7.ro>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

> - I need to lock the task_list
> 	- task_list lock export might be gone some day?

yes.  in exactly half a year from now, and no new users are not allowed.

> 	- is locking tasklist when inside a softirq allowed?

no.  for that reason we already removed a broken match from ipt_owner.
