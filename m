From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Memory allocation inside target handler
Date: Fri, 17 Aug 2007 17:42:46 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708171737580.30502@fbirervta.pbzchgretzou.qr>
References: <200708171717.01065.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200708171717.01065.thomas.jarosch@intra2net.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


On Aug 17 2007 17:17, Thomas Jarosch wrote:
>
>My question is now:
>- Is it ok to use get_zeroed_page(GFP_ATOMIC) in interrupt context?

I suppose so. There is code that checks for __GFP_WAIT.
(GFP_ATOMIC has __GFP_WAIT _cleared_)

>- Do I need some special locking before I can allocate memory inside
>  the target handler? Is f.e. kmalloc protected by some special locking?

Only locking for your own structures, if needed.
kmalloc alone does not. (You can write a memory leak without any locks, so to
speak.)


	Jan
-- 
