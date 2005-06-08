From: Patrick McHardy <kaber@trash.net>
Subject: Re: NAT reservations
Date: Wed, 08 Jun 2005 21:02:55 +0200
Message-ID: <42A740DF.20107@trash.net>
References: <42A73CC2.4060608@trash.net> <1118256945.13271.6.camel@krak.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <1118256945.13271.6.camel@krak.odu>
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

KOVACS Krisztian wrote:
>   Unfortunately I did not have time to port the patch for new NAT code
> of 2.6.11, but a 2.6.10 version can be found in the latest tproxy
> release tarball:
> 
>   http://www.balabit.com/downloads/tproxy/linux-2.6/
> 
>   That's the most up-to-date version available.

Thanks.

>   Plus, I think the whole patch would require a thorough refresh, I
> don't really like the idea of that extra hash table, etc. (And even that
> hash table is poorly implemented, obsolete hash function, etc.)

I haven't looked closer at it yet, but I'll probably port it to
2.6.12-rc in the next couple of days, perhaps a good idea will hit me :)

Regards
Patrick
