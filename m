From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Adding packet metadata
Date: Wed, 24 Mar 2004 16:05:11 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403241557130.30696-100000@filer.marasystems.com>
References: <20040324115208.44424.qmail@web13901.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott MacKay <scottmackay@yahoo.com>
In-Reply-To: <20040324115208.44424.qmail@web13901.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 24 Mar 2004, Scott MacKay wrote:

> I actually was thinking of using the MARK for a
> different purpose unfortunantly.  Since it is a nice
> 32bit word, I was thinking of even using only part of
> it, but I need it for setting up some match settings
> for actual rules.

Then you only need a new MARK target as the existing one does not support
masked operations (only the mark match does..).


> > The MARK value is available (read-only) via
> > ip_queue.
>
> That would be my general problem.  The only bit that seems transmitted
> back is the payload for evaluation and update.  Even if I wanted to use
> MARK, it would not allow me to alter the value.

There is a patch somewhere to extend ip_queue to be able to return the 
mark.. and no matter what approach you take something similar is needed if 
you from ip_queue want to return other information than the verdict and 
optional payload substitution.

Regards
Henrik
