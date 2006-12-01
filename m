From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack allocation issue
Date: Fri, 01 Dec 2006 18:43:16 +0100
Message-ID: <457069B4.9040807@trash.net>
References: <456EFC8F.2000507@trash.net>
	<Pine.LNX.4.64.0612010847390.3907@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.64.0612010847390.3907@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:
>>Last thing is the helper renaming, any objections to prefix
>>all helpers with nf_conntrack_helper_?
> 
> 
> Fine, that'll make the code more clear.

Actually I only wanted to rename the files because I kept getting
annoyed by tab completion on the pptp and H.323 helpers requiring
5 interactions. Prefixing everything with nf_conntrack_helper_
turned out quite ugly (way too long), so I now did the opposite
and renamed PPTP and H.323 to be more consistent with the other
helpers.
