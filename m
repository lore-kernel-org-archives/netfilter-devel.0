From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Time match in mangle/POSTROUTING?
Date: Wed, 3 Dec 2003 09:07:08 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312030904580.5506-100000@filer.marasystems.com>
References: <3FCD2AA1.6F5E0225@info-link.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
   <fabrice@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Brad Fisher <brad@info-link.net>
In-Reply-To: <3FCD2AA1.6F5E0225@info-link.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2 Dec 2003, Brad Fisher wrote:

> I'm curious why the time match doesn't work in POSTROUTING?  I have an
> application where it would be helpful to use it as such and was
> wondering if there was a good technical reason why it shouldn't work.
> If I modified the source to allow it to be added to the POSTROUTING
> chain, would it work as expected?  I'm assuming it won't be as simple as
> that...

The complication seems to be info->kerneltime, or to be more precise in
what hooks skb->stamp is valid.

Regards
Henrik
