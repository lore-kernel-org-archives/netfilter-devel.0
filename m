From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: only first TCP SYN packet consulted in nat table chains - bug
 or feature?
Date: Tue, 22 Jun 2004 17:26:42 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406221724120.23944-100000@filer.marasystems.com>
References: <1087911233.7536.2.camel@coati>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1087911233.7536.2.camel@coati>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 22 Jun 2004, Eric Leblond wrote:

> This extension is one more time useful to someone. Does somebody know
> why it has not been included into the standard kernel ?

It has been proposed a number of times, but never seems to get the final 
goahead. And right now is not a good time as changes is again discussed.

Hopefully the third revision discussed a few days ago will finally make
it.. (changes in mark mask logics to express a much richer set of
operations).

Regards
Henrik
