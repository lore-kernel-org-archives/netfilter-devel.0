From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Suggestion for RETURN target
Date: Wed, 3 Dec 2003 09:19:13 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312030908390.5506-100000@filer.marasystems.com>
References: <3FCD2FDF.69796CD5@info-link.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Brad Fisher <brad@info-link.net>
In-Reply-To: <3FCD2FDF.69796CD5@info-link.net>
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

> Would it be possible to modify the RETURN target in such a way that it
> could return to an arbitrary chain in the call stack instead of only to
> the previous chain?

>From your description it more looks like you need a true jump/goto 
operation, not a "call" operation.. this would be like the current jump 
operation except that the current chain is not saved on the call stack.

Regards
Henrik
