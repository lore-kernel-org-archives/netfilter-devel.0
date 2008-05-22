From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] linux-next: Tree for May 21 - build failure with
	netfilter on __nf_ct_helper_find()
Date: Thu, 22 May 2008 10:15:46 +0200
Message-ID: <20080522081546.GB7222@elte.hu>
References: <20080521155936.466bbe86.sfr@canb.auug.org.au> <20080521113230.GA10830@linux.vnet.ibm.com> <20080521225214.507eb400.sfr@canb.auug.org.au> <4834239D.90500@linux.vnet.ibm.com> <20080522101148.fbabee96.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	netfilter-devel@vger.kernel.org, apw@shadowen.org,
	Franck Bui-Huu <fbuihuu@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934688AbYEVIQ2@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080522101148.fbabee96.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Actually this is caused by the splitting out of the rcu stuff from 
> list.h that is in linux-next, sorry.

this bug has been fixed in the -tip tree 9 days ago:

|  commit db3c7a9f07a212d1774e6b432a08b231340e984d
|  Author: Ingo Molnar <mingo@elte.hu>
|  Date:   Tue May 13 15:37:05 2008 +0200

that commit was in intermediate testing phase in the 'scratch' branch, 
and a few days ago linux-next stopped picking up the scratch branch.

I've now cherry-picked this fix over into the rcu branch and everything 
should be fine again in the next linux-next iteration.

	Ingo
