From: Patrick Schaaf <bof@bof.de>
Subject: Re: avoid some indicative messages
Date: Thu, 28 Aug 2003 16:24:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030828142404.GA4211@oknodo.bof.de>
References: <12bff612dda5.12dda512bff6@teleline.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: MYRIAM15 <MYRIAM15@terra.es>
Content-Disposition: inline
In-Reply-To: <12bff612dda5.12dda512bff6@teleline.es>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Aug 27, 2003 at 11:24:10PM +0300, MYRIAM15 wrote:
> Maybe it is a stupid question. It's just that use a C program that if 
> certain conditions are true, it adds rules. But every time I start the 
> program, I want to be sure that previous rules that could have been 
> created, they must be deleted, so the C program also does it. In this 
> case, if a rule itself has not been created, some messages are printed 
> that basically say: "that rule cannot be deleted because it doesn't 
> exist". My question then is: is there any way to avoid these messages?

Assuming that it's a stupid question, here's a try at a stupid answer:

program 2>/dev/null

Hope this helps.

best regards
  Patrick
