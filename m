From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libnfnetlink
Date: Mon, 09 Oct 2006 17:14:51 +0200
Message-ID: <452A676B.80808@netfilter.org>
References: <1160406470.452a65c62a14c@www.domainfactory-webmail.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Maik Hentsche <netfilter@mm-double.de>
In-Reply-To: <1160406470.452a65c62a14c@www.domainfactory-webmail.de>
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

Maik,

Maik Hentsche wrote:
> Hallo pablo, hello readers of the list,
> attached is a patch, that corrects another error in the comments of
> libnfnetlink. nfnl_send uses send_to and thus returns the number of
> send bytes instead of 0 in case of success. Pardon me for bothering you
> with such trivial patches, but I think, as long as the
> sgml-documentation isn't finished (I'm working on it), developers using
> the lib might need those comments.

Thanks it is worth the fix, I'll add it to my patchlet for libnfnetlink.

--
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
