From: Patrick McHardy <kaber@trash.net>
Subject: Re: (no subject)
Date: Thu, 10 Mar 2005 03:16:15 +0100
Message-ID: <422FADEF.6080505@trash.net>
References: <310424129.24052@njupt.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
To: dpeng <y030730@njupt.edu.cn>
In-Reply-To: <310424129.24052@njupt.edu.cn>
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

dpeng wrote:
> hello,
> 	In order to understanding the Gred qdisc,i am reading sch_gred.c(linux/net/sched) .Is there anyone explain the element"u8 eqp" which belong to "struct gred_sched" to me?

This is not really relevant to this list (netdev@oss.sgi
or linux-net@vger.kernel.org are more appropriate), and
please don't send HTML mail and include a proper subject
line. Anyway, according to this comment in gred_change(),
"eqp" is set in WRED mode.

                        if (table->tab[i]->prio == q->prio ){
                                /* WRED mode detected */
                                table->eqp=1;
                                break;


Regards
Patrick
