From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Open Port match
Date: Fri, 06 May 2005 17:22:24 +0200
Message-ID: <427B8BB0.3090109@trash.net>
References: <1115264925.2118.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: works_five_times545.epsilon.ssokolow@spamgourmet.com,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1115264925.2118.3.camel@localhost.localdomain>
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

Rusty Russell wrote:
> Ssokolow asked for this.  Someone can enhance to cover UDP and put in
> patch-o-matic if they're enthusiastic about it.

I think this feature should be added to the owner match. I have a couple
of patches coming up that add hooks to the protocols, which get the
socket as argument. This gets rid of exporting the lookup-functions.
I'll post them within the next couple of days.

Regards
Patrick
