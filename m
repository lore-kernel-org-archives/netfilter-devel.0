From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] [PATCH] ctnetlink updates
Date: Sun, 17 Apr 2005 17:07:48 +0200
Message-ID: <42627BC4.8070103@trash.net>
References: <424747E3.7000300@eurodev.net> <42502F8D.5030504@trash.net>
	<4254258E.5000204@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4254258E.5000204@eurodev.net>
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

Pablo Neira wrote:
> Now I've changed my mind :).
> 
> I think that we can identify a connection with both the original and 
> reply tuple. Since a connection is represented by means of a conntrack, 
> if a user kills a conntrack via ctnetlink, he's willing to kill the 
> connection that the conntrack represents, and not to such conntrack itself.

It depends on by what criteria the user selects the conntrack. I might
choose to kill/remark/... every connection that has transfered more than
X bytes, in which case I don't want to touch a new connection with the
same tuples that has transfered less than X. How can we handle this
and similar cases without an identifier that is unique over time?

Regards
Patrick
