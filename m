From: Patrick McHardy <kaber@trash.net>
Subject: Re: ERROR target in /proc/net/ip_tables_targets
Date: Thu, 25 Mar 2004 23:55:50 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40636376.3050707@trash.net>
References: <20031127042854.GE1084@eychenne.org> <Pine.LNX.4.58.0311270536590.30430@gw.localnet> <20031127050742.GB2740@eychenne.org> <Pine.LNX.4.58.0311270612230.30430@gw.localnet> <20040325201757.GN1115@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <20040325201757.GN1115@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Herve Eychenne wrote:
>
> $ uname -a
> Linux comet 2.6.4 #29 Thu Mar 18 19:42:39 CET 2004 i686 GNU/Linux
> 
> And it's still there. Is there patch? If yes, it has not been
> submitted upstream...

Thanks for reminding me, it seems I lost the last patch.
I've added a new one to pom-ng as proc-no-internal-targets.

Regards
Patrick


> 
>  Herve
> 
