From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] ct-event API port to 2.6.11
Date: Wed, 06 Apr 2005 20:11:43 +0200
Message-ID: <4254265F.6080607@eurodev.net>
References: <424747D5.8060500@eurodev.net> <42502B1B.7090309@trash.net>
	<42540839.8020405@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <42540839.8020405@ufomechanic.net>
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

Amin Azez wrote:
> It appears that pom-ng nfnetlink-ctnetlink-0.13 (ported by Pablo?) 
> requires ct-event (although this is not listed in the pom-ng dependancies).
> 
> Pablo, can you confirm this?

I've just merged Harald's and my port. You can get it from:

http://people.netfilter.org/~pablo/patches/nfnetlink-conntrack-0.50-2.6.11/

--
Pablo
