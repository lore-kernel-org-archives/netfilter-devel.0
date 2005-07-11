From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH 1/2] flow match
Date: Mon, 11 Jul 2005 17:10:04 +0100
Message-ID: <42D299DC.7000000@ufomechanic.net>
References: <20050628234912.GB23662@wsc.edu> <42D28B7F.7090103@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42D28B7F.7090103@ufomechanic.net>
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
> Thanks Josh;
> 
> Veridict:
> 
> Useful=Yes
> 
> The first patch applies OK. but the second (timer patch) gives compile
> errors thus:
> 
> net/ipv4/netfilter/ipt_timer.c: In function `match':

I fixed this by changing net/ipv4/netfilter/ipt_timer.c to replace
READ_LOCK with read_lock_bh and READ_UNLOCK with read_unlock_bh etc.

That did the trick

Amin
