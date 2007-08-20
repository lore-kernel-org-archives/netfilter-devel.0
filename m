From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: Memory allocation inside target handler
Date: Mon, 20 Aug 2007 11:46:32 +0200
Message-ID: <200708201146.32251.thomas.jarosch@intra2net.com>
References: <200708171717.01065.thomas.jarosch@intra2net.com>
	<Pine.LNX.4.64.0708171737580.30502@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708171737580.30502@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
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

On Friday, 17. August 2007, Jan Engelhardt wrote:
> On Aug 17 2007 17:17, Thomas Jarosch wrote:
> >My question is now:
> >- Is it ok to use get_zeroed_page(GFP_ATOMIC) in interrupt context?
>
> I suppose so. There is code that checks for __GFP_WAIT.
> (GFP_ATOMIC has __GFP_WAIT _cleared_)
>
> >- Do I need some special locking before I can allocate memory inside
> >  the target handler? Is f.e. kmalloc protected by some special locking?
>
> Only locking for your own structures, if needed.
> kmalloc alone does not. (You can write a memory leak without any locks, so
> to speak.)

ipt_ACCOUNT spinlocks the internal data structures, so that should be ok.

I've changed the code to allocate and free memory for every packet instead of 
every read from userpace, now the machine survives only 10 seconds. To me it 
looks like a missing locking in the kernel memory handler,
I'll try to get a backtrace via serial console.

Thomas
