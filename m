From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: match target project
Date: Tue, 10 Aug 2004 19:56:21 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408101955320.11740@filer.marasystems.com>
References: <1092154889.4261.436.camel@porky>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1092154889.4261.436.camel@porky>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 10 Aug 2004, Eric Leblond wrote:

> I was looking for a match that could be able to match one packet per
> connection each N min interval.

Is connection in this scope the same as a ip_conntrack connection?

> It seems, it does not exist, so the next question is :
> 	Is it possible to develop such a match ?

Yes.

> 	If yes, is it a huge work ?

Not really.

Regards
Henrik
