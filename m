From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH][RESEND] addrtype match
Date: 07 May 2003 18:52:42 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1052326362.24219.14.camel@tux.rsn.bth.se>
References: <3EA7E543.9040401@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@gnumonks.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3EA7E543.9040401@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2003-04-24 at 15:23, Patrick McHardy wrote:
> This patch adds support for the addrtype match which matches
> what routing thinks of an address. Since last post i renamed the
> options again, they are now named src-type and dst-type which
> fits better with other matches.
> 
> Is there a chance this is going to be accepted ? Otherwise i'll
> stop resending.

I've added this to cvs. Sorry about the delay.

-- 
/Martin
