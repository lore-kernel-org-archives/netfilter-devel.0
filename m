From: Patrick McHardy <kaber@trash.net>
Subject: Re: TCPMSS is not restricted to mangle table
Date: Mon, 05 Dec 2005 02:11:37 +0100
Message-ID: <439393C9.5020001@trash.net>
References: <4393895D.1020106@trash.net> <20051205004548.GC5617@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <20051205004548.GC5617@eychenne.org>
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

Herve Eychenne wrote:
> On Mon, Dec 05, 2005 at 01:27:09AM +0100, Patrick McHardy wrote:
> 
> 
>>I just noticed the TCPMSS target is not restricted to the
>>mangle table. Any opinions about whether we should change
>>this, perhaps with a warning period?
> 
> 
> See the manpage itself... I just copy-pasted the kernel config description
> (probably written by Marc Boucher?) when adding TCPMSS to the manpage
> some years ago.
> 
> So look for TCPMSS, notice the given example:
>        iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN \
>                     -j TCPMSS --clamp-mss-to-pmtu
> 
> and realize that most uses of TCPMSS (which I fear are not that
> rare) probably occur within the filter table.
> You can expect a global change to be quite difficult, I guess... :-(

Thanks, I didn't know this, I'm going to change this to refer to
the mangle table. This still leaves the option of a warning, but
want I really wanted to know was whether anyone cares. From a
consistency point of view it should be restricted, for the
functionality it doesn't matter.
