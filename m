From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_conntrack (l3 independent conntrack)
Date: Wed, 19 Nov 2003 11:45:29 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200311190246.LAA10515@toshiba.co.jp>
References: <20031115105020.GI656@obroa-skai.de.gnumonks.org>
	<200311180305.MAA20518@toshiba.co.jp>
	<20031118165138.GO5075@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: yasuyuki.kozakai@toshiba.co.jp, netfilter-devel@lists.netfilter.org,
        usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20031118165138.GO5075@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi, Harald,

From: Harald Welte <laforge@netfilter.org>
Date: Tue, 18 Nov 2003 17:51:38 +0100

> On Tue, Nov 18, 2003 at 12:04:49PM +0900, Yasuyuki Kozakai wrote:
> 
> > I read. It's very usefull to implement nf_conntrack. Thank you.
> 
> Well, I doubt it is, but anyway ;)

Did I missread something enough to make you suspect that I read it...

> And to reply to your question: The tuple is part of the 'dynamic' part,
> along with other fields.

Thank you for datail explanation. I try to rewrite the codes that processes
nf_conntrack and tuple. At first, I'll move only tuple to the dynamic part of
nf_conntrack. I may ask you about other question, I'm happy if you reply.

> > I'll send the patches as snapshot when I finish debugging.
> > Or should I send them after I finish implementing above items ?
> 
> If possible, I think it is good to have the development as open as
> possible.  It's not important that the code runs (or even compiles).
> But if your current status of development was public, other netfilter
> developers could have a look at the code and comment.

OK, I'll send it ASAP. But maybe I take a week to get permission.


----------------------------------------
Yasuyuki KOZAKAI

Communication Platform Laboratory,
Corporate Research & Development Center,
Toshiba Corporation

yasuyuki.kozakai@toshiba.co.jp
----------------------------------------
