From: Patrick Schaaf <bof@bof.de>
Subject: Re: Owner on Input table
Date: Mon, 14 Feb 2005 08:29:48 +0100
Message-ID: <20050214072948.GA6011@oknodo.bof.de>
References: <000101c51162$aceabfa0$9600a8c0@netcontent>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: Egon Phillips <egon.phillips@sympatico.ca>
Content-Disposition: inline
In-Reply-To: <000101c51162$aceabfa0$9600a8c0@netcontent>
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

>     This module attempts to match various
>     characteristics of the packet creator, 
>     for locally-generated packets. It is 
>     only valid in the OUTPUT chain, and even
>     this some packets (such as ICMP ping responses)
>     may have no owner, and hence never match. 
> 
> Are there any plans to change this policy?  If not, is this a limitation
> of the software or of the OS?  Is it not possible to use the destination
> ports process id to determine the owner?

It may be possible - after all, the kernel will do it some milliseconds
later - but would you really want your packet processing halted until
it is decided WHICH userlevel apache process will finally accept()
this incoming SYN packet?

In other words: it is neither easy, nor the right place, nor a unique
decision. Thus the policy of "better don't even try".

best regards
  Patrick
