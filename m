From: Patrick Schaaf <bof@bof.de>
Subject: Re: question for (existing?) feature
Date: Sun, 23 Mar 2003 14:15:00 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030323131500.GE18652@oknodo.bof.de>
References: <20030316111759.GA20717@posern.org> <2405.1047904769@frodo.gams.co.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "K. Posern" <k@posern.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bernd Petrovitsch <bernd@gams.at>
Content-Disposition: inline
In-Reply-To: <2405.1047904769@frodo.gams.co.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Mar 17, 2003 at 01:39:29PM +0100, Bernd Petrovitsch wrote:
> "K. Posern" <k@posern.org> wrote:
> >Is there a possibility to provice a description to rule - which will be printe
> >d out with "iptables -L" or "iptables -L -v"???
> 
> Yes, just implement a comment field.

If somebody were to set out to implement such a thing, my suggestion
would be to implement it as a normal match, usable whereever other
matches are possible: takes a string argument, the comment, and when
used, it always matches, whatever the packet content.

Probably a five minute cut job, ripping out all functionality
from the string match, would do it.

best regards
  Patrick
