From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.4.23 masquerading broken?
Date: Sun, 11 Jan 2004 11:40:37 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40012825.60405@trash.net>
References: <20031202165653.GJ615@gaast.net> <3FCCCB02.5070203@trash.net> <20040110215954.GC20706@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Wilmer van der Gaast <lintux@lintux.cx>,
 linux-kernel@vger.kernel.org,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040110215954.GC20706@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:

>This seems to be the same as 
>http://www.ussg.iu.edu/hypermail/linux/kernel/0312.0/0465.html
>and https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=144
>
>I've committed the proposed fix (from #144) into patch-o-matic/pending.
>
>Comments?
>  
>

I don't know if reverting to 2.4.22 is the correct fix, the change was made after this
mail from Alexey http://marc.theaimsgroup.com/?l=linux-net&m=105915597804604&w=2 ,
he states that giving out ifindex is a bug. I don't understand the problem yet but I'm
looking into it.

BTW: Why do we need a route lookup at all ? Couldn't we just use the first address on 
dev->in_dev->ifa_list ?

Best regards,
Patrick
