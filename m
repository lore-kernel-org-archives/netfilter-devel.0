From: Adam Guyot <aguyot@speakeasy.net>
Subject: Re: match code question
Date: Wed, 18 Sep 2002 11:19:32 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020918111932.A55735@speakeasy.net>
References: <20020918105402.A55640@speakeasy.net> <20020918150727.GA10465@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Adam Guyot <aguyot@speakeasy.net>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20020918150727.GA10465@oknodo.bof.de>; from bof@bof.de on Wed, Sep 18, 2002 at 05:07:27PM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Sep 18, 2002 at 05:07:27PM +0200, Patrick Schaaf wrote:
> > Now, when a new connection is initiated, the printk msgs don't show
> > up in /var/log/messages or anywhere that I can tell :P.
> 
> Stupid question: did you actually insert a rule _using_ your new match?

Dohhh! That would fix the problem.

thanks,
--a
 
